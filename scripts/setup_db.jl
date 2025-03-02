using LibPQ, DBInterface, DataFrames, Parquet, Tables, DotEnv, Dates

DotEnv.config(joinpath(@__DIR__, "..", ".env"))

function load_parquet_to_df(file::String)
    return DataFrame(read_parquet(file))
end

function replace_single_quotes(value::String)
    return replace(value, "'" => "''")
end

function get_sql_type(julia_type)
    base_type = Base.nonmissingtype(julia_type)
    if base_type <: Int || base_type <: Int32 || base_type <: Int64
        return "INTEGER"
    elseif base_type <: AbstractFloat || base_type <: Float32 || base_type <: Float64
        return "FLOAT"
    elseif base_type <: Dates.AbstractTime
        return "DATE"
    elseif base_type <: AbstractString
        return "TEXT"
    else
        return "TEXT"
    end
end

db_name = ENV["DB_NAME"]
db_user = ENV["DB_USER"]
db_password = ENV["DB_PASSWORD"]
db_host = ENV["DB_HOST"]

connection_string = "dbname=$db_name user=$db_user password=$db_password host=$db_host"
connection = DBInterface.connect(LibPQ.Connection, connection_string)

DBInterface.execute(
    connection,
    """
    CREATE TABLE IF NOT EXISTS cohort (
        subject_id INTEGER,
        cohort_definition_id INTEGER,
        cohort_start_date DATE,
        cohort_end_date DATE
    )
    """
)

raw_data_dir = joinpath(@__DIR__, "..", "data", "exp_raw")

for file in readdir(raw_data_dir, join=true)
    if endswith(file, ".parquet")
        base_name = basename(file)
        table_name = splitext(base_name)[1]
        println("Loading $base_name into table $table_name")

        df = load_parquet_to_df(file)
        DBInterface.execute(connection, "DROP TABLE IF EXISTS $table_name")

        column_definitions = join(["$column_name $(get_sql_type(eltype(df[!, column_name])))" for column_name in names(df)],", ")
        DBInterface.execute(connection, "CREATE TABLE $table_name ($column_definitions)")

        # Load data in batches - useful for large datasets
        batch_size = 1000
        for i in 1:batch_size:nrow(df)
            batch = df[i:min(i + batch_size - 1, nrow(df)), :]
            values_list = []
            for row in eachrow(batch)
                values = join([ismissing(row[col]) ? "NULL" : "'$(replace_single_quotes(string(row[col])))'" for col in names(df)],", ")
                push!(values_list, "($values)")
            end
            if !isempty(values_list)
                insert_query = "INSERT INTO $table_name VALUES " * join(values_list, ", ")
                DBInterface.execute(connection, insert_query)
            end
        end

        result = DBInterface.execute(connection, "SELECT COUNT(*) FROM $table_name")
        row_count = DataFrame(result)[1, 1]
        col_count = length(names(df))
        println("Table $table_name loaded with $row_count rows and $col_count columns.")
    end
end

println("All Parquet files loaded into PostgreSQL!")
DBInterface.close!(connection)
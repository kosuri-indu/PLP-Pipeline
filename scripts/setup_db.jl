
using DuckDB, DBInterface

connection = DBInterface.connect(DuckDB.DB, "data/omop.duckdb")

# the directory where the raw data is stored
raw_data_dir = joinpath(@__DIR__, "..", "data", "exp_raw")

DBInterface.execute(
    connection,
    """
    CREATE TABLE IF NOT EXISTS cohort (
        cohort_definition_id INTEGER,
        subject_id INTEGER,
        cohort_start_date DATE,
        cohort_end_date DATE
    )
    """
)
parquet_files = readdir(raw_data_dir, join=true)

for file in parquet_files
    base_name = basename(file)
    table_name = splitext(base_name)[1]
    println("Loading $base_name into table '$table_name'")

    DBInterface.execute(connection, "CREATE OR REPLACE TABLE $table_name AS SELECT * FROM read_parquet('$file')")
end

println("All Parquet files loaded into DuckDB")
DBInterface.close!(connection)
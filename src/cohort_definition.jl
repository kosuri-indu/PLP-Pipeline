using OHDSICohortExpressions: translate
using FunSQL, DBInterface, DuckDB, JSON, DataFrames, DotEnv, Parquet
using Base.Filesystem: basename

function load_cohort_definition(json_path)
    json_data = JSON.parsefile(json_path)

    if haskey(json_data, "CensoringCriteria")
        delete!(json_data, "CensoringCriteria")
        base_name = basename(json_path)
        println("Removed CensoringCriteria from $base_name")
    end

    return JSON.json(json_data)
end

base_dir = @__DIR__
target_cohort_json_path = joinpath(base_dir, "..", "data", "cohort_definitions", "Atrial_Fibrillation.json")
outcome_cohort_json_path = joinpath(base_dir, "..", "data", "cohort_definitions", "Ischemic_Stroke.json")

target_cohort_definition = load_cohort_definition(target_cohort_json_path)
outcome_cohort_definition = load_cohort_definition(outcome_cohort_json_path)

db_path = joinpath(@__DIR__, "..", "data", "omop.duckdb")
connection = DBInterface.connect(DuckDB.DB, db_path)

DBInterface.execute(connection, "DROP TABLE IF EXISTS cohort")

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
println("Cohort table created successfully!")

function process_cohort(cohort_definition, cohort_id)
    try
        println("\nProcessing Cohort $cohort_id...")

        sql = translate(cohort_definition, cohort_definition_id=cohort_id, dialect=:duckdb)

        if isempty(strip(sql))
            println(" Generated SQL is empty for cohort $cohort_id, hence skipping execution.")
            return
        end

        statements = split(sql, ";")
        for stmt in statements
            stmt = replace(strip(stmt), r"\s+" => " ")
            if !isempty(stmt)
                try
                    DBInterface.execute(connection, stmt)
                catch e
                    println("Error statement: ", e)
                end
            end
        end

        insert_query = """
            INSERT INTO cohort (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date)
            SELECT $cohort_id, person_id, start_date, end_date FROM temp_1
        """

        DBInterface.execute(connection, insert_query)

        println("Cohort $cohort_id inserted successfully!")
        DBInterface.execute(connection, "DROP TABLE IF EXISTS temp_1")
    catch e
        println("Error processing cohort $cohort_id: ", e)
    end
end

process_cohort(target_cohort_definition, 1)
process_cohort(outcome_cohort_definition, 2)

target_df = DataFrame(DBInterface.execute(connection, "SELECT * FROM cohort WHERE cohort_definition_id = 1"))
outcome_df = DataFrame(DBInterface.execute(connection, "SELECT * FROM cohort WHERE cohort_definition_id = 2"))

println("\nTarget Cohort Results:\n", target_df)
println("Outcome Cohort Results:\n", outcome_df)

DBInterface.close!(connection)
println("\nCohort definitions processed successfully!")
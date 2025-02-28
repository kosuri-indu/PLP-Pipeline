using OHDSICohortExpressions: translate
using FunSQL, DBInterface, DuckDB, JSON, DataFrames

function load_cohort_definition(json_path)
    return read(json_path, String)
end

base_dir = @__DIR__

target_cohort_json_path = joinpath(base_dir, "..", "data", "cohort_definitions", "Atrial_Fibrillation.json")
outcome_cohort_json_path = joinpath(base_dir, "..", "data", "cohort_definitions", "Ischemic_Stroke.json")

target_cohort_definition = load_cohort_definition(target_cohort_json_path)
outcome_cohort_definition = load_cohort_definition(outcome_cohort_json_path)

target_query = translate(target_cohort_definition, cohort_definition_id=1, dialect="duckdb")
outcome_query = translate(outcome_cohort_definition, cohort_definition_id=2, dialect="duckdb")

db = DBInterface.connect(DuckDB.DB, joinpath(base_dir, "..", "data", "omop.duckdb"))

target_result = DBInterface.execute(db, target_query)
outcome_result = DBInterface.execute(db, outcome_query)

target_df = DataFrame(target_result)
outcome_df = DataFrame(outcome_result)

println("Target Cohort Results:\n", target_df)
println("Outcome Cohort Results:\n", outcome_df)

DBInterface.close!(db)

println("Cohort definitions processed successfully!")
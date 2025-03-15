using DrWatson
@quickactivate "PLP-Pipeline"

import Base.Filesystem:
  basename
import DBInterface:
  connect,
  execute
import FunSQL:
  reflect,
  render
import OHDSICohortExpressions:
  translate

using DuckDB
using DataFrames

target_cohort_json_path = datadir("exp_raw", "definitions", "Hypertension.json")
outcome_cohort_json_path = datadir("exp_raw", "definitions", "Diabetes.json")

target_cohort_definition = read(target_cohort_json_path, String)
outcome_cohort_definition = read(outcome_cohort_json_path, String)

connection = DBInterface.connect(DuckDB.DB, datadir("exp_raw", "synthea_1M_3YR.duckdb"))

function process_cohort(cohort_definition, cohort_definition_id, conn;)

    catalog = reflect(
        connection;
        schema = "dbt_synthea_dev",
        dialect = :duckdb
    )

    fun_sql = translate(    
      cohort_definition,    
      cohort_definition_id = cohort_definition_id);

    sql = render(catalog, fun_sql);

    res = execute(conn,    
      """    
      INSERT INTO        
        dbt_synthea_dev.cohort    
      SELECT        
        *    
      FROM        
        ($sql) 
      AS 
        foo;    
      """
    )
end

process_cohort(target_cohort_definition, 1, connection)
process_cohort(outcome_cohort_definition, 2, connection)

target_df = DataFrame(DBInterface.execute(connection, "SELECT * FROM dbt_synthea_dev.cohort WHERE cohort_definition_id = 1"))
outcome_df = DataFrame(DBInterface.execute(connection, "SELECT * FROM dbt_synthea_dev.cohort WHERE cohort_definition_id = 2"))

# println("\nTarget Cohort Results:\n", target_df)
# println("Outcome Cohort Results:\n", outcome_df)

DBInterface.close!(connection)

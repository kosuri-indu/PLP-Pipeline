using DrWatson
@quickactivate "PLP-Pipeline"

import DBInterface: 
    connect, 
    close!, 
    execute
import DuckDB: 
    DB
import DataFrames: 
    DataFrame, 
    outerjoin
import CSV

connection = connect(DB, datadir("exp_raw", "synthea_1M_3YR.duckdb"))

const SCHEMA = "dbt_synthea_dev"
const COHORT_TABLE = "cohort"
const TARGET_COHORT_ID = 1  # hypertension cohort
const WINDOW = 365  # 1-year history window

# Demographics: year of birth, gender, race, ethnicity
demographics_query = """
SELECT c.subject_id, 
       p.year_of_birth, 
       p.gender_concept_id, 
       p.race_concept_id,
       p.ethnicity_concept_id
FROM $SCHEMA.$COHORT_TABLE c
JOIN $SCHEMA.person p ON c.subject_id = p.person_id
WHERE c.cohort_definition_id = $TARGET_COHORT_ID
"""
demographics_df = execute(connection, demographics_query) |> DataFrame

# Conditions: count of parent & child conditions before index
conditions_query = """
SELECT c.subject_id, 
       MAX(co.condition_status_concept_id) AS max_condition_status,
       COUNT(DISTINCT ca.ancestor_concept_id) AS condition_count
FROM $SCHEMA.$COHORT_TABLE c
JOIN $SCHEMA.concept_ancestor ca ON co.condition_concept_id = ca.descendant_concept_id
JOIN $SCHEMA.condition_occurrence co ON c.subject_id = co.person_id
WHERE c.cohort_definition_id = $TARGET_COHORT_ID
AND co.condition_start_date BETWEEN c.cohort_start_date - INTERVAL $WINDOW DAY AND c.cohort_start_date
GROUP BY c.subject_id
"""
conditions_df = execute(connection, conditions_query) |> DataFrame

# CSV.write(datadir("exp_pro", "plp_features.csv"), features_df)
# println("Feature extraction complete!")

close!(connection)

using DrWatson
@quickactivate "PLP-Pipeline"

import DBInterface:
    connect,
    close!,
    execute
import DuckDB:
    DB

connection = connect(DB, datadir("exp_raw", "omop.duckdb"))

execute(
    connection,
    """
    CREATE SCHEMA omopcdm;
    """
)

execute(
    connection,
    """
    CREATE TABLE dbt_synthea_dev.cohort (
        cohort_definition_id INTEGER,
        subject_id INTEGER,
        cohort_start_date DATE,
        cohort_end_date DATE
    )
    """
)

parquet_files = readdir(datadir("exp_raw"), join=true)
filter!(x -> occursin("parquet", x), parquet_files)

for file in parquet_files
    base_name = basename(file)
    table_name = splitext(base_name)[1]
    println("Loading $base_name into table 'omopcdm.$table_name'")

    execute(connection, "CREATE OR REPLACE TABLE omopcdm.$table_name AS SELECT * FROM read_parquet('$file')")
end

println("All Parquet files loaded into DuckDB")
close!(connection)

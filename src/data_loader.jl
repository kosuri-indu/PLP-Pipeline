using DrWatson
@quickactivate "PLP-Pipeline"

using DBInterface
using DuckDB
using PrettyTables

connection = DBInterface.connect(DuckDB.DB, datadir("exp_raw", "synthea_1M_3YR.duckdb"))

const SCHEMA = "dbt_synthea_dev"

function test_data()
    tables_query = "SELECT table_name FROM information_schema.tables WHERE table_schema = '$SCHEMA'"
    tables_result = DBInterface.execute(connection, tables_query)
    tables = [row[1] for row in tables_result]

    println("Tables in database under schema '$SCHEMA':")
    println(tables)

    for table in tables

        # skipping staging tables
        if startswith(table, "stg_")
            continue
        end

        println("Checking: $table")
        query = "SELECT * FROM $SCHEMA.$table LIMIT 5"
        result = DBInterface.execute(connection, query)
        pretty_table(result)
        println("\n")
    end
end

test_data()

DBInterface.close!(connection)

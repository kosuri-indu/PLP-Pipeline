using DuckDB, PrettyTables

connection = DBInterface.connect(DuckDB.DB, "data/omop.duckdb")

function test_data()
    # few example tables for querying
    tables = [
        "concept", "concept_relationship", "condition_occurrence", "death",
        "device_exposure", "drug_exposure", "measurement", "observation", "observation_period", "person", "procedure_occurrence", "visit_occurrence"
    ]

    for table in tables
        println("Checking: $table")
        query = "SELECT * FROM $table LIMIT 5"
        result = DBInterface.execute(connection, query)
        pretty_table(result)
        println("\n")
    end
end

test_data()

using DuckDB, DBInterface, PrettyTables

# Connect to DuckDB
connection = DBInterface.connect(DuckDB.DB, "data/omop.duckdb")

function test_data()

    # get all mapped concept_id_2 values
    query1 = """SELECT DISTINCT concept_id_2
                FROM concept_relationship
                WHERE concept_id_1 IN (372924, 443454, 441874, 375557);"""

    result1 = DBInterface.execute(connection, query1)
    concept_ids = [row[1] for row in result1]
    println("Mapped concept IDs: ", concept_ids, "\n")

    concept_id_str = join(concept_ids, ", ")

    if isempty(concept_id_str)
        println("No mapped concept IDs found! Exiting.")
        return
    end

    # check if these concept IDs exist in condition_occurrence
    query2 = """SELECT DISTINCT condition_concept_id
                FROM condition_occurrence
                WHERE condition_concept_id IN ($concept_id_str);"""

    println("\nChecking if mapped concepts exist in condition_occurrence...")
    result2 = DBInterface.execute(connection, query2)
    pretty_table(result2)

    # check if these concept IDs exist in concept table
    query3 = """SELECT DISTINCT concept_id, concept_code, vocabulary_id, concept_name
                FROM concept
                WHERE concept_id IN ($concept_id_str);"""

    println("\nChecking if mapped concepts exist in concept table...")
    result3 = DBInterface.execute(connection, query3)
    pretty_table(result3)

    # find descendant concepts in concept_ancestor
    query4 = """SELECT DISTINCT descendant_concept_id
                FROM concept_ancestor
                WHERE ancestor_concept_id IN ($concept_id_str);"""

    println("\nFetching descendant concept IDs from concept_ancestor...")
    result4 = DBInterface.execute(connection, query4)
    descendant_concepts = [row[1] for row in result4]
    println("Descendant concept IDs: ", length(descendant_concepts), "\n")

    descendant_concept_str = join(descendant_concepts, ", ")

    if isempty(descendant_concept_str)
        println("No descendant concepts found.")
    else
        # check if descendant concepts exist in condition_occurrence
        query5 = """SELECT DISTINCT condition_concept_id
                    FROM condition_occurrence
                    WHERE condition_concept_id IN ($descendant_concept_str);"""

        println("\nChecking if descendant concepts exist in condition_occurrence...")
        result5 = DBInterface.execute(connection, query5)
        pretty_table(result5)
    end
end

test_data()
DBInterface.close!(connection)
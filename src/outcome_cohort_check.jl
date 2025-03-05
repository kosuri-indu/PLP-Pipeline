using DuckDB, DBInterface, DataFrames

conn = DBInterface.connect(DuckDB.DB, "data/omop.duckdb")

function get_stroke_concepts(conn)
    query = """
    SELECT concept_id, concept_name, domain_id, vocabulary_id, concept_class_id
    FROM concept 
    WHERE concept_name ILIKE '%Ischemic Stroke%'
    AND standard_concept = 'S';
    """
    return DBInterface.execute(conn, query) |> DataFrame
end

function check_condition_occurrence(conn, concept_ids)
    query = """
    SELECT DISTINCT condition_concept_id
    FROM condition_occurrence
    WHERE condition_concept_id IN ($concept_ids);
    """
    return DBInterface.execute(conn, query) |> DataFrame
end

function get_descendant_concepts(conn, concept_ids)
    query = """
    SELECT descendant_concept_id
    FROM concept_ancestor
    WHERE ancestor_concept_id IN ($concept_ids);
    """
    return DBInterface.execute(conn, query) |> DataFrame
end

function get_ancestor_concepts(conn, concept_ids)
    query = """
    SELECT ancestor_concept_id
    FROM concept_ancestor
    WHERE descendant_concept_id IN ($concept_ids);
    """
    return DBInterface.execute(conn, query) |> DataFrame
end

function get_synonyms(conn, concept_ids)
    query = """
    SELECT concept_id, concept_synonym_name
    FROM concept_synonym
    WHERE concept_id IN ($concept_ids);
    """
    return DBInterface.execute(conn, query) |> DataFrame
end

function get_concept_mappings(conn, concept_ids)
    query = """
    SELECT cr.concept_id_1, cr.concept_id_2, c1.concept_name AS source_name, c2.concept_name AS target_name
    FROM concept_relationship cr
    JOIN concept c1 ON cr.concept_id_1 = c1.concept_id
    JOIN concept c2 ON cr.concept_id_2 = c2.concept_id
    WHERE cr.concept_id_1 IN ($concept_ids) OR cr.concept_id_2 IN ($concept_ids);
    """
    return DBInterface.execute(conn, query) |> DataFrame
end

function check_patients_with_concepts(conn, concept_ids, concept_type)
    if isempty(concept_ids)
        println("\nNo $concept_type concepts found.")
        return DataFrame()
    end

    query = """
    SELECT person_id, condition_concept_id, condition_start_date, condition_end_date
    FROM condition_occurrence
    WHERE condition_concept_id IN ($concept_ids);
    """
    result = DBInterface.execute(conn, query) |> DataFrame
    println("\nPatients with Ischemic Stroke ($concept_type):", nrow(result))
    return result
end

original_concepts = get_stroke_concepts(conn)
println("Original Concept IDs:")
println(original_concepts)

concept_ids = join(original_concepts.concept_id, ", ")

condition_match = check_condition_occurrence(conn, concept_ids)
println("\nChecking if original concepts exist in condition_occurrence")
println(condition_match)

descendants = get_descendant_concepts(conn, concept_ids)
println("\nDescendant Concepts Found:", nrow(descendants))
descendant_ids = isempty(descendants) ? "" : join(descendants.descendant_concept_id, ", ")

ancestors = get_ancestor_concepts(conn, concept_ids)
println("\nAncestor Concepts Found:", nrow(ancestors))
ancestor_ids = isempty(ancestors) ? "" : join(ancestors.ancestor_concept_id, ", ")

synonyms = get_synonyms(conn, concept_ids)
println("\nSynonyms Found:", nrow(synonyms))
synonym_ids = isempty(synonyms) ? "" : join(synonyms.concept_id, ", ")

mappings = get_concept_mappings(conn, concept_ids)
println("\nConcept Mappings Found:", nrow(mappings))
mapping_ids = isempty(mappings) ? "" : join(unique(vcat(mappings.concept_id_1, mappings.concept_id_2)), ", ")

patients_descendants = check_patients_with_concepts(conn, descendant_ids, "Descendants")
patients_ancestors = check_patients_with_concepts(conn, ancestor_ids, "Ancestors")
patients_synonyms = check_patients_with_concepts(conn, synonym_ids, "Synonyms")
patients_mappings = check_patients_with_concepts(conn, mapping_ids, "Mappings")

DBInterface.close!(conn)
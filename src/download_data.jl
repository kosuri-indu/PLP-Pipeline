using Downloads
using DrWatson

# download the syntetic data from Zenodo
dataset_urls = Dict(
    "care_site.parquet" => "https://zenodo.org/record/14674051/files/care_site.parquet",
    "condition_occurrence.parquet" => "https://zenodo.org/record/14674051/files/condition_occurrence.parquet",
    "cost.parquet" => "https://zenodo.org/record/14674051/files/cost.parquet",
    "death.parquet" => "https://zenodo.org/record/14674051/files/death.parquet",
    "device_exposure.parquet" => "https://zenodo.org/record/14674051/files/device_exposure.parquet",
    "drug_exposure.parquet" => "https://zenodo.org/record/14674051/files/drug_exposure.parquet",
    "location.parquet" => "https://zenodo.org/record/14674051/files/location.parquet",
    "measurement.parquet" => "https://zenodo.org/record/14674051/files/measurement.parquet",
    "note.parquet" => "https://zenodo.org/record/14674051/files/note.parquet",
    "note_nlp.parquet" => "https://zenodo.org/record/14674051/files/note_nlp.parquet",
    "observation.parquet" => "https://zenodo.org/record/14674051/files/observation.parquet",
    "payer_plan_period.parquet" => "https://zenodo.org/record/14674051/files/payer_plan_period.parquet",
    "person.parquet" => "https://zenodo.org/record/14674051/files/person.parquet",
    "procedure_occurrence.parquet" => "https://zenodo.org/record/14674051/files/procedure_occurrence.parquet",
    "provider.parquet" => "https://zenodo.org/record/14674051/files/provider.parquet",
    "specimen.parquet" => "https://zenodo.org/record/14674051/files/specimen.parquet",
    "visit_occurrence.parquet" => "https://zenodo.org/record/14674051/files/visit_occurrence.parquet",
)

raw_data_dir = joinpath(@__DIR__, "..", "data", "exp_raw")
processed_data_dir = joinpath(@__DIR__, "..", "data", "exp_pro")

# is failing to download for large data files
for (filename, url) in dataset_urls
    path = joinpath(raw_data_dir, filename)
    if !isfile(path)
        println("Downloading $filename from $url")
        Downloads.download(url, path)
        println("Saved to $path")
    else
        println("$filename already exists")
    end
end

println("All raw data files downloaded successfully!")


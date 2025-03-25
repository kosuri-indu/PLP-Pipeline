using DrWatson
@quickactivate "PLP-Pipeline"

using DBInterface
using DuckDB

modules = [
    "data_loader.jl",
    "cohort_definition.jl",
    "feature_extraction.jl",
    "distribution_check.jl",
    "outcome_attach.jl",
    "preprocessing.jl",
    "train_model.jl"
]

for mod in modules
    println("\nProcessing: ", mod)
    include(joinpath("..", "src", mod))
    GC.gc() 
end
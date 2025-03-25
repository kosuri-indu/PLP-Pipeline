# PLP-Pipeline

This code base is using the [Julia Language](https://julialang.org/) and [DrWatson](https://juliadynamics.github.io/DrWatson.jl/stable/) to make a reproducible scientific project named PLP-Pipeline. It is authored by *kosuri-indu*, demonstrates a pipeline for patient-level prediction. Special thanks to [@TheCedarPrince](https://github.com/TheCedarPrince) for guiding this project.


## Getting Started

To (locally) reproduce this project, do the following:

1. Download the Code Base 
   *Note:* Raw data are not included in the repository. You will need to download them separately.

2. Set Up the Julia Environment
   Open a Julia console and execute:
   ```julia
   using Pkg
   Pkg.add("DrWatson")        # Install DrWatson globally
   Pkg.activate("path/to/this/project")
   Pkg.instantiate()          # Install all necessary packages

This will install all necessary packages for you to be able to run the scripts and everything should work out of the box, including correctly finding local paths.

You may notice that most scripts start with the commands:
```julia
using DrWatson
@quickactivate "PLP-Pipeline"
```
which auto-activate the project and enable local path handling from DrWatson.

## Usage

### Setting Up the Database

Set up the DuckDB database with your data by running:
```julia
julia> include("scripts/setup_db.jl")
```

### Running the Pipeline

To run the machine learning pipeline, use the `run_plp.jl` script:
```julia
julia> include("scripts/run_plp.jl")
```

## TODO List

- Documentation & Research
  - [x] Add initial documentation in the `_research` folder
  - [ ] Expand documentation with detailed research questions and hypotheses

- Core Pipeline Implementation
  - [x] Set up project structure with DrWatson
  - [x] Database setup (`setup_db.jl`)
  - [x] Data loading (`data_loader.jl`)
  - [x] Cohort definition (`cohort_definition.jl`)
  - [x] Feature extraction (`feature_extraction.jl`)
  - [x] Distribution check (`distribution_check.jl`)
  - [x] Outcome attachment (`outcome_attach.jl`)
  - [x] Data preprocessing (`preprocessing.jl`)
  - [x] Model training & evaluation (`train_model.jl`)

- Future Enhancements
  - [ ] Add robust error handling and logging
  - [ ] Refine research questions and incorporate additional clinical variables
  - [ ] Develop tests and expand documentation further

## References

- [OHDSI Patient-Level Prediction in R](https://ohdsi.github.io/PatientLevelPrediction/)
- Reps, J. M., Schuemie, M. J., Suchard, M. A., Ryan, P. B., & Rijnbeek, P. R. (2018). Design and implementation of a standardized framework to generate and evaluate patient-level prediction models using observational healthcare data. *Journal of the American Medical Informatics Association, 25*(8), 969–975. https://doi.org/10.1093/jamia/ocy032

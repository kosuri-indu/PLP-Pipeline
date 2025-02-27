# PLP-Pipeline

This code base is using the [Julia Language](https://julialang.org/) and [DrWatson](https://juliadynamics.github.io/DrWatson.jl/stable/) to make a reproducible scientific project named PLP-Pipeline. 

It is authored by kosuri-indu.

## Getting Started

To (locally) reproduce this project, do the following:

1. Download this code base. Notice that raw data are typically not included in the git-history and may need to be downloaded independently.
2. Open a Julia console and do:
   ```julia
   julia> using Pkg
   julia> Pkg.add("DrWatson") # install globally, for using `quickactivate`
   julia> Pkg.activate("path/to/this/project")
   julia> Pkg.instantiate()
   ```

This will install all necessary packages for you to be able to run the scripts and everything should work out of the box, including correctly finding local paths.

You may notice that most scripts start with the commands:
```julia
using DrWatson
@quickactivate "PLP-Pipeline"
```
which auto-activate the project and enable local path handling from DrWatson.

## Usage

### Downloading Data

To download the synthetic data from Zenodo, run the `download_data.jl` script:
```julia
julia> include("src/download_data.jl")
```
**Note**: As the data files are large, it is recommended to download them manually from [Zenodo](https://zenodo.org/record/14674051) and place them in the `data/exp_raw` directory.

### Setting Up the Database

To set up the DuckDB database with the downloaded data, run the `setup_db.jl` script:
```julia
julia> include("scripts/setup_db.jl")
```

### Running the Pipeline

To run the machine learning pipeline, use the `run_plp.jl` script:
```julia
julia> include("scripts/run_plp.jl")
```

## TODO List

- [x] Set up project structure
- [x] Add initial data download script
- [x] Add database setup script
- [ ] Implement data loading functions in `data_loader.jl`
- [ ] Implement cohort extraction in `cohort_extraction.jl`
- [ ] Implement feature engineering in `feature_engineering.jl`
- [ ] Implement machine learning pipeline in `ml_pipeline.jl`
- [ ] Add unit tests in `test/runtests.jl`
- [ ] Improve documentation in `_research` folder

## References

- [OHDSI Patient-Level Prediction in R](https://ohdsi.github.io/PatientLevelPrediction/)
- Reps, J. M., Schuemie, M. J., Suchard, M. A., Ryan, P. B., & Rijnbeek, P. R. (2018). Design and implementation of a standardized framework to generate and evaluate patient-level prediction models using observational healthcare data. *Journal of the American Medical Informatics Association, 25*(8), 969–975. https://doi.org/10.1093/jamia/ocy032
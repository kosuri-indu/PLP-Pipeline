# PLP Overview

PLP (Patient-Level Prediction) is about using historical patient data (like medical records) to predict future health events. This project aims to build a smart tool in Julia that helps doctors and researchers make these predictions faster and more accurately.

## What is OMOP CDM?

OMOP CDM (Observational Medical Outcomes Partnership Common Data Model) is a standard way of organizing patient data so different hospitals and researchers can use it easily. It helps in dealing with the challenges of medical data, which is often huge and messy, and stored in different ways across various hospitals.

![cdm54](https://github.com/user-attachments/assets/f6954bb1-7727-4d2b-bcd2-0f1919acd8de)

## How Do Julia Tools Help Implement This?

This project focuses on creating Julia-based tools that can:

- Read patient data from OMOP CDM
- Apply machine learning to find patterns
- Make predictions about future health events
- Test if the predictions are accurate
- Help doctors and researchers understand the results

PLP models use OMOP CDM to extract patient cohorts, preprocess data, and apply machine learning techniques for prediction.

## Suggested Tools


| Tool                        | Purpose                                      |
|-----------------------------|----------------------------------------------|
| DataFrames.jl           | For data manipulation and analysis           |
| MLJ.jl                  | For machine learning                         |
| OHDSICohortExpressions.jl | For working with OHDSI cohort expressions    |
| ATLAS                   | For cohort definition and analysis           |
| Makie.jl                | For data visualization                       |
| OMOPCDMCohortCreator.jl | For creating cohorts from OMOP CDM           |
| DBInterface.jl          | For database interactions                    |

### Database Loading

Recommended Julia packages for this task include:

- DuckDB.jl
- LibPQ.jl
- MySQL.jl

## References

- OHDSI Patient-Level Prediction in R: https://ohdsi.github.io/PatientLevelPrediction/
- Reps, J. M., Schuemie, M. J., Suchard, M. A., Ryan, P. B., & Rijnbeek, P. R. (2018). Design and implementation of a standardized framework to generate and evaluate patient-level prediction models using observational healthcare data. *Journal of the American Medical Informatics Association, 25*(8), 969–975. https://doi.org/10.1093/jamia/ocy032

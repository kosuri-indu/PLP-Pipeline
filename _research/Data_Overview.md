# Data Overview

## 1. Core Patient Demographics

| File Name         | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| person.parquet    | Contains patient-level demographic details (age, gender, etc.).       |
| death.parquet     | Records mortality data, which is important for survival analysis or mortality prediction. |

## 2. Clinical Events (Diagnosis, Procedures, & Observations)

| File Name                | Description                                                                 |
|--------------------------|-----------------------------------------------------------------------------|
| condition_occurrence.parquet | Records patient diagnoses (e.g., diabetes, hypertension).                |
| procedure_occurrence.parquet  | Details of medical procedures performed on patients.                    |
| observation.parquet      | Includes non-standardized observations (e.g., lifestyle factors, smoking status). |
| observation_period.parquet | Defines observation periods for each patient, indicating the time span during which data is collected. |

## 3. Medication Data

| File Name         | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| drug_exposure.parquet | Captures medications prescribed or administered to patients.             |

## 4. Healthcare Utilization (Visits)

| File Name         | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| visit_occurrence.parquet | Logs hospital visits, outpatient visits, and other patient encounters. |
              |

## 5. Measurements

| File Name         | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| measurement.parquet | Contains structured lab test results (e.g., blood pressure, cholesterol).  |

## 6. Vocabulary and Relationships

| File Name                | Description                                                                 |
|--------------------------|-----------------------------------------------------------------------------|
| concept.parquet          | Contains standardized medical concepts used across the dataset.             |
| concept_relationship.parquet | Defines relationships between different medical concepts.                |

## Reasoning for Choosing These Files

- Relevance to PLP Modeling: These files provide data on patient demographics, medical history, medication usage, healthcare encounters, and outcomes—all critical for training and validating patient-level prediction models.
- Alignment with OMOP CDM: The selected tables represent a subset of the full OMOP CDM, covering the most important categories needed for predictive modeling.
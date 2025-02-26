# Data Overview

## 1. Core Patient Demographics

| File Name         | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| person.parquet    | Contains patient-level demographic details (age, gender, race, etc.).       |
| location.parquet  | Maps patients to geographical locations.                                     |
| death.parquet     | Records mortality data, which is important for survival analysis or mortality prediction. |

## 2. Clinical Events (Diagnosis, Procedures, & Observations)

| File Name                | Description                                                                 |
|--------------------------|-----------------------------------------------------------------------------|
| condition_occurrence.parquet | Records patient diagnoses (e.g., diabetes, hypertension).                |
| procedure_occurrence.parquet  | Details of medical procedures performed on patients.                    |
| observation.parquet      | Includes non-standardized observations (e.g., lifestyle factors, smoking status). |

## 3. Medication and Treatment Data

| File Name         | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| drug_exposure.parquet | Captures medications prescribed or administered to patients.             |
| device_exposure.parquet | Records medical devices used by patients (e.g., pacemakers, insulin pumps). |
| specimen.parquet   | Stores laboratory specimen details.                                         |

## 4. Healthcare Utilization (Visits, Costs, Providers)

| File Name         | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| visit_occurrence.parquet | Logs hospital visits, outpatient visits, and other patient encounters. |
| provider.parquet   | Information on healthcare providers.                                       |
| care_site.parquet  | Details of hospitals, clinics, or healthcare facilities.                   |
| cost.parquet       | Contains cost-related information (important for health economics analysis). |
| payer_plan_period.parquet | Maps patients to insurance plans and coverage periods.               |

## 5. Lab Tests & Measurements

| File Name         | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| measurement.parquet | Contains structured lab test results (e.g., blood pressure, cholesterol).  |
| note.parquet       | Free-text clinical notes (useful for NLP-based insights).                  |
| note_nlp.parquet   | Extracted structured concepts from free-text clinical notes using NLP.     |

## Reasoning for Choosing These Files

- Relevance to PLP Modeling: These files provide data on patient demographics, medical history, medication usage, healthcare encounters, and outcomes—all critical for training and validating patient-level prediction models.
- Alignment with OMOP CDM: The selected tables represent a subset of the full OMOP CDM, covering the most important categories needed for predictive modeling.
- Focus on Structured Data with Some NLP: The inclusion of `note.parquet` and `note_nlp.parquet` suggests that there is some interest in leveraging unstructured clinical text data, but the focus remains on structured data (e.g., diagnoses, procedures, drugs).
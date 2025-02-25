# Standardized Prediction Framework

This framework provides a step-by-step process for building predictive models using patient data. It ensures consistency and reproducibility across different studies by standardizing the data, model training, and validation.

## 0. Prepare the Data  
- Convert raw healthcare data into the OMOP Common Data Model (CDM) to standardize the structure.  
- Use standardized vocabularies for conditions, drugs, procedures, and other clinical concepts.

## 1. Define the Prediction Problem  
To make predictions, we frame the problem as:  
> "Among (target population), which patients will develop (an outcome) during (a time-at-risk period)?"

- Target population: Who the model is for (e.g., patients starting depression treatment).  
- Outcome: The event we want to predict (e.g., stroke after starting depression treatment).  
- Time-at-risk period: The time range for prediction (e.g., from one day after treatment starts to one year later).  

Each patient is labeled based on whether the outcome occurs during the time-at-risk period. These labeled datasets are used to train the model.

## 2. Select the Dataset  
- Pick an observational dataset that follows the OMOP CDM format.  
- Ensure the dataset has enough patients and enough outcome occurrences for reliable model training.  
- If the outcome is too rare, model performance may be poor.

## 3. Choose Predictor Variables  
- The framework provides a library of standardized variables, which ensures models can be replicated across datasets.  
- Predictor variables include:  
  - Demographics (age, gender, index date)  
  - Clinical history (conditions, drugs, measurements, procedures, and observations)  
  - Time-based variables (e.g., records within 1 year before the index date)  
  - Hierarchical groupings (e.g., grouping similar conditions or medications)  

- Missing values are handled by assuming zero counts for absent records, but custom imputation can be added.

## 4. Train Machine Learning Models  
- The labeled dataset is split into a train set (default: 75%) and a test set (default: 25%).  
- Multiple machine learning models are trained and compared using cross-validation to find the best-performing model.  
- The model with the best hyper-parameters (optimized settings) is selected.

## 5. Validate the Model  
- Internal validation: Test the model on the same dataset it was trained on.  
- External validation: Test it on a different dataset to check real-world performance.  
- Evaluation metrics:  
  - Discrimination: How well the model separates patients with/without the outcome (measured by AUC).  
  - Calibration: How well predicted risks match actual risks (measured using calibration plots).  

using DrWatson
@quickactivate "PLP-Pipeline"

import CSV
import DataFrames: 
    DataFrame, 
    nrow
import CategoricalArrays: 
    categorical  
import MLJ: 
    partition
import Statistics: 
    mean, 
    std

function preprocess_data()
    df = CSV.read(datadir("exp_pro", "plp_features.csv"), DataFrame)

    # missing values set to 0
    df[!, :] .= coalesce.(df, 0)

    # standardizing numerical features (zero mean, unit variance)
    num_features = [:year_of_birth, :condition_count, :drug_count, :total_days_supply, :total_quantity, :max_common_route, :max_measurement_value, :max_common_unit, :procedure_count, :observation_count, :max_observation_value]

    # numerical features
    for col in num_features
        col_std = std(df[!, col])
        if col_std != 0
            df[!, col] .= (df[!, col] .- mean(df[!, col])) ./ col_std
        end
    end

    # encoding categorical variables
    df.gender_concept_id = categorical(df.gender_concept_id)
    df.race_concept_id = categorical(df.race_concept_id)
    df.ethnicity_concept_id = categorical(df.ethnicity_concept_id)

    # train-test split (80-20)
    train, test = partition(df, 0.8, shuffle=true)

    println("Train size: ", nrow(train), " | Test size: ", nrow(test))

    return train, test
end

train, test = preprocess_data()

CSV.write(datadir("exp_pro", "train.csv"), train)
CSV.write(datadir("exp_pro", "test.csv"), test)

println("Preprocessed data saved")

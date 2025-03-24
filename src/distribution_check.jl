using DrWatson
@quickactivate "PLP-Pipeline"

using CSV
import DataFrames: 
    DataFrame, 
    nrow, 
    names,
    describe
import Statistics: 
    mean, 
    std, 
    minimum, 
    maximum

function describe_features()
    df = CSV.read(datadir("exp_pro", "plp_features.csv"), DataFrame)
    println(describe(df))

    for col in names(df)
        col_data = df[!, col]
        println("Column: $col")
        println("- Total Count: ", nrow(df))
        println("- Missing Values: ", count(ismissing, col_data))
        if eltype(col_data) <: Number
            nonmissing = skipmissing(col_data)
            println("- Mean: ", mean(nonmissing))
            println("- Std Dev: ", std(nonmissing))
            println("- Min: ", minimum(nonmissing))
            println("- Max: ", maximum(nonmissing))
        else
            println("  Unique values: ", length(unique(col_data)))
        end
        println()
    end
end

describe_features()

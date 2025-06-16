"""
    missing_summary(df::DataFrame)

Adds a row and column to the dataframe that contains the percentage of missing values in
each column and row. Returns a pretty table with the percentage of missing values in the
last row and column highlighted.

!!! warning
    This function will not preserve the type of the dataframe, as it converts everything
    to a string for the pretty table. It is primarily used for quick visualizations. For
    getting the actual missing percentages, use the `missing_percentages` function instead.

# Arguments
- `df::DataFrame`: The dataframe to add the missing summary to.
"""
function missing_summary(df::DataFrame)
    # get the missing percentages
    pmissing_cols, pmissing_rows, total_missing = missing_percentages(df)
    # convert everything to string, including the dataframe
    df = string.(df)
    pmissing_cols = string.(round.(pmissing_cols, digits = 2))
    pmissing_rows = string.(round.(pmissing_rows, digits = 2))
    total_missing = string(round(total_missing, digits = 2))
    push!(pmissing_rows, total_missing) # add a row for the total
    # add the missing counts and rows to the dataframe
    df = vcat(df,
        DataFrame(
            Dict(name => value for (name, value) in zip(names(df), pmissing_cols))
        ))
    df = insertcols(df, :pmissing_rows => pmissing_rows)
    hl_t = Highlighter(
        (data, i, j) -> i == size(df, 1) && j == size(df, 2),
        Crayon(bold = true, foreground = :green)
    )
    hl_r = Highlighter((data, i, j) -> i == size(df, 1), Crayon(foreground = :red))
    hl_c = Highlighter((data, i, j) -> j == size(df, 2), Crayon(foreground = :blue))
    nrows = nrow(df)
    hlines = [0, 1, nrows, nrows + 1]
    row_labels = vcat(1:(nrows - 1), "pmissing_cols")
    return pretty_table(
        df,
        row_labels = row_labels,
        highlighters = (hl_t, hl_c, hl_r),
        hlines = hlines
    )
end

"""
    missing_percentages(df::DataFrame)

Returns the percentage of missing values in each column and row, as well as the total
percentage of missing values in the dataframe.

# Arguments
- `df::DataFrame`: The dataframe to calculate the missing percentages for.

# Returns
- `pmissing_cols::Vector{Float64}`: The percentage of missing values in each column.
- `pmissing_rows::Vector{Float64}`: The percentage of missing values in each row.
- `total_missing::Float64`: The total percentage of missing values in the dataframe.
"""
function missing_percentages(df::DataFrame)
    count_missing_cols = [count(ismissing, col) for col in eachcol(df)]
    count_missing_rows = [count(ismissing, row) for row in eachrow(df)]
    pmissing_cols = count_missing_cols ./ size(df, 1)
    pmissing_rows = count_missing_rows ./ size(df, 2)
    total_missing = (sum(count_missing_cols)) / (size(df, 1) * size(df, 2))
    return pmissing_cols, pmissing_rows, total_missing
end

"""
    check_mad(mat::Matrix{T}; dims::Int = 2) where {T <: Real}

Checks if the MAD (median absolute deviation) is zero for each column of a matrix.
If it is, then errors and displays the list of columns with zero MAD.

# Arguments
- `mat::Matrix{T}`: The matrix to check the MAD for.
"""
function check_mad(mat::Matrix{T}; dims::Int = 2) where {T <: Real}
    error_cols = String[]
    for i in axes(mat, dims)
        try
            check_mad(mat[:, i])
        catch
            push!(error_cols, string(i))
        end
    end
    if length(error_cols) > 0
        throw(ErrorException("The MAD (median absolute deviation) of the following " *
                             "slices along dimension $dims: $error_cols is zero, which " *
                             "implies that some of the data is very close to the median. " *
                             "the data is very close to the median. Please check your " *
                             "data."))
    end
end

"""
    check_mad(x::Vector{T}) where {T <: Real}

Checks if the MAD (median absolute deviation) is zero for a vector. If it is, then errors.

# Arguments
- `x::Vector{T}`: The vector to check the MAD for.
"""
function check_mad(x::Vector{T}) where {T <: Real}
    s = mad(x; normalize = true)
    if s == 0
        throw(ErrorException("The MAD (median absolute deviation) of this vector is zero, " *
                             "which implies that some of the data is very close to the " *
                             "median. Please check your data."))
    end
end

# utility function to copy data – copy is more performant than deepcopy
# but use deepcopy if copy fails
function trycopy(data)
    try
        copy(data)
    catch
        deepcopy(data)
    end
end

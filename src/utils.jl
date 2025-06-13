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
    return pretty_table(df, highlighters = (hl_t, hl_c, hl_r))
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

# copy is more performant than deepcopy, but use deepcopy if copy fails
function trycopy(data)
    try
        copy(data)
    catch
        deepcopy(data)
    end
end

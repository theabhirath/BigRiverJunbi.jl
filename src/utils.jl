"""
    missing_summary(df::DataFrame)

Adds a row and column to the dataframe that contains the percentage of missing values in
each column and row. Prints it to the console with the last row and column being
highlighted.
"""
# TODO: fix potential type mismatch for rows and columns
function missing_summary(df::DataFrame)
    count_missing_cols = [count(ismissing, col) for col in eachcol(df)]
    count_missing_rows = [count(ismissing, row) for row in eachrow(df)]
    # count missing values in each column
    pmissing_cols = count_missing_cols ./ size(df, 1)
    # count missing values in each row
    pmissing_rows = count_missing_rows ./ size(df, 2)
    total_missing = (sum(count_missing_cols)) / (size(df, 1) * size(df, 2))
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

# copy is more performant than deepcopy, but use deepcopy if copy fails
function trycopy(data)
    try
        copy(data)
    catch
        deepcopy(data)
    end
end

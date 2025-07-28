"""
    log_tx(df::DataFrame; base::Real = 2, constant::Real = 0,
           start_col::Int64 = 1, end_col::Int64 = size(df, 2))

Computes logarithm on a dataframe, adding a constant to all values (for instance, to avoid log(0)).
Default base is 2, default constant is 0.

# Arguments
- `df`: The dataframe to transform.
- `base`: The base of the logarithm. Default is 2.
- `constant`: The constant to add to all values. Default is 0.
- `start_col`: The column to start transforming from. Default is 1.
- `end_col`: The column to end transforming at. Default is the last column.
"""
function BigRiverJunbi.log_tx(
        df::DataFrame; base::Real = 2, constant::Real = 0,
        start_col::Int64 = 1, end_col::Int64 = size(df, 2)
    )
    transformed = DataFrame(
        BigRiverJunbi.log_tx(Matrix(df[:, start_col:end_col]); base, constant),
        Symbol.(names(df)[start_col:end_col])
    )
    return hcat(df[:, 1:(start_col - 1)], transformed, df[:, (end_col + 1):end])
end

"""
    meancenter_tx(df::DataFrame; start_col::Int64 = 1, end_col::Int64 = size(df, 2))

Mean centers a dataframe across the specified dimension. This requires that the matrix has
all positive values.

# Arguments
- `df`: The dataframe to transform.
- `dims`: The dimension to mean center across. Default is 1.
- `start_col`: The column to start transforming from. Default is 1.
- `end_col`: The column to end transforming at. Default is the last column.
"""
function BigRiverJunbi.meancenter_tx(
        df::DataFrame; start_col::Int64 = 1, end_col::Int64 = size(df, 2)
    )
    transformed = DataFrame(
        BigRiverJunbi.meancenter_tx(Matrix(df[:, start_col:end_col]); dims),
        Symbol.(names(df)[start_col:end_col])
    )
    return hcat(df[:, 1:(start_col - 1)], transformed, df[:, (end_col + 1):end])
end

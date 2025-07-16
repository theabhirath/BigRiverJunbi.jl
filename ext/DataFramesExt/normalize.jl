"""
    intnorm(df::DataFrame; lambda::Float64 = 1.0,
            start_col::Int64 = 1, end_col::Int64 = size(df, 2))

Total Area Normalization for each row or column. By default, it normalizes each row.
This requires that the matrix has all positive values.

# Arguments
- `df`: The dataframe to normalize.
- `lambda`: The lambda parameter for the normalization. Default is 1.
- `start_col`: The column to start normalizing from. Default is 1.
- `end_col`: The column to end normalizing at. Default is the last column.
"""
function BigRiverJunbi.intnorm(df::DataFrame; lambda::Real = 1,
        start_col::Int64 = 1, end_col::Int64 = size(df, 2))
    transformed = DataFrame(BigRiverJunbi.intnorm(Matrix(df[:, start_col:end_col]); lambda),
        Symbol.(names(df)[start_col:end_col]))
    return hcat(df[:, 1:(start_col - 1)], transformed, df[:, (end_col + 1):end])
end

"""
    pqnorm(df::DataFrame; lambda::Real = 1,
           start_col::Int64 = 1, end_col::Int64 = size(df, 2))

Performs a probabilistic quotient normalization (PQN) for sample intensities.
This assumes that the matrix is organized as samples x features and requires that the
matrix have all positive values.

# Arguments
- `df`: The dataframe to normalize.
- `lambda`: The lambda parameter for the normalization. Default is 1.
- `start_col`: The column to start normalizing from. Default is 1.
- `end_col`: The column to end normalizing at. Default is the last column.
"""
function BigRiverJunbi.pqnorm(df::DataFrame; lambda::Real = 1,
        start_col::Int64 = 1, end_col::Int64 = size(df, 2))
    transformed = DataFrame(BigRiverJunbi.pqnorm(Matrix(df[:, start_col:end_col]); lambda),
        Symbol.(names(df)[start_col:end_col]))
    return hcat(df[:, 1:(start_col - 1)], transformed, df[:, (end_col + 1):end])
end

"""
    quantilenorm(df::DataFrame; start_col::Int64 = 1, end_col::Int64 = size(df, 2))

Performs quantile normalization for sample intensities. This assumes
that the matrix is organized as samples x features.

# Arguments
- `df`: The dataframe to normalize.
- `start_col`: The column to start normalizing from. Default is 1.
- `end_col`: The column to end normalizing at. Default is the last column.
"""
function BigRiverJunbi.quantilenorm(
        df::DataFrame; start_col::Int64 = 1, end_col::Int64 = size(df, 2))
    transformed = DataFrame(BigRiverJunbi.quantilenorm(Matrix(df[:, start_col:end_col])),
        Symbol.(names(df)[start_col:end_col]))
    return hcat(df[:, 1:(start_col - 1)], transformed, df[:, (end_col + 1):end])
end

"""
    huberize(df::DataFrame; alpha::Real = 1,
             error_on_zero_mad::Bool = true,
             start_col::Int64 = 1, end_col::Int64 = size(df, 2))

Performs Huberization for sample intensities.

# Arguments
- `df`: The dataframe to normalize.
- `alpha`: The alpha parameter for Huberization. Default is 1.
- `error_on_zero_mad`: Whether to throw an error if the MAD is zero. Default is `true`.
- `start_col`: The column to start normalizing from. Default is 1.
- `end_col`: The column to end normalizing at. Default is the last column.

!!! warning
    If you set `error_on_zero_mad` to `false`, this function will return a result with NaN
    values if the MAD is zero. This can be useful if you are expecting this behavior and
    want to handle it yourself, but should be used with caution.
"""
function BigRiverJunbi.huberize(df::DataFrame; alpha::Real = 1,
        error_on_zero_mad::Bool = true,
        start_col::Int64 = 1, end_col::Int64 = size(df, 2))
    transformed = DataFrame(
        BigRiverJunbi.huberize(Matrix(df[:, start_col:end_col]); alpha, error_on_zero_mad),
        Symbol.(names(df)[start_col:end_col]))
    return hcat(df[:, 1:(start_col - 1)], transformed, df[:, (end_col + 1):end])
end

"""
    standardize(df::DataFrame; center::Bool = true,
                start_col::Int64 = 1, end_col::Int64 = size(df, 2))

Standardize a dataframe i.e. scale to unit variance, with the option of centering or not.

# Arguments
- `df`: The dataframe to standardize.
- `center`: Whether to center the data. Default is `true`.
- `start_col`: The column to start standardizing from. Default is 1.
- `end_col`: The column to end standardizing at. Default is the last column.
"""
function BigRiverJunbi.standardize(df::DataFrame; center::Bool = true,
        start_col::Int64 = 1, end_col::Int64 = size(df, 2))
    transformed = DataFrame(
        BigRiverJunbi.standardize(Matrix(df[:, start_col:end_col]); center),
        Symbol.(names(df)[start_col:end_col]))
    return hcat(df[:, 1:(start_col - 1)], transformed, df[:, (end_col + 1):end])
end

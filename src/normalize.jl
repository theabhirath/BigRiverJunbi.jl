"""
    intnorm(mat::Matrix{T}; dims::Int64 = 2, lambda::Float64 = 1.0) where T <: Real

Total Area Normalization for each row or column. By default, it normalizes each row.
This requires that the matrix has all positive values.

# Arguments
- `mat`: The matrix to normalize.
- `dims`: The dimension to normalize across. Default is 2.
- `lambda`: The lambda parameter for the normalization. Default is 1.0.

# Examples

```jldoctest
julia> mat = [0.5 1 2 3 3.5;
             7 3 5 1.5 3.5;
             8 2 5 6 9]
3×5 Matrix{Float64}:
 0.5  1.0  2.0  3.0  3.5
 7.0  3.0  5.0  1.5  3.5
 8.0  2.0  5.0  6.0  9.0

julia> BigRiverJunbi.intnorm(mat)
3×5 Matrix{Float64}:
 0.05      0.1        0.2       0.3    0.35
 0.35      0.15       0.25      0.075  0.175
 0.266667  0.0666667  0.166667  0.2    0.3
```
"""
function intnorm(mat::Matrix{T}; dims::Int64 = 2, lambda::Float64 = 1.0) where {T <: Real}
    # if matrix has any negative values, throw an error
    @assert all(mat .>= 0) "Matrix has negative values. Please remove negative values" *
                           " before normalizing."
    return mat ./ (lambda .* sum(mat; dims = dims))
end

"""
    pqnorm(mat::Matrix{Float64})

Performs a probabilistic quotient normalization (PQN) for sample intensities.
This assumes that the matrix is organized as samples x features and requires that the
matrix have all positive values.

# Arguments
- `mat`: The matrix to normalize.

# Examples

```jldoctest
julia> mat = [0.5 1 2 3 3.5;
             7 3 5 1.5 4;
             8 2 5 6 9]
3×5 Matrix{Float64}:
 0.5  1.0  2.0  3.0  3.5
 7.0  3.0  5.0  1.5  4.0
 8.0  2.0  5.0  6.0  9.0

julia> BigRiverJunbi.pqnorm(mat)
3×5 Matrix{Float64}:
 0.05      0.1        0.2       0.3   0.35
 0.28      0.12       0.2       0.06  0.16
 0.266667  0.0666667  0.166667  0.2   0.3
```
"""
function pqnorm(mat::Matrix{T}) where {T <: Real}
    # if matrix has any negative values, throw an error
    @assert all(mat .>= 0) "Matrix has negative values. Please remove negative values" *
                           " before normalizing."
    # Integral normalization
    mat = intnorm(mat; dims = 2)
    # Calculate the reference spectrum (default: median) of all samples
    ref_spec = median(mat; dims = 1)
    # Calculate the quotients of all variables of interest of the test spectrum 
    # with those of the reference spectrum.
    quotients = mat ./ ref_spec
    # Calculate the median of these quotients.
    med_quotients = median(quotients; dims = 2)
    # Divide all variables of the test spectrum by this median
    mat_norm = mat ./ med_quotients
    return mat_norm
end

"""
    quantilenorm(data::Matrix{T}) where T <: Real

Performs quantile normalization for sample intensities. This assumes
that the matrix is organized as samples x features.

# Arguments
- `data`: The matrix to normalize.

# Examples

```jldoctest
julia> mat = [0.5 1 2 3 3.5;
             7 3 5 1.5 3.5;
             8 2 5 6 9]
3×5 Matrix{Float64}:
 0.5  1.0  2.0  3.0  3.5
 7.0  3.0  5.0  1.5  3.5
 8.0  2.0  5.0  6.0  9.0

julia> BigRiverJunbi.quantilenorm(mat)
3×5 Matrix{Float64}:
 1.7  1.7  1.7  4.1  1.7
 4.1  6.2  4.1  1.7  1.7
 6.2  4.1  4.1  6.2  6.2
```
"""
function quantilenorm(data::Matrix{T}) where {T <: Real}
    # creates a matrix of ranks for each column
    ranks = reduce(hcat, StatsBase.competerank.(eachcol(data)))
    # sort each column by the ranks
    data_sorted = sort(data; dims = 1)
    # find the mean of each row and rank them
    data_mean = mean(data_sorted; dims = 2)
    data_sorted_idxs = sortperm(data_mean; dims = 1)
    data_mean_ranked = Dict(zip(data_sorted_idxs, data_mean))
    results = mapslices(ranks, dims = 1) do x
        get.(Ref(data_mean_ranked), x, missing)
    end
    return results
end

"""
    huberize(mat::Matrix{T}; alpha::Float64 = 1.0) where {T <: Real}

Performs Huberization for sample intensities.

# Arguments
- `mat`: The matrix to normalize.
- `alpha`: The alpha parameter for the Huberization. Default is 1.0.
"""
# TODO: add a example/doctest
function huberize(mat::Matrix{T}; alpha::Float64 = 1.0) where {T <: Real}
    return mapslices(mat, dims = 1) do x
        huberize(x; alpha)
    end
end

"""
    huberize(x::Vector{T}; alpha::Float64 = 1.0) where {T <: Real}

Performs Huberization for a single vector.

# Arguments
- `x`: The vector to Huberize.
- `alpha`: The alpha parameter for the Huberization. Default is 1.0.
"""
# TODO: decide on how to handle the case where the MAD is zero
function huberize(x::Vector{T}; alpha::Float64 = 1.0) where {T <: Real}
    med = median(x)
    s = mad(x; center = med, normalize = true)
    if s == 0
        @warn "The MAD (median absolute deviation) of the slice is zero, which implies" *
              "that some of the data along your chosen dimension is very close to the " *
              "median. This will return a matrix with NaN values. Please check your data."
    end
    z = (x .- med) ./ s
    l = huberloss.(z; alpha)
    x = sign.(z) .* sqrt.(2l)
    return med .+ s .* x
end

"""
    huberloss(x::Real; alpha::Float64 = 1.0)

Computes the Huber loss for a given value. This is defined as:

```math
L(x) = \\begin{cases}
    \\frac{1}{2}x^2 & \\text{if } |x| \\leq \\alpha \\\\
    \\alpha (|x| - \\frac{\\alpha^2}{2}) & \\text{if } |x| > \\alpha
\\end{cases}
```

# Arguments
- `x`: The value to compute the Huber loss for.
- `alpha`: The alpha parameter for the Huber loss. Default is 1.0.
"""
function huberloss(x::Real; alpha::Float64 = 1.0)
    @assert alpha>0 "Huber crossover parameter alpha must be positive."
    d = abs(x)
    if d <= alpha
        return d^2 / 2
    else
        return alpha * (d - alpha^2 / 2)
    end
end

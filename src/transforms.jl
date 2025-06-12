"""
    log2_tx(mat::Matrix{Float64}; eps::Float64 = 1.0)

Computes logarithm base 2 on a matrix, adding a constant to all zero values to avoid log(0).

# Arguments
- `mat::Matrix{Float64}`: The matrix to transform.
- `eps::Float64`: The constant to add to all zero values. Default is 1.0.

# Examples

```jldoctest
julia> mat = [0.5 1 2 3 3.5;
             7 3 5 0 3.5;
             8 2 5 6 0]
3×5 Matrix{Float64}:
 0.5  1.0  2.0  3.0  3.5
 7.0  3.0  5.0  0.0  3.5
 8.0  2.0  5.0  6.0  0.0

julia> BigRiverJunbi.log2_tx(mat)
3×5 Matrix{Float64}:
 -1.0      0.0      1.0      1.58496  1.80735
  2.80735  1.58496  2.32193  0.0      1.80735
  3.0      1.0      2.32193  2.58496  0.0
```
"""
function log2_tx(mat::Matrix{T}; eps::Float64 = 1.0) where {T <: Real}
    # add eps to all zero values to avoid log(0)
    mat[mat .== 0] .+= eps
    return log2.(mat)
end

"""
    meancenter_tx(mat::Matrix{Float64}, dims::Int64 = 1)

Mean center a matrix across the specified dimension.

# Arguments
- `mat::Matrix{Float64}`: The matrix to transform.
- `dims::Int64`: The dimension to mean center across. Default is 1.

# Examples

```jldoctest
julia> mat = [0.5 1 2 3 3.5;
             7 3 5 1.5 3.5;
             8 2 5 6 9]
3×5 Matrix{Float64}:
 0.5  1.0  2.0  3.0  3.5
 7.0  3.0  5.0  1.5  3.5
 8.0  2.0  5.0  6.0  9.0

julia> BigRiverJunbi.mean_center(mat)
3×5 Matrix{Float64}:
 -4.66667  -1.0  -2.0  -0.5  -1.83333
  1.83333   1.0   1.0  -2.0  -1.83333
  2.83333   0.0   1.0   2.5   3.66667
```
"""
function mean_center(mat::Matrix{T}, dims::Int64 = 1) where {T <: Real}
    return mat .- mean(mat; dims)
end

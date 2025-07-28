@testitem "substitute and substitute!" begin
    using Test
    using BigRiverJunbi
    using Statistics

    # Test basic substitution with mean
    data = [1.0 missing 3.0; 4.0 5.0 missing; 7.0 8.0 9.0]
    data_copy = copy(data)

    # Test non-mutating version
    result = BigRiverJunbi.substitute(data, mean)
    expected_mean = mean([1.0, 4.0, 7.0, 5.0, 8.0, 3.0, 9.0])
    @test result[1, 2] ≈ expected_mean
    @test result[2, 3] ≈ expected_mean
    @test isequal(data, data_copy)  # use isequal for arrays with missing

    # Test mutating version
    BigRiverJunbi.substitute!(data, mean)
    @test data[1, 2] ≈ expected_mean
    @test data[2, 3] ≈ expected_mean

    # Test with dims parameter (dims=1 means row-wise operation)
    data = [1.0 missing 3.0; 4.0 5.0 missing]
    result = BigRiverJunbi.substitute(data, mean; dims = 1)
    # Row 1: mean([1.0, 3.0]) = 2.0 for missing value
    # Row 2: mean([4.0, 5.0]) = 4.5 for missing value
    @test result[1, 2] ≈ mean([1.0, 3.0])  # row 1 mean
    @test result[2, 3] ≈ mean([4.0, 5.0])  # row 2 mean

    # Test error case - all missing values
    data_all_missing = [missing missing; missing missing]
    @test_throws ErrorException BigRiverJunbi.substitute!(data_all_missing, mean)
end

@testitem "impute_zero and impute_zero!" begin
    using Test
    using BigRiverJunbi

    # Test basic functionality
    mat = [1.0 missing 3.0; 4.0 5.0 missing]
    mat_copy = copy(mat)

    # Test non-mutating version
    result = BigRiverJunbi.impute_zero(mat)
    @test result == [1.0 0.0 3.0; 4.0 5.0 0.0]
    @test isequal(mat, mat_copy)  # use isequal for arrays with missing

    # Test mutating version
    BigRiverJunbi.impute_zero!(mat)
    @test mat == [1.0 0.0 3.0; 4.0 5.0 0.0]

    # Test with all missing column
    mat_with_missing_col = [1.0 missing missing; 2.0 missing missing]
    result = BigRiverJunbi.impute_zero(mat_with_missing_col)
    @test result == [1.0 0.0 0.0; 2.0 0.0 0.0]
end

@testitem "impute_min and impute_min!" begin
    using Test
    using BigRiverJunbi
    using Statistics

    # Test basic functionality - default behavior uses global minimum
    mat = [1.0 missing 3.0; 4.0 5.0 missing; 7.0 8.0 9.0]
    mat_copy = copy(mat)

    # Test non-mutating version
    result = BigRiverJunbi.impute_min(mat)
    # Global minimum across all non-missing values is 1.0
    @test result[1, 2] ≈ 1.0  # global min = 1.0
    @test result[2, 3] ≈ 1.0  # global min = 1.0
    @test isequal(mat, mat_copy)  # use isequal for arrays with missing

    # Test mutating version
    BigRiverJunbi.impute_min!(mat)
    @test mat[1, 2] ≈ 1.0
    @test mat[2, 3] ≈ 1.0

    # Test row-wise behavior when dims=1 is explicitly specified
    result_rowwise = BigRiverJunbi.impute_min(mat_copy; dims=1)
    @test result_rowwise[1, 2] ≈ minimum([1.0, 3.0])  # row 1 min = 1.0
    @test result_rowwise[2, 3] ≈ minimum([4.0, 5.0])  # row 2 min = 4.0

    # Test with matrix (not vector) - impute_min only works with matrices
    mat_single = Matrix([missing 5.0])  # 1x2 matrix instead of reshape
    result = BigRiverJunbi.impute_min(mat_single)
    @test result[1, 1] ≈ 5.0  # min of the matrix is 5.0
end

@testitem "impute_half_min and impute_half_min!" begin
    using Test
    using BigRiverJunbi
    using Statistics

    # Test with Float64 matrix
    mat = [2.0 missing 4.0; 6.0 8.0 missing]
    mat_copy = copy(mat)

    # Test non-mutating version
    result = BigRiverJunbi.impute_half_min(mat)
    # Global minimum across all non-missing values is 2.0, so half is 1.0
    @test result[1, 2] ≈ 1.0  # global min/2 = 2.0/2 = 1.0
    @test result[2, 3] ≈ 1.0  # global min/2 = 2.0/2 = 1.0
    @test isequal(mat, mat_copy)  # use isequal for arrays with missing

    # Test mutating version
    BigRiverJunbi.impute_half_min!(mat)
    @test mat[1, 2] ≈ 1.0  # 2.0/2
    @test mat[2, 3] ≈ 1.0  # 2.0/2

    # Test row-wise behavior when dims=1 is explicitly specified
    result_rowwise = BigRiverJunbi.impute_half_min(mat_copy; dims=1)
    @test result_rowwise[1, 2] ≈ minimum([2.0, 4.0]) / 2  # 1.0
    @test result_rowwise[2, 3] ≈ minimum([6.0, 8.0]) / 2  # 3.0

    # Test with Integer matrix
    mat_int = [2 missing 4; 6 8 missing]
    result = BigRiverJunbi.impute_half_min(mat_int)
    @test result[1, 2] == 1  # 2÷2
    @test result[2, 3] == 1  # 2÷2    
end

@testitem "impute_median_cat and impute_median_cat!" begin
    using Test
    using BigRiverJunbi
    using Statistics

    # Test basic functionality
    mat = [1.0 missing 3.0; 4.0 5.0 missing; 7.0 8.0 9.0]
    mat_copy = copy(mat)

    # Test non-mutating version
    result = BigRiverJunbi.impute_median_cat(mat)

    # Column 1: median([1,4,7]) = 4, so 1<4→1, 4≥4→2, 7>4→2
    @test result[1, 1] == 1
    @test result[2, 1] == 2
    @test result[3, 1] == 2

    # Column 2: median([5,8]) = 6.5, so 5<6.5→1, 8≥6.5→2, missing→0
    @test result[1, 2] == 0
    @test result[2, 2] == 1
    @test result[3, 2] == 2

    @test isequal(mat, mat_copy)  # use isequal for arrays with missing

    # Test mutating version
    BigRiverJunbi.impute_median_cat!(mat)
    @test mat[1, 1] == 1
    @test mat[1, 2] == 0  # missing becomes 0

    # Test with all missing column
    mat_all_missing = [1.0 missing; 2.0 missing]
    result = BigRiverJunbi.impute_median_cat(mat_all_missing)
    @test result[1, 2] == 0
    @test result[2, 2] == 0
end

@testitem "Edge cases and error handling" begin
    using Test
    using BigRiverJunbi
    using Statistics

    # Test with matrix containing only missing values
    mat_all_missing = [missing missing; missing missing]
    @test_throws ErrorException BigRiverJunbi.impute_min!(mat_all_missing)
    @test_throws ErrorException BigRiverJunbi.impute_half_min!(mat_all_missing)

    # Test with single element matrix
    mat_single = reshape([missing], 1, 1)
    @test_throws ErrorException BigRiverJunbi.impute_min!(mat_single)

    # Test with matrix with no missing values
    mat_complete = [1.0 2.0; 3.0 4.0]
    result = BigRiverJunbi.impute_zero(mat_complete)
    @test result == mat_complete

    # Test dims parameter validation for substitute
    mat = [1.0 missing; 2.0 3.0]
    @test_throws ErrorException BigRiverJunbi.substitute(mat, mean; dims = 3)  # dims > ndims

    # Test type consistency
    mat_int = [1 missing; 2 3]
    result_zero = BigRiverJunbi.impute_zero(mat_int)
    @test eltype(result_zero) <: Union{Missing, Int}

    # Test with negative values
    mat_negative = [1.0 -2.0 missing; 3.0 4.0 missing]
    result_neg = BigRiverJunbi.impute_min(mat_negative)
    @test result_neg[1, 3] ≈ -2.0  # global minimum is -2.0
    @test result_neg[2, 3] ≈ -2.0  # global minimum is -2.0

    # Test with zeros
    mat_zeros = [0.0 missing 1.0; 2.0 3.0 missing]
    result_zeros = BigRiverJunbi.impute_min(mat_zeros)
    @test result_zeros[1, 2] ≈ 0.0  # global minimum is 0.0
    @test result_zeros[2, 3] ≈ 0.0  # global minimum is 0.0

    # Test column-wise behavior when dims=2 is specified
    mat_colwise = [1.0 missing 3.0; 4.0 5.0 missing; 7.0 8.0 9.0]
    result_colwise = BigRiverJunbi.impute_min(mat_colwise; dims=2)
    @test result_colwise[1, 2] ≈ minimum([5.0, 8.0])  # column 2 min (non-missing values)
    @test result_colwise[2, 3] ≈ minimum([3.0, 9.0])  # column 3 min (non-missing values)

    # Test with all missing in one row but not others
    mat_partial_missing = [missing missing missing; 1.0 2.0 3.0]
    @test_throws ErrorException BigRiverJunbi.impute_min!(mat_partial_missing; dims=1)
    # But should work with global behavior
    result_partial = BigRiverJunbi.impute_min(mat_partial_missing)
    @test result_partial[1, 1] ≈ 1.0  # global minimum is 1.0

    # Test with all missing in one column but not others
    mat_col_missing = [1.0 missing 3.0; 2.0 missing 4.0]
    @test_throws ErrorException BigRiverJunbi.impute_min!(mat_col_missing; dims=2)
    # But should work with global behavior
    result_col = BigRiverJunbi.impute_min(mat_col_missing)
    @test result_col[1, 2] ≈ 1.0  # global minimum is 1.0
    @test result_col[2, 2] ≈ 1.0  # global minimum is 1.0

    # Test with single non-missing value
    mat_single_value = [missing missing; missing 5.0]
    result_single = BigRiverJunbi.impute_min(mat_single_value)
    @test result_single[1, 1] ≈ 5.0  # only non-missing value is 5.0
    @test result_single[1, 2] ≈ 5.0  # only non-missing value is 5.0
    @test result_single[2, 1] ≈ 5.0  # only non-missing value is 5.0
end

@testitem "Performance and memory tests" begin
    using Test
    using BigRiverJunbi

    # Test that non-mutating versions don't modify original data
    original_data = [1.0 missing 3.0; 4.0 5.0 missing]
    test_data = copy(original_data)

    # Run all non-mutating functions
    BigRiverJunbi.impute_zero(test_data)
    BigRiverJunbi.impute_min(test_data)
    BigRiverJunbi.impute_half_min(test_data)
    BigRiverJunbi.impute_median_cat(test_data)
    BigRiverJunbi.impute_min_prob(test_data)
    BigRiverJunbi.imputeKNN(test_data, 1)
    BigRiverJunbi.imputeSVD(test_data; maxiter = 2, verbose = false)
    BigRiverJunbi.impute_QRILC(test_data)

    @test isequal(test_data, original_data)  # Should remain unchanged

    # Test that mutating versions do modify the data
    test_data_mut = copy(original_data)
    BigRiverJunbi.impute_zero!(test_data_mut)
    @test !isequal(test_data_mut, original_data)  # Should be changed
end

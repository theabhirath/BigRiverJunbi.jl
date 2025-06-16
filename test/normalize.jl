@testitem "huberize" begin
    mat = [0.5 1 2 3 3.5;
           7 3 5 0 3.5;
           8 2 5 6 0]

    @test_throws ErrorException("The MAD (median absolute deviation) of the following " *
                                "slices along dimension 2: [\"3\", \"5\"] is zero, which " *
                                "implies that some of the data is very close to the " *
                                "median. the data is very close to the median. Please " *
                                "check your data.") BigRiverJunbi.huberize(mat)
end

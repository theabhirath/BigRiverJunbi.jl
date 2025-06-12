using TestItems

@testitem "doctests" begin
    using Documenter
    DocMeta.setdocmeta!(
        BigRiverJunbi,
        :DocTestSetup,
        :(using BigRiverJunbi, DataFrames);
        recursive = true
    )
    Documenter.doctest(BigRiverJunbi; manual = false)
end

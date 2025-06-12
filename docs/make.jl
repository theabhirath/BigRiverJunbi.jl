using BigRiverJunbi
using Documenter

DocMeta.setdocmeta!(BigRiverJunbi, :DocTestSetup, :(using BigRiverJunbi); recursive = true)

makedocs(;
    modules = [BigRiverJunbi],
    authors = "Abhirath Anand <74202102+theabhirath@users.noreply.github.com> and contributors",
    sitename = "BigRiverJunbi.jl",
    format = Documenter.HTML(;
        canonical = "https://theabhirath.github.io/BigRiverJunbi.jl",
        edit_link = "main",
        assets = String[]
    ),
    pages = ["Home" => "index.md"]
)

deploydocs(; repo = "github.com/theabhirath/BigRiverJunbi.jl", devbranch = "main")

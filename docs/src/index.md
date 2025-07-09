```@raw html
---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: "BigRiverJunbi.jl"
  text: "'Omics data preparation in Julia."
  tagline: Statistical Tools for Data Preprocessing (Imputation, Normalization, Transformation) and Exploratory Analysis.
  actions:
    - theme: brand
      text: Get Started
      link: /get_started
    - theme: alt
      text: View on Github
      link: https://github.com/senresearch/BigRiverJunbi.jl
    - theme: alt
      text: API
      link: /api
---
```

````@raw html
<p style="margin-bottom:2cm"></p>

<div class="vp-doc" style="width:80%; margin:auto">

<h1> What is BigRiverJunbi.jl? </h1>

BigRiverJunbi.jl is a Julia package for data preprocessing and exploratory analysis specifically for 'omics data. While it can be used as a standalone package, it was designed to be used in conjunction with the BigRiverMetabolomics.jl package.

<h2> Installation </h2>

You can install BigRiverJunbi using Julia's package manager `Pkg`:

```julia
julia> using Pkg

julia> Pkg.add("BigRiverJunbi")
```

Or you can use the package mode in the REPL:

```julia
] add BigRiverJunbi
```

</div>
````

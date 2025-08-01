# BigRiverJunbi.jl

_Statistical Tools for Data Preprocessing (Imputation, Normalization, Transformation)_

[![CI](https://github.com/senresearch/BigRiverJunbi.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/senresearch/BigRiverJunbi.jl/actions/workflows/CI.yml)
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://senresearch.github.io/BigRiverJunbi.jl/stable)
[![Stable](https://img.shields.io/badge/docs-dev-blue.svg)](https://senresearch.github.io/BigRiverJunbi.jl/dev)
[![codecov](https://codecov.io/gh/senresearch/BigRiverJunbi.jl/graph/badge.svg?token=FFRLyzBmUd)](https://codecov.io/gh/senresearch/BigRiverJunbi.jl)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

## What is BigRiverJunbi.jl?

BigRiverJunbi.jl is a Julia package for 'omics data preprocessing. While it can be used as a standalone package, it was designed to be used in conjunction with the BigRiverMetabolomics.jl package.

### Why the name?

"Junbi" (准备, 준비, 準備) is the word for "preparation" in Chinese, Korean, and Japanese (the pronunciation is slightly different in each of these).

## Installation

You can install BigRiverJunbi using Julia's package manager `Pkg`:

```julia
julia> using Pkg

julia> Pkg.add("BigRiverJunbi")
```

Or you can use the package mode in the REPL:

```julia
] add BigRiverJunbi
```

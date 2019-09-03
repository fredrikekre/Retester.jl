using Documenter
using Retester

makedocs(
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
    ),
    modules = [Retester],
    sitename = "Retester.jl",
    pages = Any[
        "index.md",
        ]
)

deploydocs(
    repo = "github.com/fredrikekre/Retester.jl.git",
)

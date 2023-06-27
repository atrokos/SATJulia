include("structs.jl")

function dimacs_to_CNF(filename::String)
    symbols = Set()
    clauses = Vector()
    open(filename, "r") do file
        while !eof(file)
            line = readline(file)
            clause = [parse(Int128, x) for x in split(line) if x != "0"]
            for literal in clause
                push!(symbols, abs(literal))
            end
            push!(clauses, clause)
        end
    end
    return CNF(clauses, symbols, Dict())
end
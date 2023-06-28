struct CNF
    clauses::Vector{Vector{Int128}}
    symbols::Set{Int128}
    values::Dict{Int128, Bool}
    no_of_symbols::Int128
end
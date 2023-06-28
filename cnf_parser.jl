include("structs.jl")
using Printf

# Reads dimacs header and returns the number of variables and clauses
function dimacs_header(header::String)
    header_s = split(header)
    if length(header_s) != 4 || header_s[1] != "p" || header_s[2] != "cnf"
        throw(ErrorException("Error: Header is missing or is incomplete; terminating."))
    end
    try
        no_of_symbols = parse(Int128, header_s[3])
        no_of_clauses = parse(Int128, header_s[4])

        return no_of_symbols, no_of_clauses
    catch e
        throw(ErrorException("Error: Number of variables or clauses is missing!"))
    end
end

function dimacs_to_CNF(filename::String)
    clauses = []
    file = open(filename, "r")

    line = readline(file)
    no_of_symbols, no_of_clauses = dimacs_header(line)
    symbols = Set(1:no_of_symbols)

    while !eof(file)
        line = readline(file)
        if startswith(line, "c")
            continue
        end
        clause = zeros(Int128, 0)

        for x in split(line)
            int_x = parse(Int128, x)
            if int_x == 0
                continue
            elseif abs(int_x) ∈ symbols
                push!(clause, int_x)
            else
                throw(ErrorException(
                    @sprintf("Error: found variable %i, but only variables up to %i were specified in the header!", int_x, no_of_symbols)))
            end
        end
        push!(clauses, clause)
        no_of_clauses -= 1
    end
    close(file)
    if no_of_clauses != 0
        @printf("Warning: %i clauses are missing!", no_of_clauses)
    end
    return CNF(clauses, symbols, Dict(), no_of_symbols)
end
include("dpll_methods.jl")
include("cnf_parser.jl")

function DPLL(cnf::CNF)
    # Base assertion to make sure that no literals were lost
    @assert length(cnf.symbols) + length(cnf.values) == cnf.no_of_symbols

    if all_true(cnf)
        return true
    elseif one_false(cnf)
        return false
    end

    pures = find_pure_symbols(cnf::CNF)
    if pures !== nothing
        for literal in pures
            symbol = abs(literal)
            cnf.values[symbol] = set_lit_value(literal, true)
        end
        return DPLL(CNF(cnf.clauses, setdiff(cnf.symbols, keys(cnf.values)), copy(cnf.values), cnf.no_of_symbols))
    end
    unit = find_unit_clause(cnf)
    if unit !== nothing
        symbol = abs(unit)
        cnf.values[symbol] = set_lit_value(unit, true)
        return DPLL(CNF(cnf.clauses, setdiff(cnf.symbols, keys(cnf.values)), copy(cnf.values), cnf.no_of_symbols))
    end

    first_symb = first(cnf.symbols)
    cnf.values[first_symb] = true
    if !DPLL(CNF(cnf.clauses, setdiff(cnf.symbols, first_symb), copy(cnf.values), cnf.no_of_symbols))
        cnf.values[first_symb] = false
        return DPLL(CNF(cnf.clauses, setdiff(cnf.symbols, first_symb), copy(cnf.values), cnf.no_of_symbols))
    else
        return true
    end
end

function DPLL_solve(filename)
    cnf = dimacs_to_CNF(filename)
    return DPLL(cnf)
end
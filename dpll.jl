include("dpll_methods.jl")
include("cnf_parser.jl")

function DPLL(cnf::CNF)
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
        return DPLL(CNF(cnf.clauses, setdiff(cnf.symbols, keys(cnf.values)), cnf.values))
    end
    unit = find_unit_clause(cnf)
    if unit !== nothing
        symbol = abs(unit)
        cnf.values[symbol] = set_lit_value(unit, true)
        return DPLL(CNF(cnf.clauses, setdiff(cnf.symbols, keys(cnf.values)), cnf.values))
    end

    first_symb = first(cnf.symbols)
    cnf.values[first_symb] = true
    if !DPLL(CNF(cnf.clauses, setdiff(cnf.symbols, first_symb), cnf.values))
        cnf.values[first_symb] = false
        return DPLL(CNF(cnf.clauses, setdiff(cnf.symbols, first_symb), cnf.values))
    else
        return true
    end
end

function DPLL_solve(filename)
    cnf = dimacs_to_CNF(filename)
    return DPLL(cnf)
end

#DPLL_solve("C:/Users/honza/Documents/GitHub/SATJulia/test.txt")
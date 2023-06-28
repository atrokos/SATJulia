include("structs.jl")

function get_sign(literal::Integer)
    if literal < 0
        return false
    elseif literal > 0
        return true
    end
    throw(DomainError("Error: variable has value 0, which is not permitted."))
end

# Returns a literal that is a unit clause, nothing otherwise
function find_unit_clause(cnf::CNF)
    for clause in cnf.clauses
        pos_unit = [l for l in clause if abs(l) ∈ cnf.symbols]
        if length(pos_unit) == 1
            return pos_unit[1]
        end
    end
    return nothing
end

# Returns all pure literals present in the CNF
function find_pure_symbols(cnf::CNF)
    variables = Dict() # variable => "sign" in bools
    pures = Set(cnf.symbols)
    for clause in cnf.clauses
        for literal in clause
            symbol = abs(literal)
            curr_sign = get_sign(literal)
            dict_sign = get!(variables, symbol, curr_sign)

            if dict_sign != curr_sign
                delete!(pures, symbol)
            end
        end
    end

    if length(pures) == 0
        return nothing
    end

    return pures
end

function get_lit_bool(literal, value)
    if literal < 0
        return !value
    end
    return value
end

function all_true(cnf::CNF)
    for clause in cnf.clauses
        one_true = false
        for literal in clause
            symbol = abs(literal)
            if symbol ∉ keys(cnf.values)
                continue
            end
            lit_value = cnf.values[symbol]

            if get_lit_bool(literal, lit_value)
                one_true = true
                break
            end
        end
        if !one_true
            return false
        end
    end
    return true
end

# Checks if CNF is not satisfiable given that all literals have values
function one_false(cnf::CNF)
    if length(cnf.symbols) != 0
        return false
    end
    for clause in cnf.clauses
        one_true = false
        for literal in clause
            if get_lit_bool(literal, cnf.values[abs(literal)])
                one_true = true
                break
            end
        end
        if !one_true
            return true
        end
    end
    return false
end

# Return bool such that the literal has the corresponding bool
function set_lit_value(literal::Integer, bool::Bool)
    if literal < 0
        return !bool
    elseif literal > 0
        return bool
    end
    throw(DomainError("Error: variable has value 0, which is not permitted."))
end
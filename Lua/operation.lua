local op = {}
function op.equal(a, b)
    return a == b
end

function op.greater(a, b)
    return a > b
end

function op.greater_or_equal(a, b)
    return a >= b
end

function op.less(a, b)
    return a < b
end

function op.less_or_equal(a, b)
    return a <= b
end

return op
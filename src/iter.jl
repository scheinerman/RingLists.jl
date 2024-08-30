import Base.iterate

function iterate(a::RingList)
    if length(a) == 0
        return nothing
    end
    f = first(a)
    return f, f
end

function iterate(a::RingList, st)
    y = a[st]
    if y == first(a)
        return nothing
    end
    return y, y
end

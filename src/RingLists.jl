module RingLists
export RingList

import Base: ==, length

struct RingList{T}
    data::Dict{T,T}
end

function RingList(T::Type=Any)
    return RingList(Dict{T,T}())
end

function RingList(vals::Vector{T}) where T
    d = Dict{T,T}()
    n = length(vals)
    if n == 0
        return RingList(d)
    end
    if n==1
        a = vals[1]
        d[a] = a
        return RingList(d)
    end
    for i=1:n-1
        a = vals[i]
        b = vals[i+1]
        d[a] = b
    end
    a = vals[end]
    b = vals[1]
    d[a] = b
    return RingList(d)
end

function RingList(x...)
    return RingList(collect(x))
end

function RingList{T}() where T
    d = Dict{T,T}()
    return RingList(d)
end

==(a::RingList,b::RingList) = a.data == b.data
length(a::RingList) = length(a.data)

# greet() = print("Hello World!")

end # module

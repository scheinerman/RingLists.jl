module RingLists
export RingList

import Base: ==, length, getindex, keys, haskey, insert!

struct RingList{T}
    data::Dict{T,T}
end

"""
`RingList{T}()` creates a new, empty `RingList` holding elements of type `T`.
Example: `RingList{Int}()`.

`RingList(list)` creates a new `RingList` from the elements in the
one-dimensional array `list`. Example: `RingList([1,2,3])`.

`RingList(x...)` creates a new `RingList` from the arguments.
Example: `RingList(1,2,3)`.
"""
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
keys(a::RingList) = keys(a.data)
getindex(a::RingList, x) = a.data[x]
haskey(a::RingList) = haskey(a.data)


function insert!(a::RingList{T},x::T) where T
    if length(a) == 0
        a.data[x] = x
        return nothing
    end
    if haskey(a,x)
        error("$x already in this RingList")
    end
    y = first(keys(a))  # get the other elements
    if length(a) == 1
        a[x] = y
        a[y] = x
        return nothing
    end
    z = a[y]
    a[y] = x
    a[x] = z
    nothing
end





end # module

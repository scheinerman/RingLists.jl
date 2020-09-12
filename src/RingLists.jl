module RingLists
using Random
export RingList, insertafter!, insertbefore!, previous, next, shuffle

import Base: ==, length, getindex, keys, haskey, insert!, eltype
import Base: Vector, show, hash, reverse, first, delete!, Set, collect, copy

struct RingList{T}
    data::Dict{T,T}
    revdata::Dict{T,T}
end

"""
`RingList{T}()` creates a new, empty `RingList` holding elements of type `T`.
Example: `RingList{Int}()`.

`RingList(list)` creates a new `RingList` from the elements in the
one-dimensional array `list`. Example: `RingList([1,2,3])`.

`RingList(x...)` creates a new `RingList` from the arguments.
Example: `RingList(1,2,3)`.
"""
function RingList(T::Type = Any)
    return RingList(Dict{T,T}(), Dict{T,T}())
end

function _rev(d::Dict{T,T}) where {T}
    rd = Dict{T,T}()
    for k in keys(d)
        v = d[k]
        rd[v] = k
    end
    return rd
end

function RingList(vals::Vector{T}) where {T}
    d = Dict{T,T}()
    n = length(vals)
    if n != length(unique(vals))  # check there are no repeats
        error("List of values may not have a repeat")
    end
    if n == 0
        return RingList(d, d)
    end
    if n == 1
        a = vals[1]
        d[a] = a
        return RingList(d, d)
    end
    for i = 1:n-1
        a = vals[i]
        b = vals[i+1]
        d[a] = b
    end
    a = vals[end]
    b = vals[1]
    d[a] = b
    return RingList(d, _rev(d))
end

function RingList(x...)
    return RingList(collect(x))
end

function RingList{T}() where {T}
    d = Dict{T,T}()
    return RingList(d, d)
end

copy(a::RingList) = RingList(collect(a))

==(a::RingList, b::RingList) = a.data == b.data
length(a::RingList) = length(a.data)
keys(a::RingList) = keys(a.data)

"""
`next(a::RingList, x)` returns the element that follows `x` in `a`,
or throws an error if no such element exists. Abbreviation: `a[x]`.
    See also `previous`.
"""
next(a::RingList, x) = a.data[x]
getindex(a::RingList, x) = next(a, x)

"""
`previous(a::RingList,x)` returns the element `y` so that `a[y]==x`, or throws an 
error if no such element exists. Abbreviation: `a(x)`. See also `next`.
"""
previous(a::RingList, x) = a.revdata[x]
(a::RingList)(x) = previous(a, x)

haskey(a::RingList, x) = haskey(a.data, x)
eltype(a::RingList{T}) where {T} = T

"""
`first(a::RingList, true_first::Bool = true)` returns
an element of `a`. If `true_first` is `true`, then try to
return the smallest element held in `a`.
"""
function first(a::RingList, true_first::Bool = true)
    if true_first
        try
            x = minimum(keys(a.data))
            return x
        catch
        end
    end
    return first(a.data)[1]
end


"""
`insert!(a::RingList,x)` adds the element `x` into `a` after the 
first element of `a` (which might not be the smallest element in `a`).
Ergo, no guarantee where it will go. See also
`insertafter!`
"""
function insert!(a::RingList{T}, x::T) where {T}
    if length(a) == 0
        a.data[x] = x
        a.revdata[x] = x
        return nothing
    end
    if haskey(a, x)
        error("$x already in this RingList")
    end
    y = first(a)  # get the other elements
    insertafter!(a, x, y)
end

"""
`insertafter!(a::RingList,x,y)` inserts `x` into `a` after `y`.
"""
function insertafter!(a::RingList, x, y)
    if haskey(a, x)
        error("Element $x already in this RingList")
    end
    if !haskey(a, y)
        error("Element $y not in this RingList, cannot insert after")
    end
    # who is currently after y?
    z = a[y]
    # we have y --> z
    # and change to y --> x --> z

    a.data[y] = x
    a.data[x] = z

    a.revdata[x] = y
    a.revdata[z] = x

    nothing
end

"""
`insertbefore!(a::RingList,x,y)` inserts `x` into `a` before `y`.
"""
function insertbefore!(a::RingList, x, y)
    if haskey(a,x)
        error("Element $x already in this RingList")
    end
    if !haskey(a, y)
        error("Element $y not in this RingList, cannot insert before")
    end
    # who is currently before y?
    z = a(y)
    # we have z-->y 
    # we want to change to z-->x-->y
    a.data[z] = x
    a.data[x] = y

    a.revdata[y] = x
    a.revdata[x] = z

    nothing
end

"""
`delete!(a::RingList,x)` removes `x` from `a`.
"""
function delete!(a, x)
    if !haskey(a, x)
        error("$x not in the RingList")
    end
    if length(a) == 1
        delete!(a.data, x)
        return
    end

    # prev --> x --> next
    next = a[x]
    prev = previous(a, x)
    delete!(a.data, x)
    delete!(a.revdata, x)
    a.data[prev] = next
    a.revdata[next] = prev
    return
end

"""
`Vector(a::RingList)` converts `a` into an ordinary list (`Vector`).
Also: `collect(a)`.
"""
Vector(a::RingList) = [x for x in a]
collect(a::RingList) = Vector(a)

"""
`reverse(a::RingList)` returns a new `RingList` containing the
same elements as `a` but in reverse order.
"""
reverse(a::RingList{T}) where {T} = RingList{T}(copy(a.revdata), copy(a.data))

"""
`Set(a::RingList)` returns the elements of `a` as a `Set`.
"""
Set(a::RingList{T}) where {T} = Set{T}(keys(a))




hash(a::RingList) = hash(a.data)
hash(a::RingList, h::UInt64) = hash(a.data, h)

"""
`shuffle(a::RingList)` returns a new `RingList` with the same 
elements, but in a randomized order.
"""
function shuffle(a::RingList)
    n = length(a)
    p = randperm(n)
    d = collect(a)
    return RingList(d[p])
end 


include("iter.jl")
include("show.jl")

end # module

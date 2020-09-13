# RingLists


[![Build Status](https://travis-ci.org/scheinerman/RingLists.jl.svg?branch=master)](https://travis-ci.org/scheinerman/RingLists.jl)

[![codecov.io](http://codecov.io/github/scheinerman/RingLists.jl/coverage.svg?branch=master)](http://codecov.io/github/scheinerman/RingLists.jl?branch=master)


A `RingList` is a list of *distinct* values that is
unchanged by rotation. These can be created by giving a list of values
or a one-dimensional array of values:
```julia
julia> a = RingList(1,2,3,4);

julia> b = RingList([2,3,4,1]);

julia> a==b
true
```

## Functions

In this list, `a` stands for a `RingList`.

* `length(a)` gives the number of elements held in the `RingList`.
* `keys(a)` returns an iterator of the elements in `a`.
* `haskey(a,x)` checks if `x` is an element of the `RingList`.
* `Vector(a)` returns a one-dimensional array of
the elements in `a`.
* `Set(a)` returns the elements of `a` (as an unordered collection).
* `collect(a)` returns the elements of `a` in an ordered list. 
* `copy(a)` makes an independent copy of `a`.
* `shuffle(a)` returns a new `RingList` with the same elements as `a` but 
in randomized order.
* `next(a,x)` returns the next element after `x` in `a`; also `a[x]`.
* `previous(a,x)` returns the element `y` with `a[y]==x`; also `a(y)`.
* `first(a)` returns an element of `a` that is, if possible, the smallest element of `a`. Call `first(a,false)` to ignore trying to start at the smallest element. Fails if `a` is empty.
* `delete!(a,x)` removes `x` from the collection linking together its
predecessor and successor.
* `insert!(a,x)` inserts the element `a` into the `RingList`. No guarantee where it will end up.
* `insertbefore!(a,x,y)` inserts `x` into `a` before `y`.
* `insertafter!(a,x,y)` inserts `x` into `a` after `y`. For example:

```julia
julia> a = RingList(1,2,3)
[ 1 → 2 → 3 → 1 ]

julia> insertafter!(a,99,2)

julia> a
[ 1 → 2 → 99 → 3 → 1 ]
```

* `reverse(a)` returns a new `RingList` with the elements reversed.

```julia
julia> a = RingList(1,2,3,4,5)
[ 1 → 2 → 3 → 4 → 5 → 1 ]

julia> b = reverse(a)
[ 1 → 5 → 4 → 3 → 2 → 1 ]
```

## Iteration

`RingList` elements can be iterated:
```julia
julia> a = RingList(1,2,3,4,5)
[ 1 → 2 → 3 → 4 → 5 → 1 ]

julia> for x in a
       println(x)
       end
1
2
3
4
5
```


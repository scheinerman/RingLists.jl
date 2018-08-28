using Test
using RingLists

a = RingList(1,2,3)
b = RingList(2,3,1)
@test a==b
@test length(a) == 3
@test sort(collect(keys(a))) == [1,2,3]
@test a[1] == 2

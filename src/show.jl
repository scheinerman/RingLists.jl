import Base: show, string


function string(a::RingList)
    if length(a) == 0
        return "[ ]"
    end 
    result = "[ "
    arrow = " → "
    for x in a 
        result = result * string(x) * arrow
    end
    result = result * string(first(a,true)) * " ]"
    return result 
end 

    
function show(io::IO, a::RingList)
    print(io,string(a))
end




# function show(io::IO, a::RingList{T}) where {T}
#     v = Vector(a)
#     result = "RingList{$T}("
#     n = length(a)
#     for i = 1:n
#         result *= "$(v[i])"
#         if i < n
#             result *= ","
#         end
#     end
#     result *= ")"
#     print(io, result)
# end
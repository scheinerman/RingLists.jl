module RingLists
export RingList 

struct RingList{T}
    data::Dict{T,T}
    function RingList{T}(elts::Vector{T}) where T
        data = Dict{T,T}()
        n = length(elts)
        for i=1:n-1
            a = elts[i]
            b = elts[i+1]
            data[a]=b
        end
        a = elts[n]
        b = elts[1]
        data[a] = b
        new(data)
    end
end

# greet() = print("Hello World!")

end # module

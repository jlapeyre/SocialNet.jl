####
#### Network
####

"""
    Network

A graph along with strings labeling the vertices.
"""
struct Network
    graph::Graph
    persons::Vector{String}
end

"""
    Network()

Create a network with no persons.
"""
Network() = Network(Graph(), String[])

"""
    Network(persons)

Create a network initialized with the iterator `persons` of `String`s.
The network contains no friend relations.
"""
Network(persons) = Network(Graph(length(persons)), collect(persons))

## Make Network behave as a scalar in broadcasting expressions. That is, when
## automatically broadcasting a scalar function over arrays, make Network behave
## like a scalar would.
Base.Broadcast.broadcastable(net::Network) = Ref(net)

# Show a compact representation.
function Base.show(io::IO, net::Network)
    print(io, "Network(num_persons=$(nv(net.graph)), num_friendships=$(ne(net.graph)))")
    return nothing
end

# Forward some functions to the graph.
for func in (:adj_list, :add_vertex!)
    @eval ($func)(net::Network, args...) = ($func)(net.graph, args...)
end

"""
    persons(net::Network)

Return the list of all persons in `net`.
"""
persons(net::Network) = net.persons

"""
    person(net::Network, i::Integer) = (net.persons)[i]

Return the name (`String`) of the `i`th person in `net`.
"""
person(net::Network, i::Integer) = (net.persons)[i]

## Index notation looks up a person's index from the name. Eg.
## net["Alice"] -> 10
Base.getindex(net::Network, person::AbstractString) = findfirst(isequal(person), net.persons)

"""
    ispresent(net::Network, person)

Return `true` if `person` is in `net`.
"""
ispresent(net::Network, person) = (findfirst(isequal(person), net.persons) != nothing)

"""
    friends(net::Network, person)

Return the list of friends of `person`.
"""
function friends(net::Network, person)
    iperson = net[person]
    friend_inds::Vector{Int} = adj_list(net)[iperson]
    return net.persons[friend_inds]
end

"""
    add_person!(net::Network, person::AbstractString)

Add `person` to `net`. No friend relations are added.
"""
function add_person!(net::Network, person::AbstractString)
    persons = net.persons
    ispresent(net, person) && error("Person $person already present.")
    add_vertex!(net)
    push!(persons, person)
    return net
end

"""
    friend_pair!(net::Network, person1, person2)

Cause `person1` to "friend" `person2` (and vice-versa) in the network `net`.
"""
function friend_pair!(net::Network, person1, person2)
    add_edge!(net.graph, net[person1], net[person2])
    return net
end


"""
    defriend_pair!(net::Network, person1, person2)

Cause `person1` to "defriend" `person2` in the network `net`.
This just removes the symmetric friend relation between the
two persons.
"""
function defriend_pair!(net::Network, person1, person2)
    del_edge!(net.graph, net[person1], net[person2])
    return net
end

"""
    degree_of_separation(net::Network, person1, person2)

Return the degree of separation between `person1` and `person2`.
If the persons are equal, the distance is zero. If they are nearest
neighbors, it is one. In general, it is the length of a shortest
friendship path between the persons.
"""
function degree_of_separation(net::Network, person1, person2)
    return shortest_path_length(net.graph, net[person1], net[person2])
end

####
#### Graph
####

"""
    Graph

Represents a simple, undirected, unweighted graph.
"""
mutable struct Graph
    num_edges::Int
    adj_list::Vector{Vector{Int}}
end

"""
    Graph(n=0)

Create an empty (no edges) `Graph` with `n` vertices.
"""
Graph(n::Integer) = add_vertex!(Graph(), n)
Graph() = Graph(0, Vector{Int}[])

## Make Graph behave as a scalar in broadcasting expressions. That is, when
## automatically broadcasting a scalar function over arrays, make Graph behave
## like a scalar would.
Base.Broadcast.broadcastable(g::Graph) = Ref(g)

# Print an informative, but non-machine-readable representation.
function Base.show(io::IO, g::Graph)
    print(io, "Graph(nv=$(nv(g)), ne=$(ne(g)))")
    return nothing
end

"""
    adj_list(g::Graph)

Return `g` as an adjacency list. This does *not* return a copy.
"""
adj_list(g::Graph) = g.adj_list

"""
    adj_list(g::Graph, v::Integer)

Return a list of vertices adjacent to `v`.
"""
adj_list(g::Graph, v::Integer) = adj_list(g)[v]

Base.length(g::Graph) = length(adj_list(g))

"""
    ne(g::Graph)

Return the number of edges in `g`.
"""
ne(g::Graph) = g.num_edges

"""
    nv(g::Graph)

Return the number of vertices in `g`.
"""
nv(g::Graph) = length(g)

# True if there are no edges.
Base.isempty(g::Graph) = iszero(nv(g))

## TODO: Is returning essentially 1:0 a good idea for an empty graph? It allows
## iterating correctly over an empty graph, but could lead to bugs if one asks
## for `first(vertices(g))`
"""
    vertices(g::Graph)

Return an iterator over the vertices in `g`.
"""
function vertices(g::Graph)
    return Base.OneTo(nv(g))
end

"""
    add_vertex!(g::Graph, n::Integer=1)

Add `n` vertices to `g`. No edges are added.
"""
function add_vertex!(g::Graph, n::Integer=1)
    for i in 1:n
        push!(adj_list(g), Int[])
    end
    return g
end

"""
    add_edge!(adj_list_entry::Vector, v)

Add vertex `v` to the list of edges `adj_list_entry`, which represents all edges
terminating in a single vertex.  Information about this single vertex is not
neccessary nor obtainable from within this function.
"""
function add_edge!(adj_list::Vector, v)
    i = searchsortedfirst(adj_list, v)
    len = length(adj_list)
    if len == 0
        insert!(adj_list, 1, v)
    else
#        i > len || adj_list[i] == v && error("Edge already present")
        i > len || adj_list[i] == v && return nothing
        insert!(adj_list, i, v)
    end
    return adj_list
end

"""
    add_edge!(g::Graph, v1, v2)

Add the edge `(v1, v2)` to `g`.
"""
function add_edge!(g::Graph, v1, v2)
    result = add_edge!(g.adj_list[v1], v2)
    result == nothing && return nothing
    add_edge!(g.adj_list[v2], v1)
    g.num_edges += 1
    return g
end

"""
    del_edge!(adj_list_entry::Vector, v::Integer)

Delete the edge terminating in`v` from `adj_list_entry`.
The other vertex is neither needed nor referenced in this
function.
"""
function del_edge!(adj_list::Vector, v::Integer)
    i = searchsortedfirst(adj_list, v)
    i > length(adj_list) && error("Edge not present")
    deleteat!(adj_list, i)
    return adj_list
end

"""
    del_edge!(g::Graph, v1, v2)

Delete the edge `(v1, v2)` from `g`.
"""
function del_edge!(g::Graph, v1, v2)
    del_edge!(g.adj_list[v1], v2)
    del_edge!(g.adj_list[v2], v1)
    g.num_edges -= 1
    return g
end

####
#### Shortest path length
####

## Dijkstra's Algorithm.
## See https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
"""
    shortest_path_length(g::Graph, v0::Integer)

Return a list of distances from all vertices in `g` to vertex `v0` "distance"
means the length of a shortest path.
"""
function shortest_path_length(g::Graph, v0::Integer)
    q = PriorityQueue()
    dist = zeros(Int, nv(g))
    dist[v0] = 0 # Re-zero for insurance against future change.

    for v in vertices(g)
        if v != v0 # The distance from `v0` to `v0` is always zero
            dist[v] = typemax(eltype(dist)) # all distances are infinity initially
        end
        insert!(q, dist[v], v) # Put vertex `v` in the queue with priority `dist[v]`.
    end

    while ! isempty(q)
        u = pop!(q) # Get the vertex (provisionally) closest to `v0`.
        for v in adj_list(g, u) # Iterate over all edges `(v, u)` terminating in `u`.
            ! in(v, q) && continue # Skip vertices already examined.
            alt = dist[u] + 1 # Add the distance between two vertices sharing an edge: 1
            if alt < dist[v] # Did we find a shorter path ?
                dist[v] = alt
                decrease_priority!(q, alt, v)
            end
        end
    end
    for i in eachindex(dist)
        if dist[i] < 0 || dist[i] == typemax(Int)
            dist[i] = -1 # replace representations of infinity by -1 for clarity.
        end
    end
    return dist
end

## FIXME: It would be more efficient to terminate Dijkstra's algorthm after the
## target vertex has been examined. Instead, we are computing all distances.
"""
    shortest_path_length(g::Graph, v0::Integer, v1::Integer)

Return a length of the shortest path between `v0` and `v1`.
"""
function shortest_path_length(g::Graph, v0::Integer, v1::Integer)
    dist = shortest_path_length(g, v0)
    return dist[v1]
end

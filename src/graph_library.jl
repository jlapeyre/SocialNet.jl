####
#### Graph library
####

## This is a collection of some classes of graphs.
## Note that the empty graph is given by Graph(n), so no function
## for the empty graph is provided here.

"""
    cycle_graph(n::Integer)

Return the cycle graph of order `n`.
"""
function cycle_graph(n::Integer)
    g = Graph(n)
    for i in 1:n-1
        add_edge!(g, i, i + 1)
    end
    add_edge!(g, 1, n)
    return g
end

"""
    complete_graph(n::Integer)

Return the complete graph of order `n`.
"""
function complete_graph(n::Integer)
    g = Graph(n)
    for i in 1:n, j in 1:i-1
        add_edge!(g, i, j)
    end
    return g
end

"""
    star_graph(n::Integer)

The star graph of order `n`. This is a
central vertex with an edge to each of
`n-1` other vertices.
"""
function star_graph(n::Integer)
    g = Graph(n)
    for i in 2:n
        add_edge!(g, 1, i)
    end
    return g
end

"""
    star_cycle_graph(n::Integer)

Return the star graph of order `n`.
The star graph is a cycle graph of order `n-1` with
an additional vertex with and edge to all other vertices.
"""
function star_cycle_graph(n::Integer)
    g = cycle_graph(n - 1)
    add_vertex!(g)
    for i in 1:n-1
        add_edge!(g, i, n)
    end
    return g
end

## Note that Solomonoff and Rappaport introduced this graph and
## computed many important properties 10 years before Erd\"os and Renyi
## studied it.
## The Wikipedia article https://en.wikipedia.org/wiki/Random_graph mentions
## even earlier antecedents.
## Here, we use random_graph rather than a proper name.
"""
    random_graph(n::Integer, p::Real)

Return a `Graph` in which a fraction `p` of all possible edges
is present. This implementation is fast rather than exact.
For instance, it samples with replacement. This algorithm is
rather efficient for large graphs and small `p`.
"""
function random_graph(n::Integer, p::Real)
    p < 1 && p >= 0 || error("The value p=$p is not a probability less than 1")
    g = Graph(n)
    num_edges = round(Int, p * n * (n + 1) / 2)
    @show num_edges
    for i in 1:num_edges
        local v0, v1
        while true
            while true
                v0 = rand(1:n)
                v1 = rand(1:n)
                v0 != v1 && break
            end
            result = add_edge!(g, v0, v1)
            result != nothing && break # Retry if edge already added.
        end
    end
    return g
end

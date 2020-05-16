using SocialNet
using Test

using SocialNet: peek

### First test the required behavior

include("code_test_api.jl")

## We have already tested the interface that translates between persons' names
## and `Int`s representing vertices. Here we test the shortest path algorithm
## without this complication. Furthermore, we test all source and target
## vertices for some basic graphs for which the results are obvious.
## Again, the dot notation broadcasts over all source vertices.
@testset "shortest paths on graph types" begin
    g = Graph(4) # empty graph

    # Map over all possible source vertices, 1:4. For the empty graph, all vertices
    # except the source vertex are unreachable, represented by -1.
    @test shortest_path_length.(g, 1:4) ==
        [[0, -1, -1, -1], [-1, 0, -1, -1], [-1, -1, 0, -1], [-1, -1, -1, 0]]

    g = cycle_graph(5) # This graph is a ring.
    @test shortest_path_length.(g, 1:5) ==
        [[0, 1, 2, 2, 1], [1, 0, 1, 2, 2], [2, 1, 0, 1, 2], [2, 2, 1, 0, 1], [1, 2, 2, 1, 0]]

    g = complete_graph(5)
    @test shortest_path_length.(g, 1:5) ==
        [[0, 1, 1, 1, 1], [1, 0, 1, 1, 1], [1, 1, 0, 1, 1], [1, 1, 1, 0, 1], [1, 1, 1, 1, 0]]

    # The first vertex is the central vertex. It shares an edge with all other vertices.
    # Each of the other vertices shares an edge only with the central vertex.
    g = star_graph(5)
    @test shortest_path_length.(g, 1:5) ==
        [[0, 1, 1, 1, 1], [1, 0, 2, 2, 2], [1, 2, 0, 2, 2], [1, 2, 2, 0, 2], [1, 2, 2, 2, 0]]

    # The star-cycle graph is a cycle graph plus a vertex in the middle with an edge to all vertices.
    # The last vertex is the central vertex.
    g = star_cycle_graph(9)
    @test shortest_path_length.(g, 1:9) ==
        [[0, 1, 2, 2, 2, 2, 2, 1, 1], [1, 0, 1, 2, 2, 2, 2, 2, 1], [2, 1, 0, 1, 2, 2, 2, 2, 1],
         [2, 2, 1, 0, 1, 2, 2, 2, 1], [2, 2, 2, 1, 0, 1, 2, 2, 1], [2, 2, 2, 2, 1, 0, 1, 2, 1],
         [2, 2, 2, 2, 2, 1, 0, 1, 1], [1, 2, 2, 2, 2, 2, 1, 0, 1], [1, 1, 1, 1, 1, 1, 1, 1, 0]] # <-- last vertex

end

### Unit tests / diagnostic tests follow

@testset "basic Graph" begin
    g = Graph()
    @test isempty(g)
    @test length(vertices(g)) == 0
    # Implementation detail, but important
    @test first(vertices(g)) == 1
    @test ne(g) == 0
    @test nv(g) == 0

    add_vertex!(g)
    @test ! isempty(g)
    @test vertices(g) == 1:1
    @test ne(g) == 0
    @test nv(g) == 1

    add_vertex!(g)
    add_edge!(g, 1, 2)
    @test ne(g) == 1
    @test nv(g) == 2
end

@testset "basic PriorityQueue" begin
    q = PriorityQueue()

    @test isempty(q) == true
    insert!(q, 1, 100)
    insert!(q, 10, 99)
    insert!(q, 5, 50)

    # The lowest priority, 1, is for item 100
    @test peek(q) == 100

    # Check if an item is in the queue
    @test (50 in q) == true

    # Remove the lowest priority item
    @test pop!(q) == 100

    # Check that the next lowest priorty item has advanced
    @test peek(q) == 50

end

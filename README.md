# SocialNet

This package is an exercise. See [`LightGraphs.jl`](https://github.com/JuliaGraphs/LightGraphs.jl)
for a graphs library for production use.

This package implements a basic social network of people who can be pairwise friends.

The interface includes 

* Adding/removing a pair of friends.

* Listing all friends of a given person.

* Listing all persons.

* Degree of separation between any pair of persons.


Here is an example session of running the test suite

```julia
> julia -q  # start the Julia command line interface

julia> using Pkg;

julia> Pkg.activate(".");
 Activating environment at `~/.julia/dev/SocialNet/Project.toml`

julia> Pkg.test("SocialNet")
    Testing SocialNet
Status `/tmp/jl_lEKucc/Project.toml`
  [9aaaaa74] SocialNet v0.1.0 `~/.julia/dev/SocialNet`
  [8dfed614] Test
Status `/tmp/jl_lEKucc/Manifest.toml`
  [9aaaaa74] SocialNet v0.1.0 `~/.julia/dev/SocialNet`
  [2a0f44e3] Base64
  [8ba89e20] Distributed
  [b77e0a4c] InteractiveUtils
  [56ddb016] Logging
  [d6f4376e] Markdown
  [9a3f8284] Random
  [9e88b42a] Serialization
  [6462fe0b] Sockets
  [8dfed614] Test
Test Summary:         | Pass  Total
code test requirements |   15     15
Test Summary:                 | Pass  Total
shortest paths on graph types |    5      5
Test Summary: | Pass  Total
basic Graph   |   11     11
Test Summary:       | Pass  Total
basic PriorityQueue |    5      5
    Testing SocialNet tests passed 
```

## Design

This implementation is to a large extent modular and composable, as explained below.

### [`Network`](https://github.com/jlapeyre/SocialNet.jl/blob/master/src/network.jl)

The data structure representing the social network consists of a (instance of)
`Graph` together with a list of names associated with the `Int`-valued vertices
of the `Graph`. The required network interface is then implemented as a thin
wrapper around functions operating on the `Graph`. The `Network` hides much of
the `Graph` implementation, in particular, that the vertices are `Int`s.  In
practice one would factor out some common features. But here we use the language
of graphs in one case and social networks in the other for expository purposes.

### [`Graph`](https://github.com/jlapeyre/SocialNet.jl/blob/master/src/graph.jl)

Implements simple, unweighted, undirected graphs with `Int`-valued
vertices. `Graph` is implemented as an adjacency list.  The interface to `Graph`
includes a shortest-path-length algorithm implemented via Dijkstra's
algorithm. This implementation relies on the struct `PriorityQueue`

The shortest path algorithm
[implemented here](https://github.com/jlapeyre/SocialNet.jl/blob/ba4703953379a7fb1115b527d63fe22df2a9fd44/src/graph.jl#L122-L146)
is based on
[Dijkstra's algorithm as described on Wikipedia](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm).

### [`PriorityQueue`](https://github.com/jlapeyre/SocialNet.jl/blob/master/src/priority_queue.jl)

Julia's priority queue implementation is outside the standard library. A basic, not too efficient,
priority queue is implemented here. But, neither is it completely naive. However, one could drop
in a heap-based priorty queue for greater (not measured yet) effciency.

## Dependencies

There are no dependencies, including none on standard libraries.

## Style

This code attempts to follow this [style guide](https://github.com/jrevels/YASGuide).

## Demonstration vs production code

* Several unit tests and algorithm tests are included. However, complete coverage would require many hours coding.
* All exportable symbols are imported everywhere. In application code, we would fully qualify all symbols from
  `SocialNet`.
* The code could be made more efficient or parallelized with little obfuscation. But, the goal here is
clarity of presentation.
* Reusable parts of the code would normally be written parametrically, for arbitrary types, rather than hardcoded
  for `Int`s.

<!--  LocalWords:  SocialNet composable undirected struct PriorityQueue jl Pkg
 -->
<!--  LocalWords:  pseudocode UNDONEs julia aaaaa dfed ba InteractiveUtils ddb
 -->
<!--  LocalWords:  Markdown fe
 -->

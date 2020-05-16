module SocialNet

export PriorityQueue, peek, decrease_priority!

export Graph, adj_list, add_vertex!, add_edge!, del_edge!,
    ne, nv, shortest_path_length, vertices

export cycle_graph, complete_graph, star_graph, star_cycle_graph, random_graph

export Network, person, persons, add_person!, friend_pair!, defriend_pair!, friends,
    degree_of_separation

include("priority_queue.jl")
include("graph.jl")
include("network.jl")
include("graph_library.jl")

end # module SocialNet

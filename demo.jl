using Revise
using SocialNet
using BenchmarkTools

# This file demonstrates the required features of the implementation
# The same tests are included in the test suite in ./test/

# Create a list of persons
person_list = ["cow", "horse", "pig", "chicken", "dog", "cat", "goldfish"]

# Create an emtpy social network
net = Network()

# Add all the persons to the network
# The dot notation broadcasts over a list
add_person!.(net, person_list)

# List all persons
@show persons(net)

# Add friend relation to pairs
friend_pair!(net, "cow", "horse")
friend_pair!(net, "cow", "pig")
friend_pair!(net, "cow", "chicken")
friend_pair!(net, "cow", "goldfish")

friend_pair!(net, "horse", "pig")
friend_pair!(net, "horse", "chicken")

friend_pair!(net, "dog", "cat")
friend_pair!(net, "dog", "goldfish")

# List all friends of a given person
@show friends(net, "cow")
@show friends(net, "horse")
@show friends(net, "chicken")
@show friends(net, "pig")

@show friends(net, "dog")
@show friends(net, "cat")
@show friends(net, "goldfish")

# Compute degree of separation between pairs of persons
@show degree_of_separation(net, "cow", "cow")
@show degree_of_separation(net, "cow", "horse")
@show degree_of_separation(net, "horse", "cat")
@show degree_of_separation(net, "horse", "dog")
@show degree_of_separation(net, "horse", "goldfish")
@show degree_of_separation(net, "pig", "cat")

# Remove friend relation from pairs
defriend_pair!(net, "cow", "goldfish")

# The distance between pig and cat is now infinite,
# represented by typemax(Int)
@show degree_of_separation(net, "pig", "cat")

nothing



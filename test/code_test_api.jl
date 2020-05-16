@testset "code test requirements" begin
    person_list = ["cow", "horse", "pig", "chicken", "dog", "cat", "goldfish"]

    # Create an empty social network
    net = Network()

    # Add all the persons to the network
    # The dot notation broadcasts over a list
    add_person!.(net, person_list)

    # Test listing all persons in network
    @test persons(net) == person_list

    # Add friend relation to pairs
    friend_pair!(net, "cow", "horse")
    friend_pair!(net, "cow", "pig")
    friend_pair!(net, "cow", "chicken")
    friend_pair!(net, "cow", "goldfish")

    friend_pair!(net, "horse", "pig")
    friend_pair!(net, "horse", "chicken")

    friend_pair!(net, "dog", "cat")
    friend_pair!(net, "dog", "goldfish")

    # Test listing all friends of a person
    @test friends(net, "cow") == ["horse", "pig", "chicken", "goldfish"]
    @test friends(net, "horse") == ["cow", "pig", "chicken"]
    @test friends(net, "chicken") == ["cow", "horse"]
    @test friends(net, "pig") == ["cow", "horse"]
    @test friends(net, "dog") == ["cat", "goldfish"]
    @test friends(net, "cat") == ["dog"]
    @test friends(net, "goldfish") == ["cow", "dog"]

    # Test computing degree of separation

    @test degree_of_separation(net, "cow", "cow") == 0
    @test degree_of_separation(net, "cow", "horse") == 1
    @test degree_of_separation(net, "horse", "cat") == 4
    @test degree_of_separation(net, "horse", "dog") == 3
    @test degree_of_separation(net, "horse", "goldfish") == 2
    @test degree_of_separation(net, "pig", "cat") == 4

    # Remove friend relation from pairs
    defriend_pair!(net, "cow", "goldfish")

    # The distance between pig and cat is now infinite, represented by -1
    @test degree_of_separation(net, "pig", "cat") == -1
end

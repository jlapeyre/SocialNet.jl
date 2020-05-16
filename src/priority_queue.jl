####
#### PriorityQueue
####

## A priority queue implementation
## O(1) peek
## O(1) pop
## O(n) insert
## O(n) decrease_priority
##
## Various heap implementations would be more efficient, having, for example,
## O(log(n)) insert.  But they would be more complicated to implement.

# In production, we would paramaterize the types for reusability.
"""
    PriorityQueue

A priority queue with `Int` data and priorities. Lowest priority
is popped first.
"""
struct PriorityQueue
    data::Vector{Int}
    priorities::Vector{Int}
end

## Make PriorityQueue behave as a scalar in broadcasting expressions. That is, when
## automatically broadcasting a scalar function over arrays, make PriorityQueue behave
## like a scalar would.
Base.Broadcast.broadcastable(q::PriorityQueue) = Ref(q)

# Show list of pairs (priority, data_element).
function Base.show(io::IO, q::PriorityQueue)
    print(io, "PriorityQueue((p, x)=", collect(zip(q.priorities, q.data)), ")")
    return nothing
end

"""
    PriorityQueue()

Return an empty `PriorityQueue`.
"""
PriorityQueue() = PriorityQueue(Int[], Int[])

## These are natural extensions of Julia Base functions to PriorityQueue
## obtained by forwarding to the `data`.
for func in (:isempty, :length)
    @eval (Base.$func)(q::PriorityQueue, args...) = ($func)(q.data, args...)
end

# Extend Julia Base insert! function.
function Base.insert!(q::PriorityQueue, priority, item)
    i = searchsortedfirst(q.priorities, priority; rev=true)
    insert!(q.priorities, i, priority)
    insert!(q.data, i, item)
    return q
end

"""
    peek(q::PriorityQueue)

Return the lowest priority element of `q` without popping it.
"""
function peek(q::PriorityQueue)
    return last(q.data)
end

"""
    peek(q::PriorityQueue)

Return the lowest priority element of `q` without popping it.
"""
function Base.delete!(q::PriorityQueue)
    pop!(q.priorities)
    pop!(q.data)
    return q
end

"""
    pop!(q::PriorityQueue)

Remove and return the lowest priority element from `q`.
"""
function Base.pop!(q::PriorityQueue)
    v = peek(q)
    pop!(q.priorities)
    pop!(q.data)
    return v
end

"""
    decrease_priority!(q::PriorityQueue, new_priority::Integer, item::Integer)

Replace the priority of `item` with `new_priority`. No check is made to ensure
that the priority decreases, and in fact it may increase as currently implemented.
But, the API only guarantees that decreasing will not error and give the desired
result. This is because more efficient algorithms requiring this restriction exist
and may be implemented here in the future.
"""
function decrease_priority!(q::PriorityQueue, new_priority::Integer, item::Integer)
    i = findfirst(isequal(item), q.data)
    if i == nothing
        error("item $item not present in queue")
    end
    deleteat!(q.data, i)
    deleteat!(q.priorities, i)
    insert!(q, new_priority, item)
    return q
end

## FIXME: This is O(n), and is used frequently in the application code
## At the cost of more memory, we could maintain and access this information
## at O(log(n)) cost.
"""
    Base.in(q::PriorityQueue, item)

Return `true` if `item` is in `q`.
"""
function Base.in(item, q::PriorityQueue)
    return item in q.data
end

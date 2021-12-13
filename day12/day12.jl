file = open("input.txt")
input = readlines(file)
graph = Dict()
counter = Dict()
for line in input
    a, b = split(line, "-")
    counter[a] = 0
    counter[b] = 0
    fromA = get(graph, a, [])
    fromB = get(graph, b, [])
    push!(fromA, b)
    push!(fromB, a)
    graph[a] = fromA
    graph[b] = fromB
end

function traverse(node, argcounter, path, graph, part)
    owncounter = copy(argcounter)
    owncounter[node] += 1
    ownPath = copy(path)
    ownPath = push!(ownPath, node)
    if node == "end"
        return 1
    end
    if node == "start"
        return 0
    end
    if all(map(islowercase, collect(node))) && owncounter[node] > part 
        return 0
    end
    if all(map(islowercase, collect(node))) && owncounter[node] == 2
        part = 1
    end
    options = sort(get(graph, node, []))
    return sum(map(option -> traverse(option, owncounter, ownPath, graph, part), options))
end

options = get(graph, "start", [])
println(sum(map(option -> traverse(option, counter, ["start"], graph, 1), options)))
println(sum(map(option -> traverse(option, counter, ["start"], graph, 2), options)))
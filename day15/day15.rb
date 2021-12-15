require "set"
file = File.open("input.txt", "r")
input = file.read
file.close
graph = Hash.new {Float::INFINITY}
y = 0
for line in input.split("\n")
    x = 0
    for letter in line.split("")
        graph[[x, y]] = letter.to_i
        x += 1
    end
    y += 1
end

def neighbors(pos)
    x, y = pos
    return [
        [x-1, y],
        [x+1, y],
        [x, y-1],
        [x, y+1]
    ]
end

def reconstruction(cameFrom, current)
    totalPath = Set[current]
    while cameFrom.keys.include? current do
        current = cameFrom[current]
        totalPath.add(current)
    end
    return totalPath
end
    
def AStar(graph, start, goal, heuristic)
    openSet = Set[start]
    cameFrom = Hash.new
    gScore = Hash.new {Float::INFINITY}
    gScore[start] = 0
    fscore = Hash.new {Float::INFINITY}
    fscore[start] = heuristic(start)
    while not openSet.empty?
        current = nil
        currentFScore = Float::INFINITY
        for i in openSet
            if fscore[i] < currentFScore then
                currentFScore = fscore[i]
                current = i
            end
        end
        if current == goal then
            return reconstruction(cameFrom, current).subtract(Set[start])
        end
        openSet.subtract(Set[current])
        for neighbor in neighbors(current)
            tentativeGScore = gScore[current] + graph[neighbor]
            if tentativeGScore < gScore[neighbor]
                cameFrom[neighbor] = current
                gScore[neighbor] = tentativeGScore
                fscore[neighbor] = tentativeGScore + heuristic(neighbor)
                openSet << neighbor
            end
        end
    end
end

def heuristic(pos)
    x, y = pos
    return Math.sqrt((9-x)**2 + (9-y)**2)
end

path = AStar(graph, [0,0], [99,99], :heuristic)

for y in 0..99
    for x in 0..99
        if path.include? [x, y] then
            print "."
        else
            print graph[[x,y]]
        end
    end
    print "\n"
end
sum = 0
path.each {|pair| sum += graph[pair]}
printf "part 1: #{sum}\n"

for y in 0..99
    for x in 0..99
        for dx in 1..4
            graph[[x+dx*100, y]] = (graph[[x+(dx-1)*100,y]]+1)%10
            if graph[[x+dx*100, y]] == 0 then
                graph[[x+dx*100, y]] = 1
            end
        end
    end
end 
for y in 0..99
    for x in 0..499
        for dy in 1..4
            graph[[x,y+100*dy]] = (graph[[x, y+100*(dy-1)]]+1)%10
            if graph[[x,y+100*dy]] == 0 then
                graph[[x,y+100*dy]] = 1
            end
        end
    end
end

path = AStar(graph, [0,0], [499,499], :heuristic)
for y in 0..499
    for x in 0..499
        if path.include? [x,y] then
            print "."
        else
            print graph[[x,y]]
        end
    end
    print "\n"
end
sum = 0
path.each {|pair| sum += graph[pair]}
printf "part 2: #{sum}\n"
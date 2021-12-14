state = ""
rules = {}

function add_or_init(dict, key, add)
    if dict[key] == nil then
        dict[key] = add
    else
        dict[key] = dict[key] + add
    end
end

for line in io.lines("input.txt") do
    if state == "" then
        state = line
    elseif line == "" then
    else
        first = string.sub(line, 1, 2)
        second = string.sub(line, 7, 7)
        rules[first] = second
    end
end
pair_count = {}
for i = 1, state:len()-1 do
    window = state:sub(i,i+1)
    add_or_init(pair_count, window, 1)
end

counts = {}
states = {}
states[1] = state
for step = 1, 40 do
    next_pair_count = {}
    for k, v in pairs(pair_count) do
        gen = rules[k]
        l1 = k:sub(1,1)
        l2 = k:sub(2,2)
        n1 = l1 .. gen
        n2 = gen .. l2
        add_or_init(next_pair_count, n1, v)
        add_or_init(next_pair_count, n2, v)
    end
    pair_count = next_pair_count
    start_letter_count = {}
    endin_letter_count = {}
    for k, v in pairs(pair_count) do
        add_or_init(start_letter_count, k:sub(1,1), v)
        add_or_init(endin_letter_count, k:sub(2,2), v)
    end
    letter_count = {}
    for k, v in pairs(start_letter_count) do
        letter_count[k] = math.max(v, endin_letter_count[k])
    end
    min, max = 9999999999999, 0
    for k, v in pairs(letter_count) do
        if v > max then
            max = v
        end
        if v < min then
            min = v
        end
    end
    if step == 10 then
        print(string.format("part 1: %d", max-min))
    elseif step == 40 then
        print(string.format("part 2: %d", max-min))
    end
end
const fs = require("fs")
const { parse } = require("path/posix")

function mostCommon(list, position) {
    ones = 0
    zeros = 0
    for (binary of list) {
        if (binary[position] == "1") ones++
        else zeros++
    }
    if (zeros > ones) {
        return 0
    }
    return 1
}

function leastCommon(list, pos) {
    if (mostCommon(list, pos) == 1) {
        return 0
    }
    return 1
}

async function partOne(list) {
    gamma = ""
    epsilon = ""
    for (position in list[0]) {
        if (mostCommon(list, position) == 1) {
            gamma += "1"
            epsilon += "0"
        } else {
            gamma += "0"
            epsilon += "1"
        }
    }
    gamma_10 = parseInt(gamma, 2)
    epsilon_10 = parseInt(epsilon, 2)
    return gamma_10 * epsilon_10
}

async function partTwo(list) {
    function helper(lst, pos,f) {
        if (lst.length == 1) return lst[0]
        else {
            return helper(lst.filter(x => x[pos] == f(lst, pos)), pos + 1,f)
        }
    }
    oxygen = parseInt(helper(list, 0, mostCommon),2)
    co2 = parseInt(helper(list, 0, leastCommon),2)
    return oxygen*co2
}

async function main() {
    let input = await fs.readFileSync("input.txt").toString().split("\n")
    console.log("part 1: " + await partOne(input));
    console.log("part 2: " + await partTwo(input));
}
main()
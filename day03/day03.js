const fs = require("fs")

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
    function oxy(lst, pos) {
        if (lst.length == 1) return lst[0]
        return oxy(lst.filter(x => x[pos] == mostCommon(lst, pos)), pos + 1)
    }
    function co2(lst, pos) {
        if (lst.length == 1) return lst[0]
        return co2(lst.filter(x => x[pos] == leastCommon(lst, pos)), pos + 1)
    }
    let a = parseInt(oxy(list, 0),2)
    let b = parseInt(co2(list, 0),2)
    return a*b
}

async function main() {
    let input = await fs.readFileSync("input.txt").toString().split("\n")
    console.log("part 1: " + await partOne(input));
    console.log("part 2: " + await partTwo(input));
}
main()
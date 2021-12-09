package main

import (
	"fmt"
	"os"
	"sort"
)

type coords struct {
	x int
	y int
}

func runeToInt(c rune) int {
	var v = 0
	switch c {
	case '0':
		v = 0
	case '1':
		v = 1
	case '2':
		v = 2
	case '3':
		v = 3
	case '4':
		v = 4
	case '5':
		v = 5
	case '6':
		v = 6
	case '7':
		v = 7
	case '8':
		v = 8
	case '9':
		v = 9
	}
	return v
}

func contains(s []coords, e coords) bool {
	for _, a := range s {
		if a == e {
			return true
		}
	}
	return false
}

func neighbors(loc coords) []coords {
	var x = loc.x
	var y = loc.y
	var ret = make([]coords, 4)
	ret[0] = coords{x: x + 1, y: y}
	ret[1] = coords{x: x - 1, y: y}
	ret[2] = coords{x: x, y: y + 1}
	ret[3] = coords{x: x, y: y - 1}
	return ret
}

func main() {
	var tileMap = make(map[coords]int)
	var dat, err = os.ReadFile("input.txt")
	var input = string(dat)
	if err != nil {
		panic(err)
	}
	var x, y = 0, 0
	for _, c := range input {
		if c == '\n' {
			x = 0
			y = y + 1
		} else {
			tileMap[coords{x: x, y: y}] = runeToInt(c)
			x += 1
		}
	}
	var minima = make([]coords, 0)
	for key, val := range tileMap {
		var minimum = true
		for _, okey := range neighbors(key) {
			var oval, ok = tileMap[okey]
			if ok {
				if oval <= val {
					minimum = false
				}
			}
		}
		if minimum {
			minima = append(minima, key)
		}
	}
	var sum = 0
	for _, key := range minima {
		sum += tileMap[key] + 1
	}
	fmt.Printf("part 1: %d \n", sum)

	var basins = make([][]coords, 0)
	for _, loc := range minima {
		var init = make([]coords, 1)
		init[0] = loc
		basins = append(basins, init)
	}
	for true {
		var changed = false
		var nextBasins = make([][]coords, 0)
		for _, basin := range basins {
			for _, tile := range basin {
				for _, neighborLoc := range neighbors(tile) {
					var val, ok = tileMap[neighborLoc]
					if ok {
						if val < 9 && !contains(basin, neighborLoc) {
							basin = append(basin, neighborLoc)
							changed = true
						}
					}
				}
			}
			nextBasins = append(nextBasins, basin)
		}
		if !changed {
			break
		}
		basins = nextBasins
	}
	var lengths = make([]int, 0)
	for _, basin := range basins {
		lengths = append(lengths, len(basin))
	}
	sort.Ints(lengths)
	for i, j := 0, len(lengths)-1; i < j; i, j = i+1, j-1 {
		lengths[i], lengths[j] = lengths[j], lengths[i]
	}
	fmt.Printf("part 2: %d\n", lengths[0]*lengths[1]*lengths[2])
}

import scala.util.Using
import scala.io.Source
import scala.collection.mutable.HashMap

class Octopus(val e : Int) {
    var energy : Int = e;
    var flashedLately : Boolean = false
}

object day11 {
    def step(field : HashMap[(Int,Int),Octopus]) : Int = {
        var fired = 0
        for (key <- field.keysIterator) {
            var octopus = field.get(key).get
            octopus.flashedLately = false
            octopus.energy += 1
        }
        var fired_lately = 0
        do {
            fired_lately = 0
            for (key <- field.keysIterator) {
                var octopus = field.get(key).get
                if (octopus.energy > 9) {
                    octopus.energy = 0
                    octopus.flashedLately = true
                    fired_lately += 1
                    fired += 1
                    for (pos <- surrounding(key)) {
                        var maybepus = field.get(pos)
                        if (maybepus.isDefined) {
                            if (!maybepus.get.flashedLately){
                                maybepus.get.energy += 1
                            }
                        }
                    }
                }
            }
        } while (fired_lately > 0)
        return fired
    }

  def main(args: Array[String]): Unit = {
    var input = Source.fromFile("input.txt").getLines().toList
    var x = 0
    var y = 0
    var fired = 0
    var field : HashMap[(Int,Int),Octopus] = HashMap()
    for (line <- input) {
        x = 0
        for (letter <- line) {
            field += (x,y) -> new Octopus(letter.toInt-48)
            x += 1
        }
        y += 1
    }
    for (s <- 1 to 100) {
        fired += step(field)
    }
    printf("part 1: %d\n",fired)
    var s = 100
    while(!all_the_same(field)) {
        step(field)
        s += 1
    }
    printf("part 2: %d\n", s)
    
  }
  def all_the_same(field : HashMap[(Int,Int),Octopus]) : Boolean = {
      for (key <- field.keys) {
          if (field.get(key).get.energy != field.get((0,0)).get.energy) {return false}
      }
      return true
  }
  def surrounding(t:(Int,Int)) : List[(Int,Int)] = {
    var (x,y) = t
    var list : List[(Int,Int)] = List()
    for (dx <- -1 to 1) {
        for (dy <- -1 to 1) {
            if ((dx, dy) != (0,0)) {
                list = (x+dx,y+dy)::list
            }
        }
    }
    return list
}
    def print_field(field : HashMap[(Int,Int),Octopus]) : Unit = {
        var x = 0
        var y = 0
        while (field.get((x,y)).isDefined) {
            while (field.get((x,y)).isDefined) {
                print(field.get((x,y)).get.energy)
                x += 1
            }
            println ()
            x = 0
            y += 1
        }
        println ()
    }
}
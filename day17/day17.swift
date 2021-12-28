import Foundation

class TargetArea : NSObject{
    var upperRight = (0,0)
    var lowerLeft = (0,0)
    init(p1:(Int,Int), p2:(Int,Int)) {
        self.lowerLeft = p1
        self.upperRight = p2
    }
    override var description : String {
        get {
            return "Target from \(lowerLeft) to  \(upperRight)"
        }
    }
    func hasPoint(point : (Int, Int)) -> Bool {
        return point.0 >= lowerLeft.0 
            && point.0 <= upperRight.0 
            && point.1 >= lowerLeft.1 
            && point.1 <= upperRight.1;
    }
}

func simulation(shot : (Int, Int), target : TargetArea) -> Int?{
    var running = true;
    var loc = (0,0)
    var shot = shot
    var locs : [(Int,Int)] = []
    while (running) {
        loc.0 += shot.0
        loc.1 += shot.1
        if shot.0 > 0 {
            shot.0 -= 1
        } else if shot.0 < 0 {
            shot.0 += 1
        }
        shot.1 -= 1
        locs.append(loc)
        if target.hasPoint(point: loc) {
            running = false
        }
        if     (shot.0 > 0 && loc.0 > target.upperRight.0)
            || (shot.0 < 0 && loc.0 < target.lowerLeft.0)
            || (shot.1 < 0 && loc.1 < target.lowerLeft.1) {
                return nil
        }
    }
    return locs.max(by: {(a , b) -> Bool in a.1 < b.1})?.1
}

let input = try! String(
    contentsOf: URL(fileURLWithPath: "input.txt"), encoding: .utf8)
let regex = try! NSRegularExpression(
    pattern: #"x=(.+)\.\.(.+), y=(.+)\.\.(.+)"#)
let match = regex.firstMatch(
    in: input, 
    options: [], 
    range: NSRange(location: 0, length: input.utf16.count))
let targetX1 = Int((input[Range(match!.range(at: 1), in: input)!]))!
let targetX2 = Int((input[Range(match!.range(at: 2), in: input)!]))!
let targetY1 = Int((input[Range(match!.range(at: 3), in: input)!]))!
let targetY2 = Int((input[Range(match!.range(at: 4), in: input)!]))!
let target = TargetArea(p1: (targetX1, targetY1), p2: (targetX2, targetY2))

var count = 0
var best = 0
for x in 0...500 {
    for y in -500...500 {
        if let sim = simulation(shot: (x,y), target: target) {
            count += 1
            if sim > best {
                best = sim
            }
        }
    }
}
print("part 1: \(best)")
print("part 2: \(count)")
import sys.io.File;
class Day06 {
    static public function main() : Void {
        var contents = File.getContent("input.txt");
        var split = contents.split(",");
        var input = split.map(function(string) return Std.parseInt(string));
        var copy = input.copy();
        var counters = [for (i in 0...9) 0];
        for (day in 0...80) {
            var newFish = 0;
            input = input.map(function(age) {
                if(age < 1) {
                    newFish++;
                    return 6;
                } else {
                    return age-1;
                }
            });
            input = input.concat([for (i in 0...newFish) 8]);
        }
        trace("part 1: " + input.length);
        copy.map(function(day) {counters[day]++;return 1;});
        for (day in 0...256) {
            var pop = counters.shift();
            counters[8] = pop;
            counters[6] += pop;
        }
        var sum = 0;
        for (elem in counters) sum+=elem;
        trace("part 2: " + sum);
    }
}
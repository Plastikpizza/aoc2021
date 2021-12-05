use std::collections::HashMap;
fn main() {
    let input = std::fs::read_to_string("input.txt")
        .expect("file not found");
    let mut world = HashMap::new();

    let lines = input
        .lines().map(|line|line.split(" -> ")
        .map(|i|i.split(",")
        .map(|i|i.parse::<i64>()
        .unwrap())
        .collect::<Vec<_>>())
        .collect::<Vec<_>>())
        .collect::<Vec<_>>();
    
    let mut skipped = Vec::new();

    for line in &lines {
        let start = &line[0];
        let end   = &line[1];
        let x1    = start[0];
        let y1    = start[1];
        let x2    = end[0];
        let y2    = end[1];
        if x1 == x2 {
            let x = x1;
            for y in min(y1,y2)..=max(y1,y2) {
                world.entry((x,y))
                    .and_modify(|i|{*i+=1})
                    .or_insert(1);
            }
        } else if y1 == y2 {
            let y = y1;
            for x in min(x1,x2)..=max(x1,x2) {
                world.entry((x,y))
                    .and_modify(|i|{*i+=1})
                    .or_insert(1);
            } 
        } else {
            skipped.push(((x1,y1),(x2,y2)));
        }
    }
    println!("part one: {}", world.values().filter(|&&i| i>1).count());
    
    for ((x1,y1),(x2,y2)) in skipped {
        let dx = if x1 < x2 {1} else {-1};
        let dy = if y1 < y2 {1} else {-1};
        let mut x = x1;
        let mut y = y1;
        loop {
            world.entry((x,y)).and_modify(|i|{*i+=1}).or_insert(1);
            x += dx;
            y += dy;
            if (x,y) == (x2+dx, y2+dy) {break}
        }
    }
    println!("part two: {}", world.values().filter(|&&i| i>1).count());
}
fn min(a:i64, b:i64)->i64{
    if a < b {
        a
    } else {
        b
    }
}

fn max(a:i64, b:i64)->i64{
    if a < b {
        b
    } else {
        a
    }
}
let lines = System.IO.File.ReadLines "input.txt"
let input = Seq.map (System.Convert.ToInt64 : string -> int64) lines
let list = Seq.toList input

let rec countIncrease (list : int64 list) = 
    match list with
    | [] | [_] -> 0
    | (a::b::rest) -> (if b > a then 1 else 0) + countIncrease (b::rest)

let rec triplate (list : int64 list) =
    match list with
    | [] | [_] | [_;_] -> []
    | a::b::c::rest -> (a,b,c) :: triplate (b::c::rest)

printfn "part 1: %d" (countIncrease list)
printfn "part 2: %d" (list 
    |> triplate 
    |> List.map (fun (a,b,c)->a+b+c) 
    |> countIncrease)
-module(day04).
-export([main/1]).

drop(0, L)->L;
drop(_, [])->[];
drop(N, [_|T])->drop(N-1, T).

column(N, Board) -> lists:map(fun(Line)->lists:nth(N, Line)end, Board).

all(X)->lists:all(fun(C)->C==true end,X).
any(X)->lists:any(fun(C)->C==true end,X).

winning(Board) ->
    Marking = lists:map(
        fun(Line)->lists:map(
            fun({_, M})->M==marked end, Line)
        end,Board),
    Cols = lists:map(fun(N)->column(N, Marking) end, [1,2,3,4,5]),
    LineMarked = lists:map(fun(Line)->all(Line)end, Marking),
    ColMarked = lists:map(fun(Col)->all(Col)end, Cols),
    any(ColMarked) or any(LineMarked).
    

boardToInts(Board) ->
    Lines = string:split(Board, "\n", all),
    Splits = lists:map(fun(L)->string:split(L, " ", all) end, Lines),
    Raw = lists:map(fun(S)->lists:filter(fun(C)->C/=<<>>end, S) end, Splits),
    lists:map(
        fun(Line)->lists:map(
            fun(X)->{N,_}=string:to_integer(X),{N, unmarked} end
        ,Line) end
    , Raw).

print(X) -> io:format("~p\n", [X]).

markCell(N, {A, _}) when A == N -> {A, marked};
markCell(N, {A, U}) when A /= N -> {A, U}.

mark(N, Board)->
    lists:map(fun(Line)->lists:map(fun(C)->markCell(N,C)end,Line)end,Board).

partOne([Draw|Rest], Boards) ->
    NextBoards = lists:map(fun(B)->mark(Draw,B)end, Boards),
    case lists:filter(fun(B)-> winning(B) end, NextBoards) of
        [] -> partOne(Rest, NextBoards);
        [Board] -> unmarked(Board)*Draw;
        U -> print(U),print(lists:map(fun(B)->unmarked(B)*Draw end, U))
    end.

playUntilWon([H|T], B) -> 
    NextBoard =  mark(H,B),
    case winning(NextBoard) of
        true -> unmarked(NextBoard)*H;
        false -> playUntilWon(T,NextBoard)
    end.

partTwo([Draw|Rest], Boards) ->
    NextBoards = lists:map(fun(B)->mark(Draw,B)end, Boards),
    case NextBoards of
        [Board] -> playUntilWon(Rest, Board);
        _ -> partTwo(Rest, lists:filter(fun(B)->not winning(B) end, NextBoards))
    end.

unmarked(Board) ->
    lists:sum(lists:map(
        fun({N,_})->N end, lists:filter(
            fun({_,A})->A==unmarked end, lists:flatten(Board)))).

main(_) -> 
    {ok, Input} = file:read_file("input.txt"),
    Lines = string:split(Input, "\n\n", all),
    Draws = lists:map(
        fun(X) -> {A,_}=string:to_integer(X),A end, 
        string:split(lists:nth(1, Lines), ",", all)),
    Boards = lists:map(fun(B)->boardToInts(B) end, drop(1, Lines)),
    print(partOne(Draws, Boards)),
    print(partTwo(Draws, Boards)).
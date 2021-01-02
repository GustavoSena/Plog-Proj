/*------------------------------------CONVERSIONS--------------------------------------*/
symbol(9,S) :- S='*'.
symbol(10,S) :- S=' '.
symbol(e,S) :- S='O'.
symbol(Track,S) :- S=Track.


subsCode(48, 0).
subsCode(49, 1).
subsCode(50, 2).
subsCode(51, 3).
subsCode(52, 4).
subsCode(53, 5).
subsCode(54, 6).
subsCode(55, 7).
subsCode(56, 8).
subsCode(57, 9).
subsCode(58, 10).
subsCode(59, 11).
subsCode(60, 12).
subsCode(61, 13).


/*Initializes a list that in addition to the fixed values ​​that represent the tracks, a decision variable that can take the value 9 or 10 is assigned to the remaining elements
9 - represents a mine
10 - represents an empty cell*/
/*init(+Puzzle, -List)*/
init([], []).

init([H1|Puzzle], [H2|List]) :-
    H1 = e,
    H2 in {9, 10},
    init(Puzzle, List).

init([H1|Puzzle], [H2|List]) :-
    H1 \= e,
    H2 = H1,
    init(Puzzle, List).

initG([], []).

initG([H1|Puzzle], [H2|List]) :-
    var(H1),
    H2 in (0..10),
    initG(Puzzle, List).

initG([H1|Puzzle], [H2|List]) :-
    \+var(H1),
    H2 = H1,
    initG(Puzzle, List).


/*Converts a list to a matrix*/
/*list_to_matrix(+List, +Size, -Board)*/
listToMatrix([], _, []).

listToMatrix(List, Size, [Row|Matrix]):-
  listToMatrixRow(List, Size, Row, Tail),
  listToMatrix(Tail, Size, Matrix).

listToMatrixRow(Tail, 0, [], Tail).

listToMatrixRow([Item|List], Size, [Item|Row], Tail):-
  NSize is Size-1,
  listToMatrixRow(List, NSize, Row, Tail).

/*----------------------------------------GETS-----------------------------------------*/
/*Gets the element with the given coordinate*/
/*getElement(+Board, +Row, +Column, -SelectedElement)*/
getElement(Board, Row, Column, SelectedColumn) :-
    nth1(Row, Board, SelectedRow),
    nth1(Column, SelectedRow, SelectedColumn).


/*Gives a new board updated with the move made by the player*/
/*When it reaches the row of the play cell, updates that row and saves it in the NewBoard. Then continues to copy the remaining rows*/
/*getUpdateBoard(+OldBoard, -NewBoard, +Move)*/
getUpdateBoard([OldRow|OldBoard], [NewRow|NewBoard], Column-1, Value) :-
    getUpdateRow(OldRow, NewRow, Column-1, Value),
    getUpdateBoard(OldBoard, NewBoard).

/*Copies the OldBoard row to the NewBoard*/
/*getUpdateBoard(+OldBoard, -NewBoard, +Move)*/
getUpdateBoard([OldRow|OldBoard], [OldRow|NewBoard], Column-Row, Value) :-
    NRow is Row - 1,
    getUpdateBoard(OldBoard, NewBoard, Column-NRow, Value).

/*Reaches the end of the OldBoard*/
/*getUpdateBoard(+OldBoard, -NewBoard)*/
getUpdateBoard([], []).

/*Continues to copy the remaining rows*/
/*getUpdateBoard(+OldBoard, -NewBoard)*/
getUpdateBoard([OldRow|OldBoard], [OldRow|NewBoard]) :-
    getUpdateBoard(OldBoard, NewBoard).

/*When it reaches the column of the play cell, updates that column with given value, to signal an empty cell, and saves it in the NewRow. Then continues to copy the remaining columns*/
/*getUpdateRow(+OldRow, -NewRow, +Move)*/
getUpdateRow([OldColumn|OldRow], [NewColumn|NewRow], 1-Row, Value) :-
    NewColumn = Value,
    getUpdateRow(OldRow, NewRow).

/*Copies the OldRow column to the NewRow*/
/*getUpdateRow(+OldRow, -NewRow, +Move)*/
getUpdateRow([OldColumn|OldRow], [OldColumn|NewRow], Column-Row, Value) :-
    NColumn is Column - 1,
    getUpdateRow(OldRow, NewRow, NColumn-Row, Value).

/*Reaches the end of the OldRow*/
/*getUpdateRow(+OldRow, -NewRow)*/
getUpdateRow([], []).

/*Continues to copy the remaining columns*/
/*getUpdateRow(+OldRow, -NewRow)*/
getUpdateRow([OldColumn|OldRow], [OldColumn|NewRow]) :-
    getUpdateRow(OldRow, NewRow).


/*------------------------------------VERIFICATIONS------------------------------------*/
/*Checks if the coordinates are within the limits*/
/*check_coordinate(+Row, +Column, +Size)*/
checkCoordinate(Row, Column, Size) :-
    Row =< Size, Row >= 1,
    Column =< Size, Column >= 1.


/*Checks if there are still plays*/
/*checkMoves(+Puzzle)*/
checkMoves([], Counter) :-
  Counter \= 0.

checkMoves([Row|Puzzle], Counter) :-
    member(10, Row),
    NewCounter is Counter + 1,
    checkMoves(Puzzle, NewCounter).

checkMoves([Row|Puzzle], Counter) :-
    \+member(10, Row),
    checkMoves(Puzzle, Counter).


/*Checks if the coordinate selected by the user has a mine*/
/*checkMine(+Puzzle, +Column, +Row)*/
checkMine(Puzzle, Column, Row) :-
    getElement(Puzzle, Row, Column, SelectedElement),
    SelectedElement = 9.


/*-------------------------------------STATISTICS--------------------------------------*/
reset_timer:-
    statistics(total_runtime, _).

print_time(Msg):-
    statistics(total_runtime,[_,T]),
    TS is ((T//10)*10)/1000, nl,
    write(Msg), write(TS), write('s'), nl, nl.


/*----------------------------------------BOARD----------------------------------------*/
memberN(List, Value, Number) :-
    include(=(Value), List, NewList), 
    length(NewList, N),
    N >= Number.


/*Puts the mines at the start of the MergedList before filling with the remaining variables from List.*/
/*merge(+List, +ListMines, -MergedList)*/
merge(List, [], List).

merge([_|List], [Mine|ListMines], [Mine|MergedList]) :- 
    merge(List, ListMines, MergedList).

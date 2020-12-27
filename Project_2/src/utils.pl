/*---------------------------------------*/
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


/*---------------------------------------*/
/*Converts a list to a matrix*/
/*list_to_matrix(+List, +Size, -Board)*/
list_to_matrix([], _, []).

list_to_matrix(List, Size, [Row|Matrix]):-
  list_to_matrix_row(List, Size, Row, Tail),
  list_to_matrix(Tail, Size, Matrix).

list_to_matrix_row(Tail, 0, [], Tail).

list_to_matrix_row([Item|List], Size, [Item|Row], Tail):-
  NSize is Size-1,
  list_to_matrix_row(List, NSize, Row, Tail).


/*---------------------------------------*/
/*Select the element with the given coordinate*/
/*select_element(+Board, +Row, +Column, -SelectedElement)*/
select_element(Board, Row, Column, SelectedColumn) :-
    nth1(Row, Board, SelectedRow),
    nth1(Column, SelectedRow, SelectedColumn).


/*---------------------------------------*/
/*Checks if the coordinates are within the limits*/
/*check_coordinate(+Row, +Column, +Size)*/
check_coordinate(Row, Column, Size) :-
    Row =< Size, Row >= 1,
    Column =< Size, Column >= 1.
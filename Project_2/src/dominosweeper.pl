:- consult('utils.pl').

:- use_module(library(clpfd)).
:- use_module(library(lists)).

dominosweeper(List) :-

/*Declaring Variables and Domains*/

    B = [2, e, e, e, e, e, 
         e, e, e, e, e, e,
         e, e, e, 3, e, 3, 
         2, e, 0, e, e, e, 
         e, e, e, e, e, e, 
         e, e, e, e, e, 1],
    
    init(B, List),

    list_to_matrix(List, 6, Board),

/*Placement of Restrictions*/
    for_element(Board, 6, 1, 1),

/*Solution Research*/
    labeling([], List),  write(Board).

/*---------------------------------------*/
/*For each element found, restrictions are applied according on the game rules*/
/*for_element(+Board, +Size, +Row, +Column)*/

/*In case it reaches the end of the board*/
for_element(Board, Size, Row, Column) :-
    Row is Size + 1.

/*In case it reaches the end of the board row*/
for_element(Board, Size, Row, Column) :-
    check_coordinate(Row, Column, Size),

    Column = Size,

    /*write(Row-Column),
    write('\n'),*/
    
    restrictions(Board, Row, Column), !,

    NewRow is Row + 1,
    NewColumn is 1,

    for_element(Board, Size, NewRow, NewColumn).

/*In case of normal flow*/
for_element(Board, Size, Row, Column) :-
    check_coordinate(Row, Column, Size),
    
    restrictions(Board, Row, Column), !,

    /*write(Row-Column),
    write('\n'),*/

    NewColumn is Column + 1,

    for_element(Board, Size, Row, NewColumn).    

/*---------------------------------------*/
/*Each cell in the table is changed according to the restrictions implemented*/
/*restrictions(+Board, +Row, +Column)*/

/*In case the selected element is a track*/
restrictions(Board, Row, Column) :-
    select_element(Board, Row, Column, Element),

    \+fd_var(Element),

    Element #>= 0, Element #=< 8, 

    surrounded_mines(Board, Row, Column, AdjacentVariables),
    
    exacly(Element, AdjacentVariables, 9), !.

/*In case the selected element is a decision variable*/
restrictions(Board, Row, Column) :-
    select_element(Board, Row, Column, Element),

    fd_var(Element),

    adjacency_mines(Board, Element, Row, Column), !.

restrictions(Board, Row, Column).

/*---------------------------------------*/
/*For each element that is a decision variable, the value of the adjacent cells is checked, not counting 
the diagonals, and in case the selected element has the value of a mine, then it is adjacent to exactly one other mine.*/
/*adjacency_mines(+Board, +Element, +Row, +Column)*/
adjacency_mines(Board, Element, Row, Column) :-
    
    RowPlus is Row + 1,
    RowSubtract is Row - 1,
    ColumnPlus is Column + 1,
    ColumnSubtract is Column - 1,

    /*East*/
    east(Board, Row, ColumnPlus, E),

    /*West*/
    west(Board, Row, ColumnSubtract, W),

    /*North*/
    north(Board, RowSubtract, Column, N),

    /*South*/
    south(Board, RowPlus, Column, S),

    ((Element #= 9) #/\ ((E #= 9 #/\ W #\= 9 #/\ N #\= 9 #/\ S #\= 9) #\/ 
                         (E #\= 9 #/\ W #= 9 #/\ N #\= 9 #/\ S #\= 9) #\/
                         (E #\= 9 #/\ W #\= 9 #/\ N #= 9 #/\ S #\= 9) #\/
                         (E #\= 9 #/\ W #\= 9 #/\ N #\= 9 #/\ S #= 9)
                        )
    )
    #\/
    Element #= 10.


/*---------------------------------------*/
/*For each element that is a track, all values ​​that are found around it are saved, and then 
checks whether the number of values ​​found with the value 9 is exactly equal to the track value*/
/*surrounded_mines(+Board, +Row, +Column, -AdjacentVariables)*/
surrounded_mines(Board, Row, Column, AdjacentVariables) :-

    RowPlus is Row + 1,
    RowSubtract is Row - 1,
    ColumnPlus is Column + 1,
    ColumnSubtract is Column - 1,

    /*East*/
    east(Board, Row, ColumnPlus, E),

    /*West*/
    west(Board, Row, ColumnSubtract, W),

    /*North*/
    north(Board, RowSubtract, Column, N),

    /*South*/
    south(Board, RowPlus, Column, S),

    /*NorthEast*/
    northEast(Board, RowSubtract, ColumnPlus, NE),

    /*NorthWest*/
    northWest(Board, RowSubtract, ColumnSubtract, NW),

    /*SouthEast*/
    southEast(Board, RowPlus, ColumnPlus, SE),

    /*SouthWest*/
    southWest(Board, RowPlus, ColumnSubtract, SW),

    append([E, W, N, S], [NE, NW, SE, SW], AdjacentVariables).

/*---------------------------------------*/
/*Returns the respective element to the given coordinate*/

/*Adjoining cell with North direction*/
north(Board, Row, Column, N) :-
    select_element(Board, Row, Column, N).
north(Board, Row, Column, 0).

/*Adjoining cell with South direction*/
south(Board, Row, Column, S) :-
    select_element(Board, Row, Column, S).
south(Board, Row, Column, 0).

/*Adjoining cell with East direction*/
east(Board, Row, Column, E) :-
    select_element(Board, Row, Column, E).
east(Board, Row, Column, 0).

/*Adjoining cell with West direction*/
west(Board, Row, Column, W) :-
    select_element(Board, Row, Column, W).
west(Board, Row, Column, 0).

/*Adjoining cell with North East direction*/
northEast(Board, Row, Column, NE) :-
    select_element(Board, Row, Column, NE).
northEast(Board, Row, Column, 0).

/*Adjoining cell with North West direction*/
northWest(Board, Row, Column, NW) :-
    select_element(Board, Row, Column, NW).
northWest(Board, Row, Column, 0).

/*Adjoining cell with South East direction*/
southEast(Board, Row, Column, SE) :-
    select_element(Board, Row, Column, SE).
southEast(Board, Row, Column, 0).

/*Adjoining cell with South West direction*/
southWest(Board, Row, Column, SW) :-
    select_element(Board, Row, Column, SW).
southWest(Board, Row, Column, 0).


/*---------------------------------------*/
/*Materializable restrictions are used, so that the value stored in the variable Id, that corresponds to the identification of a mine, 
occurs exactly the number of times given by Counter, which refers to the number of adjacent houses, in the AdjacentVariables list*/
/*exacly(+Counter, +AdjacentVariables, +Id)*/
exacly(0, [], _).

exacly(Counter, [Element|AdjacentVariables], Id) :-

    (Element #= Id) #<=> Bool,
    Counter #= NewCounter + Bool,
    exacly(NewCounter, AdjacentVariables, Id).
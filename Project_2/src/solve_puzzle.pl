solvePuzzle(Puzzle, Size, List) :-
    init(Puzzle, List),

    listToMatrix(List, Size, Board),

    forElement(Board, Size, 1, 1),
    
    labeling([], List).


/*For each element found, restrictions are applied according on the game rules*/
/*for_element(+Board, +Size, +Row, +Column)*/

/*In case it reaches the end of the board*/
forElement(Board, Size, Row, Column) :-
    Row is Size + 1.

/*In case it reaches the end of the board row*/
forElement(Board, Size, Row, Column) :-
    checkCoordinate(Row, Column, Size),

    Column = Size,

    /*write(Row-Column),
    write('\n'),*/
    
    restrictions(Board, Row, Column), !,

    NewRow is Row + 1,
    NewColumn is 1,

    forElement(Board, Size, NewRow, NewColumn).

/*In case of normal flow*/
forElement(Board, Size, Row, Column) :-
    checkCoordinate(Row, Column, Size),
    
    restrictions(Board, Row, Column), !,

    /*write(Row-Column),
    write('\n'),*/

    NewColumn is Column + 1,

    forElement(Board, Size, Row, NewColumn).    


/*Each cell in the table is changed according to the restrictions implemented*/
/*restrictions(+Board, +Row, +Column)*/

/*In case the selected element is a track*/
restrictions(Board, Row, Column) :-
    getElement(Board, Row, Column, Element),

    \+fd_var(Element),

    Element #>= 0, Element #=< 8, 

    surroundedMines(Board, Row, Column, AdjacentVariables),
    
    exacly(Element, AdjacentVariables, 9), !.

/*In case the selected element is a decision variable*/
restrictions(Board, Row, Column) :-
    getElement(Board, Row, Column, Element),

    fd_var(Element),

    adjacencyMines(Board, Element, Row, Column), !.

restrictions(Board, Row, Column).


/*For each element that is a decision variable, the value of the adjacent cells is checked, not counting 
the diagonals, and in case the selected element has the value of a mine, then it is adjacent to exactly one other mine.*/
/*adjacency_mines(+Board, +Element, +Row, +Column)*/
adjacencyMines(Board, Element, Row, Column) :-
    
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


/*For each element that is a track, all values ​​that are found around it are saved, and then 
checks whether the number of values ​​found with the value 9 is exactly equal to the track value*/
/*surrounded_mines(+Board, +Row, +Column, -AdjacentVariables)*/
surroundedMines(Board, Row, Column, AdjacentVariables) :-

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


/*Returns the respective element to the given coordinate*/

/*Adjoining cell with North direction*/
north(Board, Row, Column, N) :-
    getElement(Board, Row, Column, N).
north(Board, Row, Column, 0).

/*Adjoining cell with South direction*/
south(Board, Row, Column, S) :-
    getElement(Board, Row, Column, S).
south(Board, Row, Column, 0).

/*Adjoining cell with East direction*/
east(Board, Row, Column, E) :-
    getElement(Board, Row, Column, E).
east(Board, Row, Column, 0).

/*Adjoining cell with West direction*/
west(Board, Row, Column, W) :-
    getElement(Board, Row, Column, W).
west(Board, Row, Column, 0).

/*Adjoining cell with North East direction*/
northEast(Board, Row, Column, NE) :-
    getElement(Board, Row, Column, NE).
northEast(Board, Row, Column, 0).

/*Adjoining cell with North West direction*/
northWest(Board, Row, Column, NW) :-
    getElement(Board, Row, Column, NW).
northWest(Board, Row, Column, 0).

/*Adjoining cell with South East direction*/
southEast(Board, Row, Column, SE) :-
    getElement(Board, Row, Column, SE).
southEast(Board, Row, Column, 0).

/*Adjoining cell with South West direction*/
southWest(Board, Row, Column, SW) :-
    getElement(Board, Row, Column, SW).
southWest(Board, Row, Column, 0).


/*Materializable restrictions are used, so that the value stored in the variable Id, that corresponds to the identification of a mine, 
occurs exactly the number of times given by Counter, which refers to the number of adjacent houses, in the AdjacentVariables list*/
/*exacly(+Counter, +AdjacentVariables, +Id)*/
exacly(0, [], _).

exacly(Counter, [Element|AdjacentVariables], Id) :-

    (Element #= Id) #<=> Bool,
    Counter #= NewCounter + Bool,
    exacly(NewCounter, AdjacentVariables, Id).
solvePuzzle(Puzzle, Size, Board) :-

    init(Puzzle, List),

    listToMatrix(List, Size, Board),

    forElement(Board, Size, 1, 1),

    reset_timer,

    labeling([], List),
    print_time,
	fd_statistics.


/*For each element found, restrictions are applied according on the game rules*/
/*for_element(+Board, +Size, +Row, +Column)*/
/*In case it reaches the end of the board*/
forElement(Board, Size, Row, Column) :-
    Row is Size + 1.

/*In case it reaches the end of the board row*/
forElement(Board, Size, Row, Column) :-

    Column = Size,

    checkCoordinate(Row, Column, Size),

    restrictions(Board, Row, Column),

    NewRow is Row + 1,
    NewColumn is 1,

    forElement(Board, Size, NewRow, NewColumn).

/*In case of normal flow*/
forElement(Board, Size, Row, Column) :-
    checkCoordinate(Row, Column, Size),

    restrictions(Board, Row, Column),

    NewColumn is Column + 1,

    forElement(Board, Size, Row, NewColumn).    

    
/*Each cell in the table is changed according to the restrictions implemented*/
/*restrictions(+Board, +Row, +Column)*/
/*In case the selected element is a decision variable between 9 and 10*/
restrictions(Board, Row, Column) :-
    getElement(Board, Row, Column, Element),

    (Element #=< 10 , Element #>= 9), !,

    adjacencyMines(Board, Element, Row, Column).

/*In case the selected element is a track*/
restrictions(Board, Row, Column) :-

    getElement(Board, Row, Column, Element),

    \+var(Element), !,

    ((Element =< 10 , Element >= 9) ;
        
    (Element >= 0, Element =< 8, 

    surroundedMines(Board, Row, Column, AdjacentVariables),

    exacly(Element, AdjacentVariables, 9))).


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

    (Element #= 9 #/\ (
        (E #= 9 #/\ W #\= 9 #/\ N #\= 9 #/\ S #\= 9) #\/ 
        (E #\= 9 #/\ W #= 9 #/\ N #\= 9 #/\ S #\= 9) #\/
        (E #\= 9 #/\ W #\= 9 #/\ N #= 9 #/\ S #\= 9) #\/
        (E #\= 9 #/\ W #\= 9 #/\ N #\= 9 #/\ S #= 9))
    ) #\/
    (Element #= 10).


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
getPuzzle(1, 3, [2, e, e,
                 e, e, e,
                 e, e, 0]).

getPuzzle(2, 4, [2, e, e, 1, 
                 e, e, e, 1,
                 e, e, 2, e, 
                 2, e, e, e]).

getPuzzle(3, 5, [1, e, e, 3, e,
                 e, e, e, e, e,
                 e, e, e, 3, e,
                 1, e, 0, e, 1,
                 e, e, e, e, e]).

getPuzzle(4, 6, [2, e, e, e, e, e, 
                 e, e, e, e, e, e,
                 e, e, e, 3, e, 3, 
                 2, e, 0, e, e, e, 
                 e, e, e, e, e, e, 
                 e, e, e, e, e, 1]).

getPuzzle(5, Size, Puzzle) :-
     decideSize(Size),
     repeat,
     generate(Size, P),
     preparePuzzle(P, Puzzle).

/*---------------------------------------GENERATE--------------------------------------*/
generate(Size, PuzzleList) :-

    /*Generate a List*/
    Len is Size * Size,
    length(L, Len),

    N is Size * Size / 5,
    NMines is floor(N),
    length(ListMines, NMines),
    maplist(=(9), ListMines),

    merge(L, ListMines, MergedList),
    random_permutation(MergedList, List),

    initG(List, PuzzleList),

    listToMatrix(PuzzleList, Size, Puzzle),

    forEach(Puzzle, Size, 1, 1),

    labeling([], PuzzleList),
    
    X is NMines + 3,
    random(3, X, NGuesses),
    memberN(PuzzleList, 10, NGuesses).

/*In case it reaches the end of the board*/
forEach(Board, Size, Row, Column) :-
    Row is Size + 1.

/*In case it reaches the end of the board row*/
forEach(Board, Size, Row, Column) :-

    Column = Size,

    checkCoordinate(Row, Column, Size),

    generateRestrictions(Board, Row, Column),

    NewRow is Row + 1,
    NewColumn is 1,

    forEach(Board, Size, NewRow, NewColumn).

/*In case of normal flow*/
forEach(Board, Size, Row, Column) :-
    checkCoordinate(Row, Column, Size),

    /*(Column = 3, Row = 2, trace; true),*/

    generateRestrictions(Board, Row, Column),

    NewColumn is Column + 1,

    forEach(Board, Size, Row, NewColumn).    


/*Each cell in the table is changed according to the restrictions implemented*/
/*restrictions(+Board, +Row, +Column)*/
/*In case the selected element is a track*/
/*In case the selected element is a decision variable*/
generateRestrictions(Board, Row, Column) :-

    getElement(Board, Row, Column, Element),

    var(Element), 

    /*write(Row-Column), nl,*/

    surroundedMines(Board, Row, Column, AdjacentVariables),

    exacly(Element, AdjacentVariables, 9).

generateRestrictions(Board, Row, Column) :-
    getElement(Board, Row, Column, Element),

    Element #>= 9, Element #=< 10,

    /*write(Row-Column), nl,*/

    adjacencyMines(Board, Element, Row, Column).


preparePuzzle(P1, Puzzle) :-
     replace(9, P1, P2),
     replace(10, P2, Puzzle).

replace(_, [], []).

replace(Value, [H1|P], [H2|Puzzle]) :-
     H1 = Value,
     H2 = e,
     replace(Value, P, Puzzle).

replace(Value, [H1|P], [H1|Puzzle]) :-
     H1 \= Value,
     replace(Value, P, Puzzle).
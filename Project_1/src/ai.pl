/*Gets a random move as a computer move*/
/*choose_move(+GameState, +Player, +Level, -Move, -Skip)*/
choose_move(GameState, Player, 'rand', CurrCol-CurrRow-NewCol-NewRow, Skip) :-
    valid_moves(GameState, Player, ListOfMoves),
    length(ListOfMoves, S),
    Size is S - 1,
    Size > 0,
    Skip = 'n',

    random(0, Size, Random), 
    nth0(Random, ListOfMoves, Value-CurrCol-CurrRow-NewCol-NewRow). 


/*Gets a greedy move as a computer move*/
/*choose_move(+GameState, +Player, +Level, -Move, -Skip)*/
choose_move(GameState, Player, 'greedy', CurrCol-CurrRow-NewCol-NewRow, Skip) :-
    valid_moves(GameState, Player, ListOfMoves),
    length(ListOfMoves, Size),
    Size > 0,
    Skip = 'n',

    nth0(0, ListOfMoves, Value-CurrCol-CurrRow-NewCol-NewRow). 


/*When there are no more valid moves*/
/*choose_move(+GameState, +Player, +Level, -Move, -Skip)*/
choose_move(GameState, Player, Level, CurrCol-CurrRow-NewCol-NewRow, 'y').


/*Gives the list of possible moves depending on the Board and the player*/
/*valid_moves(+Board, +Player, -ListOfMoves)*/
valid_moves(Board, Player, ListOfMoves) :-
    setof(Value-CurrColumn-CurrRow-NewColumn-NewRow, NewBoard^UpdatedBoard^(generateMove(Player, Board, CurrColumn-CurrRow-NewColumn-NewRow), move(Board, CurrColumn, CurrRow, NewBoard, NewColumn, NewRow, Player), once(getValue(UpdatedBoard, NewBoard, Player, Value, 0, NewColumn, NewRow))), List),
    reverse(List, ListOfMoves).

/*Generates possible moves*/   
/*generateMove(+Player, +Board, -CurrColumn-CurrRow-NewColumn-NewRow)*/
generateMove(Player, Board, CurrColumn-CurrRow-NewColumn-NewRow) :-
    checkGeneratePosition(Player, Board, CurrColumn-CurrRow),
    checkGenerateMove(Player,Board, CurrColumn-CurrRow-NewColumn-NewRow).


/*Checks if the generated piece belongs to the player*/
/*checkGeneratePosition(+Player, +Board, -CurrColumn-CurrRow)*/
checkGeneratePosition(Player, Board, CurrColumn-CurrRow) :-
    nth0(CurrRow,Board,RowList),
    nth0(CurrColumn,RowList,ColList),
    last(ColList,Color),
    Color = Player.


/*Checks the possible generated position*/ 
/*checkGenerateMove(+Player, +Board, -CurrColumn-CurrRow-NewColumn-NewRow)*/
checkGenerateMove(Player, Board, CurrColumn-CurrRow-NewColumn-NewRow) :-

    /*up movement*/
    (   NewRow is CurrRow - 1,
        NewRow >= 0,
        checksProposedMove(Player, Board, CurrColumn-CurrRow-CurrColumn-NewRow),
        NewColumn is CurrColumn
    )
    ;
    /*down movement*/
    (
        NewRow is CurrRow + 1,
        length(Board, Size),
        NewRow =< Size,
        checksProposedMove(Player, Board, CurrColumn-CurrRow-CurrColumn-NewRow),
        NewColumn is CurrColumn
    )
    ;
    /*left movement*/
    (
        NewColumn is CurrColumn - 1,
        NewColumn >= 0,
        checksProposedMove(Player, Board, CurrColumn-CurrRow-NewColumn-CurrRow),
        NewRow is CurrRow
    )
    ;
    /*right movement*/
    (
        NewColumn is CurrColumn + 1,
        length(Board, Size),
        NewColumn =< Size,
        checksProposedMove(Player, Board, CurrColumn-CurrRow-NewColumn-CurrRow),
        NewRow is CurrRow
    )
    ;
    fail.


/*Checks whether the proposed movement is valid*/
/*checksProposedMove(+Player, +Board, -CurrColumn-CurrRow-NewColumn-NewRow)*/
checksProposedMove(Player, Board, CurrColumn-CurrRow-NewColumn-NewRow) :-

    /*Checks if the piece belong to the player*/
    nth0(NewRow,Board,RowList),
    nth0(NewColumn,RowList,ColList),
    last(ColList,Color),
    Color \= Player,

    /*Checks if the two stacks are the same size*/
    nth0(CurrRow,Board,OldRow),
    nth0(CurrColumn,OldRow,OldCol),
    length(ColList,NewSize),
    length(OldCol,CurrSize),
    CurrSize = NewSize.
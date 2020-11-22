play:-
    Size is 3,
    generateBoard(GameState,Size),
    gameLoop(GameState,black,0).



    /*valid_moves(NewBoard, Player, L),
    write(L).*/

gameLoop(GameState,Player, TimesSkip) :-
    displayGame(GameState, Player),
    write(TimesSkip), write('\n'),
    TimesSkip =\=2, !,
     
    write('Get move\n'),
    getMove(Player, GameState, CurrColumn, CurrRow, NewColumn, NewRow, Skip),
    (
        (Skip == 'n',
        NewTimesSkip is 0,
        move(GameState, CurrColumn, CurrRow, NewBoard, NewColumn, NewRow)
        )
    ;
    
        (Skip == 'y',
        NewTimesSkip is TimesSkip + 1,
        write('You skip turn!\n'),
        NewBoard = GameState
        )
    ),

    nextPlayer([Player],NextPlayer),
    gameLoop(NewBoard, NextPlayer, NewTimesSkip).

gameLoop(GameState,Player, TimesSkip) :-
    write('game over\n'),
    game_over(GameState, Winner),
    write(Winner).
    
    
/*Executes a move, obtaining a new board*/
move(OldBoard, OldColumn, OldRow, NewBoard, NewColumn, NewRow) :-
    insertStack(OldBoard, UpdBoard, NewColumn, NewRow, [black]),
    removeStack(UpdBoard, NewBoard, OldColumn, OldRow, [black]).

/*Inserts the new piece into the stack to play*/
insertStack(OldBoard,NewBoard,Column,Row,Color):-
    nth0(Row,OldBoard,RowList),
    nth0(Column,RowList,ColList),
    append(ColList,Color,NewCol),
    replace_nth0(RowList,Column,ColList,NewCol,NewRow),
    replace_nth0(OldBoard,Row,RowList,NewRow,NewBoard).

/*Removes the piece from the stack to play*/
removeStack(OldBoard, NewBoard, Column, Row, Color) :-
    nth0(Row,OldBoard,RowList),
    nth0(Column,RowList,ColList),

    length(ColList, ColSize),
    IndexCol is ColSize - 1,
    nextPlayer(Color, NextPlayer),
    currPlayer(Color, CurrPlayer),

    replace_nth0(ColList, IndexCol, CurrPlayer, NextPlayer,NewCol),
    replace_nth0(RowList,Column,ColList,NewCol,NewRow),
    replace_nth0(OldBoard,Row,RowList,NewRow,NewBoard).

/*Gives the list of possible moves depending on the Board and the player*/
valid_moves(Board, Player, ListOfMoves) :-
    findall(CurrColumn-CurrRow-NewColumn-NewRow, makemove(Player, Board, CurrColumn-CurrRow-NewColumn-NewRow), ListOfMoves).

/*Generates possible moves*/   
makemove(Player, Board, CurrColumn-CurrRow-NewColumn-NewRow) :-
    checkPosition(Player, Board, CurrColumn-CurrRow),
    checkMove(Player,Board, CurrColumn-CurrRow-NewColumn-NewRow).

/*Check if the piece belongs to the player*/
checkPosition(Player,Board, CurrColumn-CurrRow) :-
    nth0(CurrRow,Board,RowList),
    nth0(CurrColumn,RowList,ColList),
    last(ColList,Color),
    Color = Player.

/*Checks the new position*/ 
checkMove(Player, Board, CurrColumn-CurrRow-NewColumn-NewRow) :-
    /*up movement*/
    NewRow is CurrRow - 1,
    NewRow >= 0,
    checksProposedMove(Player, Board, CurrColumn-CurrRow-CurrColumn-NewRow),
    NewColumn is CurrColumn
    ;
    /*down movement*/
    NewRow is CurrRow + 1,
    length(Board, Size),
    NewRow =< Size,
    checksProposedMove(Player, Board, CurrColumn-CurrRow-CurrColumn-NewRow),
    NewColumn is CurrColumn
    ;
    /*left movement*/
    NewColumn is CurrColumn - 1,
    NewColumn >= 0,
    checksProposedMove(Player, Board, CurrColumn-CurrRow-NewColumn-CurrRow),
    NewRow is CurrRow
    ;
    /*right movement*/
    NewColumn is CurrColumn + 1,
    length(Board, Size),
    NewColumn =< Size,
    checksProposedMove(Player, Board, CurrColumn-CurrRow-NewColumn-CurrRow),
    NewRow is CurrRow
    ;
    fail.

/*Checks whether the proposed movement is valid*/
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






game_over(GameState, Winner):-
    value(GameState,white,WhiteScore),
    value(GameState,white,BlackScore),
    
    WhiteScore > BlackScore,
    Winner = white
    ;
    WhiteScore < BlackScore,
    Winner = black.



value(GameState, Player, Value):-
    NewBoard is GameState,
    getValue(NewBoard,Player,Value).
    
getValue(Board,Player,Value):-
    getValue(Board,Player,Value,0,0).

getValue(Board,Player,Value,CurrColumn,CurrRow):-
    getCellColor(Board,CurrColumn,CurrRow,Color),
    Color \= visited,
    Color = Player,
    replaceValue(Board,NewBoard,CurrColumn,CurrRow,Player),
    Value is Value+1,
    length(NewBoard, Size),
    /*up movement*/
    NewRow is CurrRow - 1,
    NewRow >= 0,
    getValue(NewBoard, Player, Value, CurrColumn,NewRow)
    ;
    /*down movement*/
    NewRow is CurrRow + 1,
    NewRow =< Size,
    getValue(NewBoard, Player, Value,CurrColumn,NewRow)
    ;
    /*left movement*/
    NewColumn is CurrColumn - 1,
    NewColumn >= 0,
    getValue(NewBoard, Player, Value,NewColumn,CurrRow)
    ;
    /*right movement*/
    NewColumn is CurrColumn + 1,
    NewColumn =< Size,
    getValue(NewBoard, Player, Value,NewColumn,CurrRow)
    ;
    fail.



replaceValue(OldBoard, NewBoard, Column, Row, Color) :-
    nth0(Row,OldBoard,RowList),
    nth0(Column,RowList,ColList),

    length(ColList, ColSize),
    IndexCol is ColSize - 1,
    NextPlayer is visited,
    currPlayer(Color, CurrPlayer),

    replace_nth0(ColList, IndexCol, CurrPlayer, NextPlayer,NewCol),
    replace_nth0(RowList,Column,ColList,NewCol,NewRow),
    replace_nth0(OldBoard,Row,RowList,NewRow,NewBoard).

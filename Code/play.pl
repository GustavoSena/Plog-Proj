play:-
    Size is 3,
    generateBoard(GameState,Size),
    
    gameLoop(GameState,black,0).


    
    /*testingLoop(GameState,black).*/

    /*valid_moves(NewBoard, Player, L),
    write(L).*/



testingLoop(GameState,Player):-
    searchForColor(GameState,Player,0,0,Col,Row),
    write(Col-Row),write('\n').




gameLoop(GameState,Player, TimesSkip) :-
    TimesSkip =\=2 , !,

    displayGame(GameState, Player),
    getMove(Player, GameState, CurrColumn, CurrRow, NewColumn, NewRow, Skip),
    (
        (Skip == 'n',
        NewTimesSkip is 0,
        move(GameState, CurrColumn, CurrRow, NewBoard, NewColumn, NewRow, Player)
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
    game_over(GameState, Winner),
    write(Winner).
    
    
/*Executes a move, obtaining a new board*/
move(OldBoard, OldColumn, OldRow, NewBoard, NewColumn, NewRow, Player) :-
    insertStack(OldBoard, UpdBoard, NewColumn, NewRow, [Player]),
    removeStack(UpdBoard, NewBoard, OldColumn, OldRow, [Player]).

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
    value(GameState,black,BlackScore),
    
    
    
    write(WhiteScore-BlackScore),write('\n'),
    
    (WhiteScore > BlackScore,
    Winner = white)
    ;
    (WhiteScore < BlackScore,
    Winner = black).



value(GameState, Player, Value):-
    NewBoard = GameState,
    valueCicle(NewBoard,Player,Value, 0).



valueCicle(Board, Player, Value, OldValue):-
    
    searchForColor(Board,Player,0,0,Col,Row),!,
    
    write(Col-Row),write('(col and row)\n'),
    (trace;true),
    getValue(UpdatedBoard,Board,Player,NewValue,0,Col,Row),
    (notrace;true),
    write(NewValue-OldValue),write('(new and old values)\n'),

    getBiggestValue(NewValue,OldValue,BiggestValue),
    write(BiggestValue),write('(Biggest value )\n'),

    valueCicle(UpdatedBoard,Player,Value,BiggestValue).

valueCicle(Board, Player, Value, OldValue):-
    Value is OldValue.

getValue(UpdatedBoard,Board,Player,ReturnValue,Value,CurrColumn,CurrRow):-
    length(Board, Size),
    /*write(CurrColumn-CurrRow-Size), write('\n'),*/
    
    (CurrRow>=0,
    CurrRow<Size,
    CurrColumn<Size,
    CurrColumn>=0),

    
    getCellColor(Board,CurrColumn,CurrRow,Color),
    
    Color \= visited,
    Color = Player,
    
    replaceValue(Board,NewBoard,CurrColumn,CurrRow,Player),
    
    /*write(NewBoard), write('\n'),*/
    NewValue is Value + 1,

    

    /*down movement*/
    RowDown is CurrRow + 1,
    getValue(UpdatedBoard,NewBoard, Player, ReturnValue,NewValue, CurrColumn, RowDown),
    NextValue is ReturnValue,

    /*right movement*/
    ColRight is CurrColumn + 1,
    getValue(UpdatedBoard,NewBoard, Player, ReturnValue,NextValue, ColRight, CurrRow),
    NextValue2 is ReturnValue,

    /*up movement*/
    RowUp is CurrRow - 1,
    getValue(UpdatedBoard,NewBoard, Player, ReturnValue,NextValue2, CurrColumn, RowUp),
    NextValue3 is ReturnValue,
    
    /*left movement*/
    ColLeft is CurrColumn - 1,
    getValue(UpdatedBoard,NewBoard, Player, ReturnValue,NextValue3, ColLeft, CurrRow).


/*getValue(UpdatedBoard,Board, Player, ReturnValue, Value, CurrColumn, CurrRow):-
    ReturnValue == Value,!,
    UpdatedBoard is Board.*/



getValue(UpdatedBoard,Board, Player, Value, Value, CurrColumn, CurrRow).








searchForColor(Board,Color,CurrCol,CurrRow,Col,Row):-
    nth0(CurrRow,Board,RowList),
    searchForColorInRow(RowList,Color,CurrCol,CurrRow,Col,Row).

searchForColor(Board,Color,CurrCol,CurrRow,Col,Row):-
    length(Board,Size),
    NewRow is CurrRow+1,
    NewRow<Size,!,
    searchForColor(Board,Color,CurrCol,NewRow,Col,Row).

searchForColorInRow(RowList,Color,CurrCol,CurrRow,Col,Row):-
    nth0(CurrCol,RowList,Column),
    searchForColorInCol(RowList,Color,Column,CurrCol,CurrRow,Col,Row).
    

searchForColorInCol(RowList,Color,Column,CurrCol,CurrRow,Col,Row):-
    last(Column,CheckColor),
    Color==CheckColor,
    Col is CurrCol,
    Row is CurrRow.


searchForColorInCol(RowList,Color,CurrCol,CurrRow,Col,Row):-
    length(RowList,Size),
    NewCol is CurrCol +1,
    NewCol<Size,!,
    searchForColorInRow(RowList,Color,NewCol,CurrRow,Col,Row).

















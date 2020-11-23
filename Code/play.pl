play:-
    Size is 3,
    generateBoard(GameState,Size),
    
    gameLoop(GameState,black,0).

    /*testingLoop(GameState,black).*/

    /*valid_moves(NewBoard, Player, L),
    write(L).*/



testingLoop(GameState,Player):-
    \+searchForColor(GameState,Player,0,0,Col,Row),
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
    
    
    
    WhiteScore > BlackScore,
    Winner = white
    ;
    WhiteScore < BlackScore,
    Winner = black.



value(GameState, Player, Value):-
    NewBoard = GameState,
    getValue(NewBoard,Player,Value).
    
getValue(Board,Player,Value):-
    getValue(Board,Player,Value,0,0,0).

getValue(Board,Player,ReturnValue,Value,CurrColumn,CurrRow):-

    length(Board, Size),
    write(CurrColumn-CurrRow-Size), write('\n'),
     write('Row>\n'),
    CurrRow>=0,
    

    getCellColor(Board,CurrColumn,CurrRow,Color),
    Color \= visited,
    Color = Player,
    Aux is CurrRow,
    replaceValue(Board,NewBoard,CurrColumn,Aux,Player),
    write(NewBoard), write('\n'),
    NewValue is Value + 1,

    /*up movement*/
    NewRow is CurrRow - 1,
    getValue(NewBoard, Player, ReturnValue,NewValue, CurrColumn, NewRow),
    
    ReturnValue is NewValue.

getValue(Board,Player,ReturnValue,Value,CurrColumn,CurrRow):-

    length(Board, Size),
    write(CurrColumn-CurrRow-Size), write('\n'),
    write('Row<\n'),
    CurrRow<Size,
    
    getCellColor(Board,CurrColumn,CurrRow,Color),
    Color \= visited,
    Color = Player,
    replaceValue(Board,NewBoard,CurrColumn,CurrRow,Player),
    write(NewBoard), write('\n'),
    NewValue is Value + 1,
    
    /*down movement*/
    NewRow is CurrRow + 1,
    getValue(NewBoard, Player, ReturnValue,NewValue, CurrColumn, NewRow),

    ReturnValue is NewValue.


getValue(Board,Player,ReturnValue,Value,CurrColumn,CurrRow):-

    length(Board, Size),
    write(CurrColumn-CurrRow-Size), write('\n'),
    write('Col<\n'),
    CurrColumn<Size,

    getCellColor(Board,CurrColumn,CurrRow,Color),
    Color \= visited,
    Color = Player,
    replaceValue(Board,NewBoard,CurrColumn,CurrRow,Player),
    write(NewBoard), write('\n'),
    NewValue is Value + 1,
    
    /*right movement*/
    NewColumn is CurrColumn + 1,
    getValue(NewBoard, Player, ReturnValue,NewValue, NewColumn, CurrRow),

    ReturnValue is NewValue.


getValue(Board,Player,ReturnValue,Value,CurrColumn,CurrRow):-


    length(Board, Size),
    write(CurrColumn-CurrRow-Size), write('\n'),
    write('Col>\n'),
    (CurrColumn<0,trace;true),
    CurrColumn>=0,

    getCellColor(Board,CurrColumn,CurrRow,Color),
    Color \= visited,
    Color = Player,
    replaceValue(Board,NewBoard,CurrColumn,CurrRow,Player),
    write(NewBoard), write('\n'),
    NewValue is Value + 1,
 
    /*left movement*/
    NewColumn is CurrColumn - 1,
    getValue(NewBoard, Player, ReturnValue,NewValue, NewColumn, CurrRow),
  
    ReturnValue is NewValue.
    








searchForColor(Board,Color,CurrCol,CurrRow,Col,Row):-
    nth0(CurrRow,Board,RowList),
    \+searchForColorInRow(RowList,Color,CurrCol,CurrRow,Col,Row), !,
    NewRow is CurrRow+1,
    searchForColor(Board,Color,CurrCol,NewRow,Col,Row).

searchForColor(Board,Color,CurrCol,CurrRow,Col,Row):-
    Col is CurrCol,
    Row is CurrRow.

searchForColorInRow(RowList,Color,CurrCol,CurrRow,Col,Row):-
    nth0(CurrCol,RowList,Column),
    last(Column,CheckColor),
    Color==CheckColor.
    
replaceValue(OldBoard, NewBoard, Column, Row, Color) :-
    nth0(Row,OldBoard,RowList),
    nth0(Column,RowList,ColList),

    length(ColList, ColSize),
    IndexCol is ColSize - 1,
    NextPlayer = visited,
    
    replace_nth0(ColList, IndexCol, Color, NextPlayer,NewCol),
    replace_nth0(RowList,Column,ColList,NewCol,NewRow),
    replace_nth0(OldBoard,Row,RowList,NewRow,NewBoard).

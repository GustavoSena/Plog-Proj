play:-
    mainMenu(Size, Player1, LevelP1, Player2, LevelP2, Option),
    Option\=4,
    generateBoard(GameState,Size),
    
    gameLoop(GameState, Player1, Player2, LevelP1, LevelP2, 'n').




/*Makes the move in person mode, corresponding to the black piece*/
/*movePlayer1(+GameState, -NewBoard, +Player1, +Player2, +LevelP1, +LevelP2, -Skip)*/
movePlayer1(GameState, NewBoard, Player1, Player2, LevelP1, LevelP2, Skip) :-
    displayGame(GameState, Player1),
    getMove(black, GameState, CurrCol, CurrRow, NewCol, NewRow, Skip),
    
    (
        (Skip == 'n',
        move(GameState, CurrCol, CurrRow, NewBoard, NewCol, NewRow, Player1)
        )
    ;
        (Skip == 'y',
        write('You skip turn!\n'),
        NewBoard = GameState
        )
    ).


/*Makes the move in person mode, corresponding to the white piece*/
/*movePlayer2(+GameState, +Player1, +Player2, +LevelP1, +LevelP2, +LastSkip)*/
movePlayer2(GameState, Player1, Player2, LevelP1, LevelP2, LastSkip) :-

    ((Player1 == 'comp1', Player = 'black') ; (Player = Player1)),

    displayGame(GameState, Player2),
    getMove(Player2, GameState, CurrCol, CurrRow, NewCol, NewRow, Skip),
    (
        (Skip == 'n',
        move(GameState, CurrCol, CurrRow, NewBoard, NewCol, NewRow, Player2)
        )
    ;
        (Skip == 'y',
        write('You skip turn!\n'),
        NewBoard = GameState
        )
    ),

    ((Skip == 'y', LastSkip == 'y', game_over(NewBoard, Winner,black)) 
    ; 
    (gameLoop(NewBoard, Player1, Player2, LevelP1, LevelP2, Skip))).


/*Makes the move in computer mode, corresponding to the black piece*/
/*moveComp1(+GameState, -NewBoard, +Player1, +Player2, +LevelP1, +LevelP2, -Skip)*/
moveComp1(GameState, NewBoard, Player1, Player2, LevelP1, LevelP2, Skip) :-
    
    ((Player1 == 'comp1', Player = 'black') ; (Player = Player1)),

    displayGame(GameState, Player),
    choose_move(GameState, Player, LevelP2, CurrCol-CurrRow-NewCol-NewRow, Skip),

    (
        (Skip == 'n',
        move(GameState, CurrCol, CurrRow, NewBoard, NewCol, NewRow, Player)
        )
    ;
        (Skip == 'y',
        write('You skip turn!\n'),
        NewBoard = GameState
        )
    ).


/*Makes the move in computer mode, corresponding to the white piece*/
/*moveComp2(+GameState, +Player1, +Player2, +LevelP1, +LevelP2, +LastSkip)*/
moveComp2(GameState, Player1, Player2, LevelP1, LevelP2, LastSkip) :-

    ((Player2 == 'comp2', Player = 'white') ; (Player = Player2)),

    displayGame(GameState, Player),
    choose_move(GameState, Player, LevelP2, CurrCol-CurrRow-NewCol-NewRow, Skip),

    (
        (Skip == 'n',
        move(GameState, CurrCol, CurrRow, NewBoard, NewCol, NewRow, Player)
        )
    ;
        (Skip == 'y',
        write('You skip turn!\n'),
        NewBoard = GameState
        )
    ),

    ((Skip == 'y', LastSkip == 'y', game_over(NewBoard, Winner,black)) 
    ; 
    (gameLoop(NewBoard, Player1, Player2, LevelP1, LevelP2, Skip))).


/*Enters in a game cycle in Person-Person mode*/
/*gameLoop(+GameState, +black, +white, +LevelP1, +LevelP2, +LastSkip)*/
gameLoop(GameState, black, white, LevelP1, LevelP2, LastSkip) :-

    movePlayer1(GameState, NewBoard, black, white, LevelP1, LevelP2, Skip),
    ((Skip == 'y', LastSkip == 'y', game_over(NewBoard, Winner,white)) 
    ; 
    (movePlayer2(NewBoard, black, white, LevelP1, LevelP2, Skip))).
    

/*Enters in a game cycle in Person-Computer mode*/
/*gameLoop(+GameState, +black, +comp2, +LevelP1, +LevelP2, +LastSkip)*/
gameLoop(GameState, black, comp2, LevelP1, LevelP2, LastSkip) :-

    movePlayer1(GameState, NewBoard, black, comp2, LevelP1, LevelP2, Skip),
    ((Skip == 'y', LastSkip == 'y', game_over(NewBoard, Winner)) 
    ; 
    (moveComp2(NewBoard, black, comp2, LevelP1, LevelP2, Skip))).


/*Enters in a game cycle in Computer-Person mode*/
/*gameLoop(+GameState, +comp1, +white, +LevelP1, +LevelP2, +LastSkip)*/
gameLoop(GameState, comp1, white, LevelP1, LevelP2, LastSkip) :-

    moveComp1(GameState, NewBoard, comp1, white, LevelP1, LevelP2, Skip),
    write(Skip), write('\n'),
    ((Skip == 'y', LastSkip == 'y', game_over(NewBoard, Winner)) 
    ; 
    (movePlayer2(NewBoard, comp1, white, LevelP1, LevelP2, Skip))).


/*Enters in a game cycle in Computer-Computer mode*/
/*gameLoop(+GameState, +comp1, +comp2, +LevelP1, +LevelP2, +LastSkip)*/
gameLoop(GameState, comp1, comp2, LevelP1, LevelP2, LastSkip) :-
    sleep(1),
    moveComp1(GameState, NewBoard, comp1, comp2, LevelP1, LevelP2, Skip),
    ((Skip == 'y', LastSkip == 'y', game_over(NewBoard, Winner)) 
    ; 
    (sleep(1), moveComp2(NewBoard, comp1, comp2, LevelP1, LevelP2, Skip))).
    
    

/*Executes a move, obtaining a new board*/
/*move(+OldBoard, +OldColumn, +OldRow, -NewBoard, +NewColumn, +NewRow, +Player)*/
move(OldBoard, OldColumn, OldRow, NewBoard, NewColumn, NewRow, Player) :-
    insertStack(OldBoard, UpdBoard, NewColumn, NewRow, [Player]),
    removeStack(UpdBoard, NewBoard, OldColumn, OldRow, [Player]).


/*Inserts the new piece into the stack to play*/
/*insertStack(+OldBoard, -NewBoard, +Column, +Row, +Color)*/
insertStack(OldBoard, NewBoard, Column, Row, Color) :-
    nth0(Row,OldBoard,RowList),
    nth0(Column,RowList,ColList),
    append(ColList,Color,NewCol),
    replace_nth0(RowList,Column,ColList,NewCol,NewRow),
    replace_nth0(OldBoard,Row,RowList,NewRow,NewBoard).


/*Removes the current piece from the stack to play*/ 
/*removeStack(+OldBoard, -NewBoard, +Column, +Row, -Color)*/
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


/*Gets a random move as a computer move*/
/*choose_move(+GameState, +Player, +'rand', -CurrCol-CurrRow-NewCol-NewRow, -Skip)*/
choose_move(GameState, Player, 'rand', CurrCol-CurrRow-NewCol-NewRow, Skip) :-
    valid_moves(GameState, Player, ListOfMoves),
    length(ListOfMoves, S),
    Size is S - 1,
    Size > 0,
    Skip = 'n',

    random(0, Size, Random), 
    nth0(Random, ListOfMoves, Value-CurrCol-CurrRow-NewCol-NewRow). 


/*Gets a greedy move as a computer move*/
/*choose_move(+GameState, +Player, +'greedy', -CurrCol-CurrRow-NewCol-NewRow, -Skip)*/
choose_move(GameState, Player, 'greedy', CurrCol-CurrRow-NewCol-NewRow, Skip) :-
    valid_moves(GameState, Player, ListOfMoves),
    length(ListOfMoves, Size),
    Size > 0,
    Skip = 'n',

    nth0(0, ListOfMoves, Value-CurrCol-CurrRow-NewCol-NewRow). 


/*When there are no more valid moves*/
/*choose_move(+GameState, +Player, +Level, -CurrCol-CurrRow-NewCol-NewRow, -'y')*/
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


/*In case of game over, identifies the winner*/
/*game_over(+GameState, -Winner)*/
game_over(GameState, Winner,LastPlayed) :-

    value(GameState,black,BlackScore),
    value(GameState,white,WhiteScore),
    
    getWinner(WhiteScore, BlackScore, Winner,LastPlayed),

    printWinner(Winner).


/*Gives the value of the largest group for a given board and player*/
/*value(+GameState, +Player, -Value)*/
value(GameState, Player, Value) :-
    NewBoard = GameState,
    valueCicle(NewBoard,Player,Value, []).


/*Enters in a cycle to find the biggest value*/
/*valueCicle(+Board, +Player, -Value, +OldValue)*/
valueCicle(Board, Player, Value, OldValue):-
    
    searchForColor(Board,Player,0,0,Col,Row),!,
    
    getValue(UpdatedBoard,Board,Player,NewValue,0,Col,Row),

    append(OldValue, [NewValue], BiggestValue),
    
    
    /*getBiggestValue(NewValue,OldValue,BiggestValue),*/

    valueCicle(UpdatedBoard,Player,Value,BiggestValue).


/*In case there are no more cells to visit, the cycle ends*/
/*valueCicle(+Board, +Player, -Value, +OldValue)*/
valueCicle(Board, Player, OldValue, OldValue).


/*Gets the length of the group by giving a starting cell for that group*/
/*getValue(-UpdatedBoard3, +Board, +Player, -ReturnValue3, +Value, +CurrColumn, +CurrRow)*/
getValue(UpdatedBoard3, Board, Player, ReturnValue3, Value, CurrColumn, CurrRow) :-
    length(Board, Size),
    
    (CurrRow >= 0,
    CurrRow < Size,
    CurrColumn < Size,
    CurrColumn >= 0),
 
    getCellColor(Board, CurrColumn, CurrRow, Color),
    
    Color \= visited,
    Color = Player,
    
    replaceValue(Board,NewBoard,CurrColumn,CurrRow,Player),
    
    NewValue is Value + 1,

    /*down movement*/
    RowDown is CurrRow + 1,
    getValue(UpdatedBoard, NewBoard, Player, ReturnValue, NewValue, CurrColumn, RowDown),
    NextValue is ReturnValue,
    NewBoard1 = UpdatedBoard,

    /*right movement*/
    ColRight is CurrColumn + 1,
    getValue(UpdatedBoard1,NewBoard1, Player, ReturnValue1, NextValue, ColRight, CurrRow),
    NextValue2 is ReturnValue1,
    NewBoard2 = UpdatedBoard1,

    /*up movement*/
    RowUp is CurrRow - 1,
    getValue(UpdatedBoard2,NewBoard2, Player, ReturnValue2, NextValue2, CurrColumn, RowUp),
    NextValue3 is ReturnValue2,
    NewBoard3 = UpdatedBoard2,

    /*left movement*/
    ColLeft is CurrColumn - 1,
    getValue(UpdatedBoard3,NewBoard3, Player, ReturnValue3, NextValue3, ColLeft, CurrRow).


/*In case the given cell to explore is out the board limits or belongs to the other player*/
/*getValue(-Board, +Board, +Player, -Value, +Value, +CurrColumn, +CurrRow)*/
getValue(Board, Board, Player, Value, Value, CurrColumn, CurrRow).


/*Given a position, starts looking for the next cell that belongs to the color of the player*/
/*searchForColor(+Board, +Color, +CurrCol, +CurrRow, -Col, -Row)*/
searchForColor(Board, Color, CurrCol, CurrRow, Col, Row) :-
    nth0(CurrRow, Board, RowList),
    searchForColorInRow(RowList, Color, CurrCol, CurrRow, Col, Row).


/*In case the cell has not in the current row, switch to the next row*/
/*searchForColor(+Board, +Color, +CurrCol, +CurrRow, -Col, -Row)*/
searchForColor(Board, Color, CurrCol, CurrRow, Col, Row) :-
    length(Board, Size),
    NewRow is CurrRow + 1,
    NewRow < Size, !,
    searchForColor(Board, Color, CurrCol, NewRow, Col, Row).


/*Given a position, starts looking for the cell in the current row*/
/*searchForColorInRow(+RowList, +Color, +CurrCol, +CurrRow, -Col, -Row)*/
searchForColorInRow(RowList, Color, CurrCol, CurrRow, Col, Row) :-
    nth0(CurrCol, RowList, Column),
    searchForColorInCol(RowList, Color, Column, CurrCol, CurrRow, Col, Row).


/*In case a cell is found*/
/*searchForColorInCol(+RowList, +Color, +Column, +CurrCol, +CurrRow, -Col, -Row)*/
searchForColorInCol(RowList, Color, Column, CurrCol, CurrRow, Col, Row) :-
    last(Column, CheckColor),
    Color == CheckColor,
    Col is CurrCol,
    Row is CurrRow.


/*In case the cell has not in the current column, switch to the next column*/
/*searchForColorInCol(+RowList, +Color, +Column, +CurrCol, +CurrRow, -Col, -Row)*/
searchForColorInCol(RowList, Color, Column, CurrCol, CurrRow, Col, Row):-
    length(RowList, Size),
    NewCol is CurrCol + 1,
    NewCol < Size, !,
    searchForColorInRow(RowList, Color, NewCol, CurrRow, Col, Row).
play:-
    mainMenu(Size, Player1, LevelP1, Player2, LevelP2, Option),
    Option\=4,
    generateBoard(GameState,Size),
    
    gameLoop(GameState, Player1, Player2, LevelP1, LevelP2, 'n').


/*Gets the movement that the user intends to make*/
/*getMove(+Player, +Board, -CurrColumn, -CurrRow, -NewColumn, -NewRow, -Answer)*/
getMove(Player, Board, CurrColumn, CurrRow, NewColumn, NewRow, Answer) :-
    skip(Answer),
    ((Answer == 'n',
    getCurrPiece(Player, Board, CurrColumn, CurrRow),
    getNewPiece(Player,Board, CurrColumn, CurrRow, NewColumn, NewRow))
    ; 
    (Answer == 'y')).


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

    ((Skip == 'y', LastSkip == 'y', game_over(NewBoard, Winner, Player1)) 
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

    ((Skip == 'y', LastSkip == 'y', game_over(NewBoard, Winner, Player1)) 
    ; 
    (gameLoop(NewBoard, Player1, Player2, LevelP1, LevelP2, Skip))).


/*Enters in a game cycle in Person-Person mode*/
/*gameLoop(+GameState, +Player1, +Player2, +LevelP1, +LevelP2, +LastSkip)*/
gameLoop(GameState, black, white, LevelP1, LevelP2, LastSkip) :-

    movePlayer1(GameState, NewBoard, black, white, LevelP1, LevelP2, Skip),
    ((Skip == 'y', LastSkip == 'y', game_over(NewBoard, Winner, white)) 
    ; 
    (movePlayer2(NewBoard, black, white, LevelP1, LevelP2, Skip))).
    

/*Enters in a game cycle in Person-Computer mode*/
/*gameLoop(+GameState, +Player1, +Player2, +LevelP1, +LevelP2, +LastSkip)*/
gameLoop(GameState, black, comp2, LevelP1, LevelP2, LastSkip) :-

    movePlayer1(GameState, NewBoard, black, comp2, LevelP1, LevelP2, Skip),
    ((Skip == 'y', LastSkip == 'y', game_over(NewBoard, Winner, white)) 
    ; 
    (moveComp2(NewBoard, black, comp2, LevelP1, LevelP2, Skip))).


/*Enters in a game cycle in Computer-Person mode*/
/*gameLoop(+GameState, +Player1, +Player2, +LevelP1, +LevelP2, +LastSkip)*/
gameLoop(GameState, comp1, white, LevelP1, LevelP2, LastSkip) :-

    moveComp1(GameState, NewBoard, comp1, white, LevelP1, LevelP2, Skip),
    write(Skip), write('\n'),
    ((Skip == 'y', LastSkip == 'y', game_over(NewBoard, Winner, white)) 
    ; 
    (movePlayer2(NewBoard, comp1, white, LevelP1, LevelP2, Skip))).


/*Enters in a game cycle in Computer-Computer mode*/
/*gameLoop(+GameState, +Player1, +Player2, +LevelP1, +LevelP2, +LastSkip)*/
gameLoop(GameState, comp1, comp2, LevelP1, LevelP2, LastSkip) :-
    sleep(1),
    moveComp1(GameState, NewBoard, comp1, comp2, LevelP1, LevelP2, Skip),
    ((Skip == 'y', LastSkip == 'y', game_over(NewBoard, Winner, white)) 
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


/*In case of game over, identifies the winner*/
/*game_over(+GameState, -Winner, +LastPlayed)*/
game_over(GameState, Winner, LastPlayed) :-

    value(GameState,black,BlackScore),
    value(GameState,white,WhiteScore),
    
    getWinner(WhiteScore, BlackScore, Winner, LastPlayed),

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
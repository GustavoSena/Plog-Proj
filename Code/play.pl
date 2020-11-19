play:-
    Size is 3,
    generateBoard(Board,Size),
    displayGame(Board,Size,black).

displayGame(Board,Size,Player):-
    displayBoard(Board,Size,Player),
    getMove(Player, Board, CurrColumn, CurrRow, NewColumn, NewRow, Skip),
    ((Skip == 'n',
    move(Board, CurrColumn, CurrRow, NewBoard, NewColumn, NewRow),
    displayBoard(NewBoard,Size,Player))
    ;
    (Skip == 'y',
    write('You skip turn!\n'),
    displayBoard(Board,Size,Player))).

/*gameLoop(Board, Player) :-
    getCoord(Player, Column, Rown).*/
    

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






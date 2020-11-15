play:-
    Size is 3,
    generateBoard(Board,Size),
    displayGame(Board,Size,black).

displayGame(Board,Size,Player):-
    displayBoard(Board,Size,Player),
    move(Player, Board, CurrColumn, CurrRow, NewColumn, NewRow),
    insertInBoard(Board,NewBoard,NewColumn,NewRow,[black]),
    displayBoard(NewBoard,Size,Player).

/*gameLoop(Board, Player) :-
    getCoord(Player, Column, Rown).*/
    





insertInBoard(OldBoard,NewBoard,Column,Row,Color):-
    nth0(Row,OldBoard,RowList),
    nth0(Column,RowList,ColList),
    append(ColList,Color,NewCol),
    replace_nth0(RowList,Column,ColList,NewCol,NewRow),
    replace_nth0(OldBoard,Row,RowList,NewRow,NewBoard).









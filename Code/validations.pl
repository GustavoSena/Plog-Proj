/*If the answer from the user is valid*/
/*validateSize(+Size)*/
validateSize(Size) :-
    write(Size),write('-Size\n'),
    (Size > 2, Size < 10)
    ;
    (write('Invalid Size!\n'), fail).


/*If the answer from the user is valid*/
/*validateConfirmation(+Conf, -Size, +NSize)*/
validateConfirmation(Conf, Size, NSize) :-
    Conf=='y',!,
    Size is NSize.


/*If the answer from the user is not valid*/
/*validateConfirmation(+Conf, -Size, +NSize)*/
validateConfirmation(Conf, Size, NSize) :-
    decideSizeBoard(Size).


/*Check if the answer from the user is valid or not*/
/*validatePlayerColor(Color)*/
validatePlayerColor(Color) :-
    (Color > 0, Color < 3)
    ;
    (write('Invalid Color!\n'), fail).


/*Checks if the answer from the user is valid or not*/
/*validateDifficulty(Dif)*/
validateDifficulty(Dif) :-
    (Dif > 0, Dif < 3)
    ;
    (write('Invalid Difficulty!\n'), fail).


/*If the answer from the user is valid*/
/*validateOption(+Option)*/
validateOption(Option):-
    (Option > 0, Option < 5)
    ;
    (write('Invalid option!\n'), fail).


/*Checks if the piece belongs to the player*/
/*checkCurrCoord(+Player, +Board, +CurrColumn, +CurrRow)*/
checkCurrCoord(Player, Board, CurrColumn, CurrRow) :-
    nth0(CurrRow,Board,RowList),
    nth0(CurrColumn,RowList,ColList),
    last(ColList,Color),
    Color = Player.


/*In case the piece doesn't belong to the player*/
/*checkCurrCoord(+Player, +Board, +CurrColumn, +CurrRow)*/
checkCurrCoord(Player, Board, CurrColumn, CurrRow) :-
    write('Not your piece to move.\n'), fail.


/*Checks the new position*/ 
/*checkNewCoord(+Player, +Board, +CurrColumn, +CurrRow, +NewColumn, +NewRow)*/
checkNewCoord(Player, Board, CurrColumn, CurrRow, NewColumn, NewRow) :-

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
    CurrSize = NewSize,

    /*Checks if the position is adjacent*/
    (
        /*Adjacent column*/
        (abs(CurrColumn-NewColumn)=:=0, abs(CurrRow-NewRow)=:=1)
        ; 
        /*Adjacent row*/
        (abs(CurrColumn-NewColumn)=:=1, abs(CurrRow-NewRow)=:=0)
    ).


/*In case the new position is not valid*/ 
/*checkNewCoord(+Player, +Board, +CurrColumn, +CurrRow, +NewColumn, +NewRow)*/
checkNewCoord(Player, Board, CurrColumn, CurrRow, NewColumn, NewRow) :-
    write('Position not valid.\n'), fail.


/*If the Column is valid*/
/*validateColumn(+Column, -_Column, +Size)*/
validateColumn(Column, _Column, Size) :-
    subsCol(Column,_Column),
    _Column < Size, !.
    
    
/*If the Column is not valid*/
/*validateColumn(+Column, -_Column, +Size)*/
validateColumn(Column, _Column, Size) :-
    write('Invalid column!\n'),
    forColumn(_Column, Size).


/*If the Row is valid*/
/*validateRow(+Row, -_Row, +Size)*/
validateRow(Row, _Row, Size) :-
    subsRow(Row,_Row),
    _Row < Size, !.


/*If the Row is not valid*/
/*validateRow(+Row, -_Row, +Size)*/
validateRow(Row, _Row, Size) :-
    write('Invalid row!\n'),
    forRow(_Row, Size).


/*If the answer from the user is valid*/
/*validateAnswer(+Answer)*/
validateAnswer(Answer) :- 
    /*Valid case*/
    (Answer == 'y'; Answer == 'n').


/*If the answer from the user is not valid*/
/*validateAnswer(+Answer)*/
validateAnswer(Answer) :- 
    /*Invalid case*/
    (write('Invalid answer!\n'), fail).
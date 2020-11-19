
getMove(Player, Board, CurrColumn, CurrRow, NewColumn, NewRow, Answer) :-
    write('Player: '),
    subsPlayer(Player,S),
    write(S),
    write('s turn!\n'),
    skip(Answer),
    ((Answer == 'n',
    getCurrPiece(Player, Board, CurrColumn, CurrRow),
    getNewPiece(Player,Board, CurrColumn, CurrRow, NewColumn, NewRow))
    ; 
    (Answer == 'y')).

/*Check if the user wants to play*/
skip(Answer) :-  
    repeat,
    readAnswer(Answer),
    validateAnswer(Answer).

/*Gets the position of the current piece*/
getCurrPiece(Player, Board, CurrColumn, CurrRow) :-
    repeat,
    write('Choose a piece to move\n'),
    length(Board,Size),
    getCoord(CurrColumn, CurrRow, Size),
    checkCurrCoord(Player, Board, CurrColumn, CurrRow), !.
    
/*Gets the new position of the piece*/
getNewPiece(Player, Board, CurrColumn, CurrRow, NewColumn, NewRow):-
    repeat,
    write('Choose new position\n'),
    length(Board,Size),
    getCoord(NewColumn, NewRow, Size),
    checkNewCoord(Player,Board,CurrColumn, CurrRow, NewColumn, NewRow).

/*Check if the piece belongs to the player*/
checkCurrCoord(Player,Board, CurrColumn, CurrRow) :-
    nth0(CurrRow,Board,RowList),
    nth0(CurrColumn,RowList,ColList),
    last(ColList,Color),
    write(Color),
    write('\n'),
    write(Player),
    write('\n'),
    Color = Player.

checkCurrCoord(Player,Board, CurrColumn, CurrRow) :-
    write('Not your piece to move.\n'), fail.

/*Checks the new position*/ 
checkNewCoord(Player,Board,CurrColumn, CurrRow, NewColumn, NewRow):-
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
        (CurrColumn =:= NewColumn , CurrRow+1=:=NewRow) ;  
        (CurrColumn =:= NewColumn , CurrRow-1=:=NewRow) ; 
        (CurrColumn+1 =:= NewColumn , CurrRow=:=NewRow) ; 
        (CurrColumn-1 =:= NewColumn , CurrRow=:=NewRow)
    ).
    
    
checkNewCoord(Player,Board,CurrColumn, CurrRow, NewColumn, NewRow) :-
    write('Position not valid.\n'), fail.
    
/*Gets a position*/
getCoord(Column, Row, Size) :-
    readColumn(Column),
    validateColumn(Column, Size),

    readRow(NRow),
    Row is NRow-1,
    validateRow(Row, Size).

/*Reads the input column*/
readColumn(Col) :-
    write('Choose the column:\n'),
    get_char(Column),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char),
    subsCol(Column,Col).

readColumn(Col) :-
    readColumn(Col).

/*Reads input from the user*/
readAnswer(Answer) :-
    write('Do you want to skip turn? y or n.\n'),
    get_char(Answer),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char).
    
readAnswer(Answer) :-
    readAnswer(Answer).

/*Reads the input row*/
readRow(Row) :-
    write('Choose the row:\n'),
    get_code(RowC),
    subsRow(RowC,Row),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char).
    
readRow(Row) :-
    readRow(Row).

/*If the Column is valid*/
validateColumn(Column, Size) :-
    Column < Size, !.
    
/*If the Column is not valid*/
validateColumn(Column, Size) :-
    write('Invalid column!\n'),
    readColumn(NewColumn),
    validateColumn(NewColumn, Size).


/*If the Row is valid*/
validateRow(Row, Size) :-
    Row < Size, !.
/*If the Row is not valid*/
validateRow(Row, Size) :-
    write('Invalid row!\n'),
    readRow(NRow),
    Row is NRow-1,
    validateRow(Row, Size).

/*If the answer from the user is valid*/
validateAnswer(Answer) :- 
    /*Valid case*/
    (Answer == 'y'; Answer == 'n')
    ;
    /*Invalid case*/
    (write('Invalid answer!\n'), fail).
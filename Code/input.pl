



mainMenu(Size,Player1,LevelP1,Player2,LevelP2,Option):-
    decideSizeBoard(Size),
    decidePlayers(Player1,LevelP1,Player2,LevelP2,Option).


decideSizeBoard(Size):-
    repeat,
    readSize(NSize),
    validateSize(NSize),
    generateBoard(Example,NSize),
    displayGame(Example,white),
    readConfirmation(Conf,NSize),
    validateConfirmation(Conf,Size,NSize).

    
    

readConfirmation(Conf,Size):-
    write('Confirm board size - '),write(Size),write(' (type y to confirm)\n'),
    get_char(Conf),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char).
    
readConfirmation(Conf,Size) :-
    readConfirmation(Conf,Size).

validateConfirmation(Conf,Size,NSize):-
    Conf=='y',!,
    Size is NSize.


validateConfirmation(Conf,Size,NSize):-
    decideSizeBoard(Size).



readSize(Size):-
    write('Choose the size of the board (3 to 9)\n'),
    get_code(NSize),
    subsRow(NSize,Size),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char).
    
readSize(Size) :-
    readSize(Size).

validateSize(Size):-
    write(Size),write('-Size\n'),
    (Size>2,Size<10);(write('Invalid Size!\n'),fail).



decidePlayers(Player1,LevelP1,Player2,LevelP2,Option):-
    repeat,
    readOption(Option),
    validateOption(Option),
    getPlayers(Player1,LevelP1,Player2,LevelP2,Option).

getPlayers(Player1,LevelP1,Player2,LevelP2,Option):-
    Option==1,!,
    Player1=black,
    Player2=white.

getPlayers(Player1,LevelP1,Player2,LevelP2,Option):-
    Option==2,!,
    getPlayerColor(Player1,LevelP1,Player2,LevelP2).

getPlayers(Player1,LevelP1,Player2,LevelP2,Option):-
    Option==3,!,
    Player1=comp1,
    Player2=comp2,
    getCompDifficulty(comp1,LevelP1),
    getCompDifficulty(comp2,LevelP2).

getPlayers(Player1,Player2,Option):-
    Option==4.

getPlayerColor(Player1,LevelP1,Player2,LevelP2):-
    repeat,
    readPlayerColor(Color),
    validatePlayerColor(Color),
    setPlayerColor(Player1,LevelP1,Player2,LevelP2,Color).


readPlayerColor(Color):-
    printColor(Nothing),
    write('Choose the your Color (1 or 2)\n'),
    get_code(NColor),
    subsRow(NColor,Color),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char).
    
readPlayerColor(Color):-
    readPlayerColor(Color).

validatePlayerColor(Color):-
    (Color>0,Color<3);(write('Invalid Color!\n'),fail).

setPlayerColor(Player1,LevelP1,Player2,LevelP2,Color):-
    (Color==1),!,
    Player1=comp1,
    Player2=white,
    getCompDifficulty(comp1,LevelP1).

setPlayerColor(Player1,LevelP1,Player2,LevelP2,Color):-
    Player1=Black,
    Player2=comp2,
    getCompDifficulty(comp2,LevelP2).

getCompDifficulty(Comp,Level):-
    repeat,
    readDifficulty(Dif,Comp),
    validateDifficulty(Dif),
    subsDif(Dif,Level). 

readDifficulty(Dif,Comp):-
    printDifficulty(Nothing),
    write('Choose the difficulty for '),write(Comp),write(' (1 or 2)\n'),
    get_code(NDif),
    subsRow(NDif,Dif),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char).
    
readDifficulty(Dif,Comp):-
    readDifficulty(Dif,Comp).

validateDifficulty(Dif):-
    (Dif>0,Dif<3);(write('Invalid Difficulty!\n'),fail).





readOption(Option):-
    printMainMenu(Nothing),
    write('Choose the Playing option (1 to 3)\n'),
    get_code(NOption),
    subsRow(NOption,Option),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char).
    
readOption(Option):-
    readOption(Option).

validateOption(Option):-
    (Option>0,
    Option<5);(write('Invalid option!\n'),fail).
                                                
                                                    

getMove(Player, Board, CurrColumn, CurrRow, NewColumn, NewRow, Answer) :-
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
    write(Color-Player),write('\n'),

    /*Checks if the two stacks are the same size*/
    nth0(CurrRow,Board,OldRow),
    nth0(CurrColumn,OldRow,OldCol),
    length(ColList,NewSize),
    length(OldCol,CurrSize),
    CurrSize = NewSize,

    /*Checks if the position is adjacent*/
    (
        (abs(CurrColumn-NewColumn)=:=0, abs(CurrRow-NewRow)=:=1)
        ; 
        (abs(CurrColumn-NewColumn)=:=1, abs(CurrRow-NewRow)=:=0)
    )

    ;

    (write('Position not valid.\n'), fail).
    
/*Gets a position*/
getCoord(Column, Row, Size) :-
    forColumn(Column, Size),
    forRow(Row, Size).

/*Get a coord for Column*/
forColumn(Column, Size) :-
    readColumn(Col),
    validateColumn(Col, Column, Size).

/*Get a coord for Row*/
forRow(_Row, Size) :-
    readRow(NRow),
    Row is NRow-1,
    validateRow(Row, _Row, Size).

/*Reads the input column*/
readColumn(Col) :-
    write('Choose the column:\n'),
    get_char(Col),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char).

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
    get_code(Row),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char).
    
readRow(Row) :-
    readRow(Row).

/*If the Column is valid*/
validateColumn(Column, _Column, Size) :-
    subsCol(Column,_Column),
    _Column < Size, !.
    
/*If the Column is not valid*/
validateColumn(Column, _Column, Size) :-
    write('Invalid column!\n'),
    forColumn(_Column, Size).


/*If the Row is valid*/
validateRow(Row, _Row, Size) :-
    subsRow(Row,_Row),
    _Row < Size, !.
/*If the Row is not valid*/
validateRow(Row, _Row, Size) :-
    write('Invalid row!\n'),
    forRow(_Row, Size).

/*If the answer from the user is valid*/
validateAnswer(Answer) :- 
    /*Valid case*/
    (Answer == 'y'; Answer == 'n')
    ;
    /*Invalid case*/
    (write('Invalid answer!\n'), fail).
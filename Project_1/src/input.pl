/*Reads the input from the user to know the size of the board he wants*/
/*readSize(-Size)*/
readSize(Size) :-
    write('Choose the size of the board (3 to 9)\n'),
    get_code(NSize),
    subsRow(NSize,Size),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char).


/*In case the input is not valid*/ 
/*readSize(-Size)*/
readSize(Size) :-
    readSize(Size).


/*Reads the input from the user to know the size of the board he wants*/
/*readConfirmation(-Conf, +Size)*/
readConfirmation(Conf, Size) :-
    write('Confirm board size - '),write(Size),write(' (type y to confirm)\n'),
    get_char(Conf),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char).


/*In case the input is not valid*/   
/*readConfirmation(-Conf, +Size)*/ 
readConfirmation(Conf, Size) :-
    readConfirmation(Conf,Size).


/*Reads the input from the user to know what color are their pieces*/
/*readPlayerColor(-Color)*/
readPlayerColor(Color) :-
    printColor,
    write('Choose the your Color (1 or 2)\n'),
    get_code(NColor),
    subsRow(NColor,Color),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char).


/*In case the input is not valid*/
/*readPlayerColor(Color)*/
readPlayerColor(Color) :-
    readPlayerColor(Color).


/*Reads the input from the user to know the difficulty of the game*/
/*readDifficulty(-Dif, +Comp)*/
readDifficulty(Dif, Comp) :-
    printDifficulty,
    write('Choose the difficulty for '), write(Comp), write(' (1 or 2)\n'),
    get_code(NDif),
    subsRow(NDif,Dif),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char).


/*In case the input is not valid*/
/*readDifficulty(-Dif, +Comp)*/
readDifficulty(Dif, Comp) :-
    readDifficulty(Dif, Comp).


/*Reads the input from the user to know which game mode he wants to play*/
/*readOption(-Option)*/
readOption(Option):-
    printMainMenu,
    write('Choose the Game Mode option (1 to 3)\n'),
    get_code(NOption),
    subsRow(NOption,Option),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char).


/*In case the input is not valid*/
/*readOption(-Option)*/
readOption(Option):-
    readOption(Option).


/*Check if the user wants to play*/
/*skip(-Answer)*/
skip(Answer) :-  
    repeat,
    readAnswer(Answer),
    validateAnswer(Answer).

    
/*Gets the position of the current piece*/
/*getCurrPiece(+Player, +Board, +CurrColumn, +CurrRow)*/
getCurrPiece(Player, Board, CurrColumn, CurrRow) :-
    repeat,
    write('Choose a piece to move\n'),
    length(Board,Size),
    getCoord(CurrColumn, CurrRow, Size),
    checkCurrCoord(Player, Board, CurrColumn, CurrRow), !.
    

/*Gets the new position of the piece*/
/*getNewPiece(+Player, +Board, +CurrColumn, +CurrRow, -NewColumn, -NewRow)*/
getNewPiece(Player, Board, CurrColumn, CurrRow, NewColumn, NewRow):-
    repeat,
    write('Choose new position\n'),
    length(Board,Size),
    getCoord(NewColumn, NewRow, Size),
    checkNewCoord(Player,Board,CurrColumn, CurrRow, NewColumn, NewRow).

    
/*Gets a position*/
/*getCoord(-Column, -Row, +Size)*/
getCoord(Column, Row, Size) :-
    forColumn(Column, Size),
    forRow(Row, Size).


/*Get a coord for Column*/
/*forColumn(-Column, +Size)*/
forColumn(Column, Size) :-
    readColumn(Col),
    validateColumn(Col, Column, Size).


/*Get a coord for Row*/
/*forRow(-Row, +Size)*/
forRow(Row, Size) :-
    readRow(NRow),
    _Row is NRow-1,
    validateRow(_Row, Row, Size).


/*Reads the input column*/
/*readColumn(-Col)*/
readColumn(Col) :-
    write('Choose the column:\n'),
    get_char(Col),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char).


/*In case the input is not valid*/
/*readColumn(-Col)*/
readColumn(Col) :-
    readColumn(Col).


/*Reads input from the user to know if he wants to skip turn*/
/*readAnswer(-Answer)*/
readAnswer(Answer) :-
    write('Do you want to skip turn? y or n.\n'),
    get_char(Answer),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char).


/*In case the input is not valid*/
/*readAnswer(-Answer)*/
readAnswer(Answer) :-
    readAnswer(Answer).


/*Reads the input row*/
/*readRow(-Row)*/
readRow(Row) :-
    write('Choose the row:\n'),
    get_code(Row),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char).


/*In case the input is not valid*/
/*readRow(-Row)*/
readRow(Row) :-
    readRow(Row).
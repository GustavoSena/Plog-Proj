/*----------------------------------------MENU---------------------------------------*/
/*Gets the chosen Board to start the game*/
/*mainMenu(-Puzzle, -Size)*/
mainMenu(Puzzle, Size) :-
    decideBoard(Board, Size, Option),
    getPuzzle(Option, Size, Puzzle).


/*---------------------------------------BOARD---------------------------------------*/
/*It's made a decision by the player on which board to play*/
/*decideBoard(-Puzzle, -Size, -Option)*/
decideBoard(Puzzle, Size, Option) :-
    readOption(Op),
    validateOption(Op, Option).


/*Reads the input from the user to know which board size he wants to play*/
/*readOption(-Option)*/
readOption(Option):-
    printMenu,
    write('Choose the Board option (1 or 2)\n'),
    get_code(Option),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char).

/*In case the input is not valid*/
/*readOption(-Option)*/
readOption(Option):-
    readOption(Option).


/*If the player option is valid*/
/*validateOption(+Op, -Option)*/
validateOption(Op, Option):-
    subsCode(Op, Option),
    Option >= 1, Option =< 2, !.
    
/*If the player option is not valid*/
/*validateRow(+Op, -Option)*/
validateOption(Op, Option) :-
    write('Invalid option!\n'),
    decideBoard(Puzzle, Size, Option).


/*------------------------------------COORDENATES------------------------------------*/
/*Gets a coordinate to play*/
/*getCoord(-Column, -Row, +Size)*/
getCoord(Puzzle, Column, Row, Size) :-
    forColumn(_Column, Size),
    forRow(_Row, Size),
    validadeCoord(Puzzle, _Column, _Row, Column, Row, Size).


/*Checks if the coordinates given by the user are not selecting an cell that is a track or that already was discovered*/
/*If the Coordenate is valid*/
/*validadeCoord(+Puzzle, +_Column, +_Row, -_Column, -_Row, +Size)*/
validadeCoord(Puzzle, _Column, _Row, _Column, _Row, Size) :-
    getElement(Puzzle, _Row, _Column, SelectedElement),
    SelectedElement = e.

/*If the Coordenate is not valid*/
/*validadeCoord(+Puzzle, +_Column, +_Row, -_Column, -_Row, +Size)*/
validadeCoord(Puzzle, _Column, _Row, Column, Row, Size) :-
    write('Ups, that cell is already sealed... Try Again!\n'),
    getCoord(Puzzle, Column, Row, Size).


/*----------------------------COLUMN---------------------------*/
/*Get a coord for Column*/
/*forColumn(-Column, +Size)*/
forColumn(Column, Size) :-
    readColumn(Col),
    validateColumn(Col, Column, Size).


/*Reads the input column*/
/*readColumn(-Col)*/
readColumn(Col) :-
    write('Choose the column:\n'),
    get_code(Col),
    peek_char(Char),
    Char=='\n', !,
    get_char(Char).

/*In case the input is not valid*/
/*readColumn(-Col)*/
readColumn(Col) :-
    readColumn(Col).


/*If the Column is valid*/
/*validateColumn(+Column, -_Column, +Size)*/
validateColumn(Column, _Column, Size) :-
    subsCode(Column,_Column),
    _Column =< Size, _Column >= 1, !.
    
/*If the Column is not valid*/
/*validateColumn(+Column, -_Column, +Size)*/
validateColumn(Column, _Column, Size) :-
    write('Invalid column!\n'),
    forColumn(_Column, Size).


/*-----------------------------ROW-----------------------------*/
/*Get a coord for Row*/
/*forRow(-Row, +Size)*/
forRow(Row, Size) :-
    readRow(_Row),
    validateRow(_Row, Row, Size).


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


/*If the Row is valid*/
/*validateRow(+Row, -_Row, +Size)*/
validateRow(Row, _Row, Size) :-
    subsCode(Row,_Row),
    _Row =< Size, _Row >= 1, !.

/*If the Row is not valid*/
/*validateRow(+Row, -_Row, +Size)*/
validateRow(Row, _Row, Size) :-
    write('Invalid row!\n'),
    forRow(_Row, Size).
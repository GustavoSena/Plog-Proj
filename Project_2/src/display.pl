/*Displays the given GameState*/
/*displayBoard(+Board)*/
displayBoard(Board):-
    
    length(Board,Size),
    printHead(Size),
    printBar(Size+1),
    printBoard(Size,0,Board).


/*Prints the Board */
/*printBoard(+Size, +CurrentLine, +ListOfRows)*/
printBoard(Size,N,[X|L]):-
    M is N+1,
    write(' '),
    write(M),
    write(' |'),
    printLine(X),
    write('\n'),
    printBar(Size+1),
    printBoard(Size,M,L).  


/*When it reaches the end of the list of rows*/
/*printBoard(+Size, +M, +[])*/
printBoard(Size,M,[]).


/*Prints the Rows */
/*printLine(+ListOfColumns)*/
printLine([X|L]) :-
    printCell(X),
    write('|'),
    printLine(L).

/*When it reaches the end of the list of columns*/
/*printLine(+[])*/
printLine([]).


/*Prints each cell, which represents a stack of pieces*/
/*printCell(+Cell)*/
printCell(Cell):-
    symbol(Cell,S),
    write(' '),
    write(S),
    write(' ').


/*When it reaches the end of the row*/
/*printBar(+Size)*/
printBar(0):-
    write('\n').


/*Prints a part of the separation between each line*/
/*printBar(+Size)*/
printBar(Size):-
    write('---|'),
    NewSize is Size-1,
    printBar(NewSize).


/*Prints the beginning part of the board header*/
/*printHead(+Size)*/
printHead(Size):-
    write('   |'),
    printHead(Size, 0).


/*When it reaches the end of the row*/
/*printHead(+Size, +Size)*/
printHead(Size, Size):-
    write('\n').


/*Prints a part of the board header*/
/*printHead(+Size, +Index)*/
printHead(Size, Index):-
    write(' '),
    NewIndex is Index+1,
    write(NewIndex),
    write(' |'),
    printHead(Size, NewIndex).

printMenu :-
  write('========================================\n'),
  write('==           Dominosweeper            ==\n'),
  write('========================================\n'),
  write('==                                    ==\n'),
  write('==          1 - 3x3                   ==\n'),
  write('==          2 - 6x6                   ==\n'),
  write('==          3 - Exit                  ==\n'),
  write('==                                    ==\n'),
  write('========================================\n').
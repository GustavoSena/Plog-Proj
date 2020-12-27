/*Generates a Board given a size*/
/*generateBoard(-Board,+Size)*/
generateBoard(Board,Size) :-
    RowN is Size,
    generateBoard([],Board,RowN,Size).


/*When all the rows on the board have already been created*/
/*generateBoard(+FinalBoard,-FinalBoard,+RowN,+Size).*/
generateBoard(FinalBoard,FinalBoard,0,Size).


/*Generates the board rows*/
/*generateBoard(+InitBoard,-FinalBoard,+RowN,+Size)*/
generateBoard(InitBoard,FinalBoard,RowN,Size):-
    generateRow([],Row,RowN,Size),
    append(InitBoard,[Row],NewBoard),
    NewRowN is RowN - 1,
    generateBoard(NewBoard,FinalBoard,NewRowN,Size).


/*When all the lines on the board have already been created*/
/*generateRow(+FinalRow,-FinalRow,+RowN,+Size)*/
generateRow(InitRow,FinalRow,0,Size).


/*When all the columns in the row have already been created*/
/*generateRow(+FinalRow,-FinalRow,+RowN,+Size)*/
generateRow(FinalRow,FinalRow,Rown,0).


/*Generates a row in the RowN position with Size columns*/
/*generateRow(+InitRow,-FinalRow,+RowN,+Size)*/
generateRow(InitRow,FinalRow,RowN,Size):-
    generateCell(Cell,RowN, Size),
    append(InitRow,Cell,UpdatedRow),
    NewSize is Size-1,
    generateRow(UpdatedRow,FinalRow,RowN,NewSize).


/*Checks if the given position belongs to the black cell and generates there a black cell*/
/*generateCell(+Cell,-RowN,-ColN)*/ 
generateCell(Cell,RowN,ColN) :-
    (((RowN mod 2) =:= 0, (ColN mod 2) =\= 0) ; ((RowN mod 2) =\= 0, (ColN mod 2) =:= 0)), !,
    Cell = [[black]].
    

/*Checks if the given position belongs to the white cell and generates there a white cell*/
/*generateCell(+Cell,-RowN,-ColN)*/ 
generateCell(Cell,RowN,ColN) :-
    Cell = [[white]].


/*Displays the given GameState*/
/*displayExampleBoard(+GameState)*/
displayExampleBoard(GameState):-
    Board = GameState,
    length(Board,Size),
    printHead(Size),
    printBar(Size+1),
    printBoard(Size,0,Board).


/*Displays the given GameState and the current Player*/
/*displayGame(+GameState, +Player)*/
displayGame(GameState, Player):-
    Board = GameState,
    length(Board,Size),
    printHead(Size),
    printBar(Size+1),
    printBoard(Size,0,Board),
    write('\nPlaying: '),
    subsPlayer(Player,S),
    write(S),
    write('\n').


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
    last(Cell,Color),
    symbol(Color,S),
    write(S),
    write('-'),
    length(Cell,Size),
    write(Size).


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
    subsHead(NewIndex, S),
    write(S),
    write(' |'),
    printHead(Size, NewIndex).


/*Prints the Main Menu*/
/*printMainMenu*/
printMainMenu :-
    write(' _______________________________________________________\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|        ________   _______ ___  ___  ________ ___  __  |\n'),
    write('|       /       / /       //  / /  //  ___   //  / / /  |\n'),
    write('|      /   ____/ /  __   //  / /  //  /  /  //  /_/ /   |\n'),
    write('|     /   /____ /  / /  //  / /  //  /__/  //    __/    |\n'),
    write('|    /____    //  /_/  //  /_/  //  ___   //    /_      |\n'),
    write('|    _____/  //       //       //  /  /  //  __  /      |\n'),
    write('|   /_______//____/|_|/_______//__/  /__//__/ /_/       |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|               1 - Player vs Player                    |\n'),
    write('|                                                       |\n'),
    write('|               2 - Player vs Comp1.                    |\n'),
    write('|                                                       |\n'),
    write('|               3 - Comp1. vs Comp2.                    |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|_______________________________________________________|\n').


/*Prints the winner of the game, given a winner*/
/*printWinner(+Winner)*/
printWinner(Winner) :-
    subsPlayer(Winner,Text),
    write(' _______________________________________________________\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|        _   _   __ (_) _____  _____ _____  _____       |\n'),
    write('|       | | / | / // // __  // __  //  _ //  ___/       |\n'),
    write('|       | |//||/ // // / / // / / //  __//  /           |\n'),
    write('|       |__/ |__//_//_/ /_//_/ /_//___/ /__/            |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|                       '),write(Text),write('                           |\n'),                        
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|_______________________________________________________|\n').


/*Prints the possible colors that the user can choose*/
/*printColor*/
printColor :-
    write(' _______________________________________________________\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|              ______        __                         |\n'),
    write('|             / ____/ _____ / / _____ _____             |\n'),
    write('|            / /   // __  // // __  // ___/             |\n'),
    write('|           / /___// /_/ // // /_/ // /                 |\n'),
    write('|          /_____//_____//_//_____//_/                  |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),                      
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|                  1 - White                            |\n'),
    write('|                                                       |\n'),
    write('|                  2 - Black                            |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|_______________________________________________________|\n').


/*Prints the possible difficulties that the user can choose*/
/*printDifficulty*/
printDifficulty :-
    write(' _______________________________________________________\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|     _____     ____  ____                 __ __        |\n'),
    write('|   / __  /(_)/  __// ___/(_) ___  __  __ / // /_ __  __|\n'),
    write('|  / / / // // /_  / /_  / // ___// / / // // __// / / /|\n'),
    write('| / /_/ // // ___// ___// // /__ / /_/ // // /  / /_/ / |\n'),
    write('|/_____//_//_/   /_/   /_//____//_____//_//__/ /__,  /  |\n'),
    write('|                                             /_____/   |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),                      
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|                  1 - Random                           |\n'),
    write('|                                                       |\n'),
    write('|                  2 - Greedy                           |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|_______________________________________________________|\n').
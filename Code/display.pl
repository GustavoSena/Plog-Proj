generateBoard(Board,Size):-
    RowN is Size,
    generateBoard([],Board,RowN,Size).


generateBoard(FinalBoard,FinalBoard,0,Size).


generateBoard(InitBoard,FinalBoard,RowN,Size):-
    generateRow([],Row,RowN,Size),
    append(InitBoard,[Row],NewBoard),
    NewRowN is RowN - 1,
    generateBoard(NewBoard,FinalBoard,NewRowN,Size).


generateRow(InitRow,FinalRow,0,Size).


generateRow(FinalRow,FinalRow,Rown,0).


generateRow(InitRow,FinalRow,RowN,Size):-
    generateCell(Cell,RowN, Size),
    append(InitRow,Cell,UpdatedRow),
    NewSize is Size-1,
    generateRow(UpdatedRow,FinalRow,RowN,NewSize).

   
generateCell(Cell,RowN,ColN) :-
    (((RowN mod 2) =:= 0, (ColN mod 2) =\= 0) ; ((RowN mod 2) =\= 0, (ColN mod 2) =:= 0)), !,
    Cell = [[black]].
    

generateCell(Cell,RowN,ColN) :-
    Cell = [[white]].


displayGame(GameState,Player):-
    Board = GameState,
    length(Board,Size),
    printHead(Size),
    printBar(Size+1),
    printBoard(Size,0,Board),
    write('\nPlaying: '),
    subsPlayer(Player,S),
    write(S),
    write('\n').


printBoard(Size,N,[X|L]):-
    M is N+1,
    write(' '),
    write(M),
    write(' |'),
    printLine(X),
    write('\n'),
    printBar(Size+1),
    printBoard(Size,M,L).  


printBoard(Size,M,[]).


printLine([X|L]) :-
    printCell(X),
    write('|'),
    printLine(L).


printLine([]).


printCell(Cell):-
    last(Cell,Color),
    symbol(Color,S),
    write(S),
    write('-'),
    length(Cell,Size),
    write(Size).


printBar(0):-
    write('\n').


printBar(Size):-
    write('---|'),
    NewSize is Size-1,
    printBar(NewSize).


printHead(Size):-
    write('   |'),
    printHead(Size,0).


printHead(Size,Size):-
    write('\n').


printHead(Size,Index):-
    write(' '),
    NewIndex is Index+1,
    subsHead(NewIndex,S),
    write(S),
    write(' |'),
    printHead(Size, NewIndex).



printMainMenu(Nothing):-
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
    write('|               4 - Exit                                |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|                                                       |\n'),
    write('|_______________________________________________________|\n').



printWinner(Winner):-
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



printColor(Nothing):-
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



printDifficulty(Nothing):-
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
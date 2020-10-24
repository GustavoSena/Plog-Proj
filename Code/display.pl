

initialBoard([
    [[white], [black], [white], [black], [white]], 
    [[black], [white], [black], [white], [black]], 
    [[white], [black], [white], [black], [white]], 
    [[black], [white], [black], [white], [black]], 
    [[white], [black], [white], [black], [white]]
]).


symbol(black,S) :- S='B'.
symbol(white,S) :- S='W'.

displayBoard(Board,Player):-
    write('  | A | B | C | D | E |\n'),
    write('--|---|---|---|---|---|\n'),
    printBoard(0,Board),
    write('\nPlaying: '),
    write(Player).

printBoard(N,[X|L]):-
    M is N+1,
    write(M),
    write(' |'),
    printLine(X),
    write('\n--|---|---|---|---|---|\n'),
    printBoard(M,L).  
printBoard(M,[]).

printLine([X|L]) :-
    printCell(X),
    write('|'),
    printLine(L).

printLine([]).
printCell([X|L]) :- 
    symbol(X,S),
    write(S),
    write('-'),
    printCell(1,L).

printCell(N,[X|L]) :-
    M is N+1,
    printCell(M,L).

printCell(F,[]):-
    write(F).
    










/*White*/

middleBoard([
    [[black], [black], [white], [black], [white]], 
    [[white,black], [black], [black,white,black], [white], [black]], 
    [[white], [black,white,black], [black,white,white], [black], [white]], 
    [[white,black,white], [white,black], [white,black], [white,black,white], [black]], 
    [[black,white], [black], [white], [white], [white]]
]).




/*Black*/

finalBoard([
    [[black], [white,black], [black], [black,white], [black,white]], 
    [[white,black], [white,black], [black,white,black], [black,white], [white]], 
    [[white], [black,white,black], [black,white,white], [white], [black,white]], 
    [[white,black,white], [white,black], [white,black], [white,black,white], [black]], 
    [[black,white], [black], [white], [white], [white]]
]).





/*
deleteFirst([X|L],R):-
    R is L.
    */


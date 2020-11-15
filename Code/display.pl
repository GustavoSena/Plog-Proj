
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


displayBoard(Board,Size,Player):-
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





















    


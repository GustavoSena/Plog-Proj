symbol(black,S) :- S='O'.
symbol(white,S) :- S='X'.


subsHead(1,S):-S = 'A'.
subsHead(2,S):-S = 'B'.
subsHead(3,S):-S = 'C'.
subsHead(4,S):-S = 'D'.
subsHead(5,S):-S = 'E'.
subsHead(6,S):-S = 'F'.
subsHead(7,S):-S = 'G'.
subsHead(8,S):-S = 'H'.
subsHead(9,S):-S = 'I'.
subsHead(10,S):-S = 'J'.
subsHead(11,S):-S = 'K'.
subsHead(12,S):-S = 'L'.
subsHead(13,S):-S = 'M'.

subsCol('A',0).
subsCol('B',1).
subsCol('C',2).
subsCol('D',3).
subsCol('E',4).
subsCol('F',5).
subsCol('G',6).
subsCol('H',7).
subsCol('I',8).
subsCol('J',9).
subsCol('L',10).
subsCol('K',11).
subsCol('M',12).

subsCol('a',0).
subsCol('b',1).
subsCol('c',2).
subsCol('d',3).
subsCol('e',4).
subsCol('f',5).
subsCol('g',6).
subsCol('h',7).
subsCol('i',8).
subsCol('j',9).
subsCol('l',10).
subsCol('k',11).
subsCol('m',12).

subsRow(48, 0).
subsRow(49, 1).
subsRow(50, 2).
subsRow(51, 3).
subsRow(52, 4).
subsRow(53, 5).
subsRow(54, 6).
subsRow(55, 7).
subsRow(56, 8).
subsRow(57, 9).
subsRow(58, 10).
subsRow(59, 11).
subsRow(60, 12).
subsRow(61, 13).

subsPlayer(white,S):-S='White'.
subsPlayer(black,S):-S='Black'.

subsDif(1,random).
subsDif(1,greedy).



nextPlayer([white], black).
nextPlayer([black], white).

currPlayer([white], white).
currPlayer([black], black).

replace_nth0(List, Index, OldElem, NewElem, NewList) :-
   nth0(Index,List,OldElem,Transfer),
   nth0(Index,NewList,NewElem,Transfer).


getCellColor(Board,Col,Row,Color):-
   nth0(Row,Board,RowList),
   nth0(Col,RowList,ColorList),
   last(ColorList,Color).

deleteFirst([X|L],R):-
    R is L.





replaceValue(OldBoard, NewBoard, Column, Row, Color) :-
    nth0(Row,OldBoard,RowList),
    nth0(Column,RowList,ColList),

    length(ColList, ColSize),
    IndexCol is ColSize - 1,
    NextPlayer = visited,
    
    replace_nth0(ColList, IndexCol, Color, NextPlayer,NewCol),
    replace_nth0(RowList,Column,ColList,NewCol,NewRow),
    replace_nth0(OldBoard,Row,RowList,NewRow,NewBoard).


getBiggestValue(Value1,Value2,Biggest):-
   Value1<Value2,!,
   Biggest is Value2.

getBiggestValue(Value1,Value2,Biggest):-
   Biggest is Value1.

getWinner(WhiteScore, BlackScore, Winner) :-
   WhiteScore < BlackScore, !,
   Winner = black.

getWinner(WhiteScore, BlackScore, Winner) :-
   Winner = white.
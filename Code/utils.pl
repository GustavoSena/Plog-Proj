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


subsDif(1,rand).
subsDif(2,greedy).


nextPlayer([white], black).
nextPlayer([black], white).


currPlayer([white], white).
currPlayer([black], black).


/*Replaces in the Index position of List with the value NewElem*/
/*replace_nth0(+List, +Index, +OldElem, +NewElem, -NewList)*/
replace_nth0(List, Index, OldElem, NewElem, NewList) :-
   nth0(Index,List,OldElem,Transfer),
   nth0(Index,NewList,NewElem,Transfer).


/*Replaces in the given position of OldBoard with the piece of color Color*/
/*replaceValue(+OldBoard, -NewBoard, +Column, +Row, +Color)*/
replaceValue(OldBoard, NewBoard, Column, Row, Color) :-
    nth0(Row,OldBoard,RowList),
    nth0(Column,RowList,ColList),

    length(ColList, ColSize),
    IndexCol is ColSize - 1,
    NextPlayer = visited,
    
    replace_nth0(ColList, IndexCol, Color, NextPlayer,NewCol),
    replace_nth0(RowList,Column,ColList,NewCol,NewRow),
    replace_nth0(OldBoard,Row,RowList,NewRow,NewBoard).


/*Gets the winner of the game*/
/*getWinner(+WhiteScore, +BlackScore, -Winner, +LastPlayed)*/
getWinner(WhiteScore, BlackScore, Winner, LastPlayed) :-
   
   samsort(@>=, WhiteScore,WhiteOrdered),
   samsort(@>=, BlackScore,BlackOrdered),

   getBiggestList(WhiteOrdered,BlackOrdered,Winner,LastPlayed).


/*In the case of a tie, check next values*/
/*getBiggestList(+WhiteOrdered, +BlackOrdered, -Biggest, +LastPlayed)*/
getBiggestList([B1|List1], [B2|List2], Biggest, LastPlayed) :-
   B1 == B2, !,
   getBiggestList(List1, List2, Biggest, LastPlayed).


/*In the case of a tie, wins the whoever made the last move.*/
/*getBiggestList(+[], +[], -LastPlayed, +LastPlayed)*/
getBiggestList([], [], LastPlayed, LastPlayed). 


/*In the case Black pieces win*/
/*getBiggestList(+[], +BlackOrdered, -Biggest, +LastPlayed)*/
getBiggestList([], [B2|List2], black, LastPlayed).


/*In the White pieces win*/
/*getBiggestList(+WhiteOrdered, +[], -Biggest, +LastPlayed)*/
getBiggestList([B1|List1], [], white, LastPlayed).


/*In the case White pieces win*/
/*getBiggestList(+WhiteOrdered, +BlackOrdered, -Biggest, +LastPlayed)*/
getBiggestList([B1|List1], [B2|List2], Biggest, LastPlayed) :-
   B1 < B2, !,
   Biggest = white.


/*In the case Black pieces win*/
/*getBiggestList(+WhiteOrdered, +BlackOrdered, -Biggest, +LastPlayed)*/
getBiggestList([B1|List1], [B2|List2], Biggest, LastPlayed) :-
   B1 > B2, !,
   Biggest = black.


/*Given a position, starts looking for the next cell that belongs to the color of the player*/
/*searchForColor(+Board, +Color, +CurrCol, +CurrRow, -Col, -Row)*/
searchForColor(Board, Color, CurrCol, CurrRow, Col, Row) :-
    nth0(CurrRow, Board, RowList),
    searchForColorInRow(RowList, Color, CurrCol, CurrRow, Col, Row).


/*In case the cell has not in the current row, switch to the next row*/
/*searchForColor(+Board, +Color, +CurrCol, +CurrRow, -Col, -Row)*/
searchForColor(Board, Color, CurrCol, CurrRow, Col, Row) :-
    length(Board, Size),
    NewRow is CurrRow + 1,
    NewRow < Size, !,
    searchForColor(Board, Color, CurrCol, NewRow, Col, Row).


/*Given a position, starts looking for the cell in the current row*/
/*searchForColorInRow(+RowList, +Color, +CurrCol, +CurrRow, -Col, -Row)*/
searchForColorInRow(RowList, Color, CurrCol, CurrRow, Col, Row) :-
    nth0(CurrCol, RowList, Column),
    searchForColorInCol(RowList, Color, Column, CurrCol, CurrRow, Col, Row).


/*In case a cell is found*/
/*searchForColorInCol(+RowList, +Color, +Column, +CurrCol, +CurrRow, -Col, -Row)*/
searchForColorInCol(RowList, Color, Column, CurrCol, CurrRow, Col, Row) :-
    last(Column, CheckColor),
    Color == CheckColor,
    Col is CurrCol,
    Row is CurrRow.


/*In case the cell has not in the current column, switch to the next column*/
/*searchForColorInCol(+RowList, +Color, +Column, +CurrCol, +CurrRow, -Col, -Row)*/
searchForColorInCol(RowList, Color, Column, CurrCol, CurrRow, Col, Row):-
    length(RowList, Size),
    NewCol is CurrCol + 1,
    NewCol < Size, !,
    searchForColorInRow(RowList, Color, NewCol, CurrRow, Col, Row).


/*Gets the color of the given cell*/
/*getCellColor(+Board, +Col, +Row, -Color)*/
getCellColor(Board,Col,Row,Color) :-
   nth0(Row,Board,RowList),
   nth0(Col,RowList,ColorList),
   last(ColorList,Color).
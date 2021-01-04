:- use_module(library(random)).
:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(time)).

:- consult('utils.pl').
:- consult('interface.pl').
:- consult('solve_puzzle.pl').
:- consult('interface.pl').
:- consult('puzzles.pl').
:- consult('display.pl').

dominosweeper :-

    mainMenu(PuzzleList, Size),

    solvePuzzle(PuzzleList, Size, Solution),

    listToMatrix(PuzzleList, Size, Puzzle),

    nl, nl, displayBoard(Puzzle), nl, nl,

    play(Puzzle, Solution, Solution, Size).


/*Checks if there are still possible moves, and if so, ask the user for the move coordinates and check if the move made by the player is possible and if he did not hit a mine.*
/*play(+Puzzle, +Solution, +AuxBoard, +Size)*/
play(Puzzle, Solution, AuxBoard, Size) :-

    checkMoves(AuxBoard, 0),

    getCoord(Puzzle, Column, Row, Size),

    (
        (\+checkMine(Solution, Column, Row),
        getUpdateBoard(AuxBoard, NewAuxBoard, Column-Row, e),
        getUpdateBoard(Puzzle, NewBoard, Column-Row, 10),
        displayBoard(NewBoard),
        play(NewBoard, Solution, NewAuxBoard, Size))
    ; 
        gameOver(Solution)
    ).

/*In case there are no more moves*/
play(Puzzle, Solution, AuxBoard, Size) :-
    write('END!\n'), nl,
    displayBoard(Solution), nl.


/*If the player hits a mine, he loses the game*/
/*gameOver(+Solution)*/
gameOver(Solution) :-
    write('GAME OVER! YOU LOSE\n'), nl,
    displayBoard(Solution), nl.
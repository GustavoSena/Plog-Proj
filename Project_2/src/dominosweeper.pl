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

    displayBoard(Puzzle),

    play(Puzzle, Solution, Solution, Size).



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

    
play(Puzzle, Solution, AuxBoard, Size) :-
    write('END!\n'),
    displayBoard(Solution).



gameOver(Solution) :-
    write('GAME OVER! YOU LOSE\n'),
    displayBoard(Solution).




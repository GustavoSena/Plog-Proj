/*Gets the size of the board and the mode of game*/
/*mainMenu(-Size, -Player1, -LevelP1, -Player2, -LevelP2, -Option)*/
mainMenu(Size, Player1, LevelP1, Player2, LevelP2, Option) :-
    decideSizeBoard(Size),
    decideGameMode(Player1, LevelP1, Player2, LevelP2, Option).


/*Gets the size of the board*/
/*decideSizeBoard(-Size)*/
decideSizeBoard(Size) :-
    repeat,
    readSize(NSize),
    validateSize(NSize),
    generateBoard(Example,NSize),
    displayExampleBoard(Example),
    readConfirmation(Conf,NSize),
    validateConfirmation(Conf,Size,NSize).  


/*Gets the player's option to know the game mode he wants to play*/
/*decideGameMode(-Player1, -LevelP1, -Player2, -LevelP2, -Option)*/
decideGameMode(Player1, LevelP1, Player2, LevelP2, Option) :-
    repeat,
    readOption(Option),
    validateOption(Option),
    getPlayers(Player1, LevelP1, Player2, LevelP2, Option).


/*In the case the user has selected option 1, which means the game mode is Person-Person*/
/*getPlayers(-Player1, -LevelP1, -Player2, -LevelP2, +Option)*/
getPlayers(Player1, LevelP1, Player2, LevelP2, Option) :-
    Option == 1, !,
    Player1 = black,
    Player2 = white.


/*In the case the user has selected option 2, which means the game mode is Person-Computer*/
/*getPlayers(-Player1, -LevelP1, -Player2, -LevelP2, +Option)*/
getPlayers(Player1, LevelP1, Player2, LevelP2, Option) :-
    Option == 2, !,
    getPlayerColor(Player1, LevelP1, Player2, LevelP2).


/*In the case the user has selected option 3, which means the game mode is Computer-Computer*/
/*getPlayers(-Player1, -LevelP1, -Player2, -LevelP2, +Option)*/
getPlayers(Player1, LevelP1, Player2, LevelP2, Option) :-
    Option == 3, !,
    Player1 = comp1,
    Player2 = comp2,
    getCompDifficulty(comp1, LevelP1),
    getCompDifficulty(comp2, LevelP2).


/*In the case the user has selected option 4, which means that the user wants to exit the game*/
/*getPlayers(+Player1, +Player2, +Option)*/
getPlayers(Player1, Player2, Option) :-
    Option==4.


/*The user chooses the color of his pieces*/
/*getPlayerColor(-Player1, -LevelP1, -Player2, -LevelP2)*/
getPlayerColor(Player1, LevelP1, Player2, LevelP2) :-
    repeat,
    readPlayerColor(Color),
    validatePlayerColor(Color),
    setPlayerColor(Player1, LevelP1, Player2, LevelP2, Color).


/*Assigns to the user the color white*/
/*setPlayerColor(-Player1, -LevelP1, -Player2, -LevelP2, +Color)*/
setPlayerColor(Player1, LevelP1, Player2, LevelP2, Color) :-
    (Color == 1), !,
    Player1 = comp1,
    Player2 = white,
    getCompDifficulty(comp1, LevelP1).


/*Assigns to the user the color black*/
/*setPlayerColor(-Player1, -LevelP1, -Player2, -LevelP2, +Color)*/
setPlayerColor(Player1, LevelP1, Player2, LevelP2, Color) :-
    Player1 = Black,
    Player2 = comp2,
    getCompDifficulty(comp2, LevelP2).


/*The user chooses the difficulty of the game*/
/*getCompDifficulty(+Comp, -Level)*/
getCompDifficulty(Comp, Level) :-
    repeat,
    readDifficulty(Dif, Comp),
    validateDifficulty(Dif),
    subsDif(Dif, Level). 
extends Node

#this is a big ol' autoload script that essentially functions as a soundboard I can call anywhere
#since it's autoloaded, it will persist across scenes
#useful so music or menu sounds don't get abruptly cut off
#hopefull all the names are self explanatory because I don't feel like commenting each and every sound effect

func buttonClick():
	$ButtonClick.play()

func buttonBack():
	$ButtonBack.play()

func newGame():
	$NewGame.play()

func ambience():
	$Ambience.play()

func coinCollect():
	$CoinCollect.play()

func gemCollect():
	$GemCollect.play()

func checkpointSound():
	$Checkpoint.play()

func characterDeath():
	$CharacterDeath.play()

func victoryMusic():
	$VictoryMusic.play()

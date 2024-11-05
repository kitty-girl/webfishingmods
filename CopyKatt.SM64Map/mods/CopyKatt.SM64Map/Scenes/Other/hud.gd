extends CanvasLayer

var coin_count = 0 setget set_coin_count
var star_count = 0 setget set_star_count

func set_coin_count(v):
	coin_count = v
	$Coins.text = 'cx'+str(v)
	
func set_star_count(v):
	star_count = v
	$Stars.text = 'sx'+str(v)

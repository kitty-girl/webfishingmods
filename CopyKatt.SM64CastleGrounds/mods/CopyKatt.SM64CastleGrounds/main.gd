extends Node

const ID = "CopyKatt.SM64CastleGrounds" 
onready var Lure = get_node("/root/SulayreLure")

func _ready():
	Lure.add_map(ID,"castle_grounds", "mod://Scenes/Map/sm64_castle_grounds_map.tscn", "Castle Grounds")
	print(ID+' has loaded')

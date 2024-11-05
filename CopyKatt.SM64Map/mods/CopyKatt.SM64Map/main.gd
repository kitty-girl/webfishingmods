extends Node

const ID = "CopyKatt.SM64Map" 
onready var Lure = get_node("/root/SulayreLure")

func _ready():
	Lure.add_map(ID,"sm64", "mod://Scenes/Map/sm64_map.tscn", "Super Mario 64")
	print(ID+' has loaded')

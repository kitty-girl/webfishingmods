tool
extends Spatial

export var id = 0 setget set_id

func set_id(v):
	id = v
	$Sprite1.texture.region.position.x = id * 32

func _ready():
	$Sprite1.texture = $Sprite1.texture.duplicate()
	$Sprite2.texture = $Sprite1.texture
	
	$Sprite1.texture.region.position.x = id * 32

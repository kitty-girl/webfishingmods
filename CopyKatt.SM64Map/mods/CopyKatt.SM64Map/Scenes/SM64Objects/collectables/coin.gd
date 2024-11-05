extends Area

var collected = false

func _ready():
	connect('body_entered', self, '_on_body_entered')

func _on_body_entered(body):
	if body.is_in_group('controlled_player') and !collected:
		collected = true
		get_tree().get_nodes_in_group('sm64hud')[0].coin_count += 1
		$Sprite.visible = false
		$Sound.play()
		$Sound.connect('finished', self, 'queue_free')

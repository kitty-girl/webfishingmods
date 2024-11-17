extends Node

func _ready():
	for i in 5:
		InputMap.add_action('bind_'+str(i+6))
		var event = InputEventKey.new()
		event.scancode = [KEY_6,KEY_7,KEY_8,KEY_9,KEY_0][i]
		event.pressed = true
		InputMap.action_add_event('bind_'+str(i+6), event)
	print(InputMap.get_actions())
	
	get_tree().connect('node_added',self,'_on_node_added')

func _process(delta):
	for i in 5:
		if !PlayerData.hotbar.has(i+5):
			PlayerData.hotbar[i+5] = 0
	
	var inventory = $'/root/playerhud/main/menu/tabs/inventory'
	if is_instance_valid(inventory) and is_instance_valid(inventory.hovered_slot) and inventory.is_visible_in_tree():
		for i in 5:
			if Input.is_action_just_pressed("bind_"+str(i+6)):
				PlayerData._bind_hotbar_slot(i+5, inventory.hovered_slot.slot)
	
	var player = get_tree().get_nodes_in_group('controlled_player')[0] if get_tree().get_nodes_in_group('controlled_player').size() > 0 else null
	if is_instance_valid(player):
		for i in 5:
			if Input.is_action_just_pressed("bind_"+str(i+6)):
				player._equip_hotbar(i+5)

func _on_node_added(node:Node):
	if node and node == get_node_or_null('/root/playerhud/main/in_game/hotbar/item5'):
		yield(get_tree(), "idle_frame")
		for i in 5:
			var new_slot = node.duplicate()
			new_slot.name = 'item'+str(i+6)
			new_slot.force_hotkey = i+6
			node.get_parent().add_child(new_slot)

extends Node

var player
var setting = 0
var setting_instance = preload("res://mods/CopyKatt.Dinnerbone/dinnerbone_setting.tscn").instance()

func _ready():
	var file = File.new()
	if file.file_exists('user://dinnerbone.txt'):
		file.open('user://dinnerbone.txt',File.READ)
		setting = int(file.get_as_text())
		file.close()
	
	get_tree().connect('node_added',self,'_node_added')
	OptionsMenu.connect("_options_update", self, "_options_update")
	
	var options_node = OptionsMenu.get_node('Control/Panel/tabs_main/main/ScrollContainer/HBoxContainer/VBoxContainer')
	options_node.add_child_below_node(options_node.get_child(options_node.get_child_count()-2), setting_instance)
	
	setting_instance.get_node('dinnerbone').add_item("Disabled")
	setting_instance.get_node('dinnerbone').add_item("Enabled")
	
	setting_instance.get_node('dinnerbone').selected = setting

func _node_added(node):
	match node.script:
		preload("res://Scenes/Entities/Player/player.gd"):
			yield(get_tree(), "idle_frame")
			if node.is_in_group('controlled_player'):
				player = get_tree().get_nodes_in_group('controlled_player')[0]
				player.rotation_degrees.z = 180*setting
				player.get_node('rot_help').rotation_degrees.z = -180*setting
				player.get_node('catch_cam_position').rotation_degrees.z = -180*setting
				player.get_node('detection_zones').rotation_degrees.z = -180*setting
		preload("res://Scenes/Minigames/Fishing3/fishing3.gd"):
			if setting:
				yield(get_tree(), "idle_frame")
				node.scale = -Vector2.ONE
				node.offset = node.get_node('main').rect_size

func _options_update():
	setting = setting_instance.get_node('dinnerbone').selected
	if is_instance_valid(player):
		player.rotation_degrees.z = 180*setting
		player.get_node('rot_help').rotation_degrees.z = -180*setting
		player.get_node('catch_cam_position').rotation_degrees.z = -180*setting
		player.get_node('detection_zones').rotation_degrees.z = -180*setting
		
	var file = File.new()
	file.open('user://dinnerbone.txt',File.WRITE_READ)
	file.store_string(str(setting))

extends Node

# themes and panels for quick access
var theme := preload("res://Assets/Themes/main.tres")
var theme_secondary := preload("res://Assets/Themes/secondary.tres")
var _panel_med := preload("res://Assets/Themes/panel_med.tres")
var _panel_green := preload("res://Assets/Themes/panel_green.tres")
var _panel_red := preload("res://Assets/Themes/panel_red.tres")

# current instance of the theme button
var instance

# theme format for this version
const FORMAT := 'CopyKatt.ColorfulMenus_v1.0.0'

# the colors that are applied on first boot or when reset manually
var default_colors = {
	'panel_light': Color('ffeed5'),
	'panel_dim': Color('d5aa73'),
	'panel_accent': Color('5a755a'),
	'panel_warning': Color('ac0029'),

	'SEP_1':'-',

	'normal_button': Color('5a755a'),
	'hovered_button': Color('9c914a'),
	'disabled_button': Color('6a4420'),
	'pressed_button': Color('5a755a'),

	'SEP_2':'-',

	'button_font': Color('ffeed5'),
	'disabled_button_font': Color('d5aa73'),
	'pressed_button_font': Color('d5aa73'),

	'SEP_3':'-',

	'label_light': Color('ffeed5'),
	'label_dim': Color('d5aa73'),
	'label_mid': Color('b48141'),
	'label_dark': Color('6a441f'),
	'label_accent': Color('5a755a'),
	'label_worth': Color('a4aa39'),
	'label_warning': Color('ff0031'),

	'SEP_4':'-',

	'backpack_primary': Color('9c914a'),
	'backpack_secondary': Color('101c31'),
	'backpack_zipper': Color('a4756a'),

	'SEP_5':'-',

	'backpack_icons_primary': Color('ffeed5'),
	'backpack_icons_secondary': Color('d5aa73'),
	'backpack_icons_bg': Color('5a755a'),

	'SEP_6':'-',

	'line_edit': Color('bc9460'),
	'line_edit_font': Color('6a4420'),
	'disabled_line_edit_font': Color('cd9b61'),

	'SEP_7':'-',

	'inventory_tab_current': Color('d5aa73'),
	'inventory_tab_others': Color('a97f49'),
	'inventory_tab_hover': Color('c59a62'),
	'inventory_tab_pressed': Color('a17742'),

	'SEP_8':'-',

	'slider': Color('101c31'),
	'slider_grabber': Color('5a755a'),

	'SEP_9':'-',

	'scrollbar': Color('101c31'),
	'scrollbar_grabber': Color('5a755a'),
	
	'SEP_10': '-',
	
	'item_background': Color('ffeed5'),
	'item_background_hover': Color('ffeed5'),
	'item_background_pressed': Color('ffeed5'),
	'item_background_outline': Color('5a755a'),
	'empty_hand_icon': Color('d1a771'),
	
	'SEP_11': '-',
	
	'item_display_platform': Color('461c0a'),
	'item_display_platform_shadow': Color('23110b'),
	
	'SEP_12': '-',
	
	'sold_out_bg': Color('6a4420'),
	
	'SEP_13': '-',
	
	'progress_bar': Color('5a755a'),
	'progress_bar_bg': Color('24262d'),
	
	'SEP_14': '-',
	
	'dropdown_bg': Color('5a755a'),
	'dropdown_bg_hover': Color('9c914a'),
	'dropdown_text': Color('ffeed5'),
	'dropdown_text_hover': Color('ffeed5'),
	
	'SEP_15': '-',
	
	'title_cosmetic': Color('101c31'),
	
	'SEP_16': '-',
	
	'interaction_balloon': Color('ffeed5'),
	
	'SEP_17': '-',
	
	'knot_separator_light': Color('ffeed5'),
	'knot_separator_dim': Color('d5aa73'),
	
	'SEP_18': '-',
	
	'menu_button_bg': Color('ffeed5'),
	'menu_button_bg_hover': Color('d5aa73'),
	'menu_button_bg_pressed': Color('6a4420'),

	'menu_button_shadow': Color('6a4420'),
	'menu_button_shadow_pressed': Color('622810'),

	'menu_button_font': Color('6a4420'),
	'menu_button_font_hover': Color('ffeed5'),
	'menu_button_font_pressed': Color('ffeed5'),
}

# currently applied colors
# gets filled either by `default_colors` or the theme file
var colors = {}

# playerhud node if it exists for quick access
var playerhud = null

# material used to replace color in labels and richtextlabels
var text_mat := ShaderMaterial.new()

# the panel of the outline used when selecting an item in the hotbar
var _item_background_outline = preload("res://Scenes/HUD/inventory_item.tscn").instance().get_node('root/ColorRect').get_stylebox('panel')
# the panel of the outline used for selected cosmetics
var _cosmetic_background_outline = preload("res://Scenes/HUD/CosmeticMenu/cosmetic_button.tscn").instance().get_node('ColorRect').get_stylebox('panel')

# the panel used by Xenon for each setting
var xenon_setting_panel = null

var colored_images = {
	'knot_separator_light': ImageTexture.new(),
	'knot_separator_dim': ImageTexture.new(),
	'slider_grabber': ImageTexture.new(),
}

# io functions
func export_theme(path):
	var export_json = {
		'format': FORMAT,
		'colors': {}
	}
	for i in colors.keys():
		var color = colors[i]
		if color is String and color == '-':
			continue
		elif i in colors:
			export_json.colors[i] = color.to_html(true)
	
	var file = File.new()
	file.open(path,File.WRITE_READ)
	file.store_string(to_json(export_json))
	
	if instance:
		instance.get_node('Popup/ScrollContainer/VBoxContainer/UnsavedChanges').modulate = Color.transparent

func import_theme(path):
	var file = File.new()
	file.open(path,File.READ)
	
	var json = parse_json(file.get_as_text())
	
	if not json.has('format') or json.format != FORMAT:
		PopupMessage._show_popup("The theme failed to load")

	for i in json.colors.keys():
		colors[i] = Color(json.colors[i])
	update()
	
	if instance:
		instance.get_node('Popup/ScrollContainer/VBoxContainer/UnsavedChanges').modulate = Color.transparent

func reset_theme():
	colors = default_colors.duplicate()
	update()

func save_theme(): export_theme('user://ColorfulMenus.theme.json')
func reload_theme(): import_theme('user://ColorfulMenus.theme.json')


func _ready():
	# setup text color replace shader
	text_mat.shader = preload("res://mods/CopyKatt.ColorfulMenus/Assets/Shaders/rich_text_color_replace.gdshader")
	
	colored_images.knot_separator_light.create_from_image(preload("res://Assets/Textures/UI/knot_sep.png").get_data(), 0)
	colored_images.knot_separator_dim.create_from_image(preload("res://Assets/Textures/UI/knot_sep2.png").get_data(), 0)
	
	var empty_hand_tex = ImageTexture.new()
	empty_hand_tex.create_from_image(preload('res://Assets/Textures/Items/toolicons1.png').get_data(), 0)
	Globals.item_data.empty_hand.file.icon = empty_hand_tex
	
	recursive_apply_text_shader($'/root/OptionsMenu')
	
	# setup tooltip text separately
	for i in $'/root/Tooltip/Panel'.get_children():
		i.material = text_mat
	
	# set colors to saved ones, or create a new theme if none's applied
	colors = default_colors.duplicate()
	if File.new().file_exists('user://ColorfulMenus.theme.json'):
		reload_theme()
	else:
		save_theme()
	
	var theme_saver = preload("res://mods/CopyKatt.ColorfulMenus/default_themes_saver.gd").new()
	theme_saver.save()
#	add_child(theme_saver)
	
	if ResourceLoader.exists('res://mods/Nilenta.Xenon/main.gd'):
		xenon_setting_panel = load("res://mods/Nilenta.Xenon/Menu/XenonMenu/xenon_panel.tscn").instance().get_stylebox('panel')
	
	# connects to let the program know where and when to add the theme editor
	# also saves all labels to a cache that it can quickly apply new colors to
	get_tree().connect('node_added',self,'_on_node_added')

func _on_node_added(node):
	if node.name == 'playerhud' and node is CanvasLayer:
		# quick access to player hud
		playerhud = node
#		update()
		return
		
	if (node.name == 'esc_menu' or node.name == 'main_menu') and node is Control:
		# instance the theme editor
		var button = preload("res://mods/CopyKatt.ColorfulMenus/Scenes/theme_button.tscn").instance()
		node.add_child(button)
		instance = button
		button.get_node("ImportDialog").current_path = OS.get_user_data_dir().plus_file('theme-presets/')
		
		# connect io buttons
		button.get_node('Popup/ScrollContainer/VBoxContainer/MarginContainer/IO/Reset').connect('pressed', self, 'reset_theme')
		button.get_node('ExportDialog').connect('file_selected', self, 'export_theme')
		button.get_node('ImportDialog').connect('file_selected', self, 'import_theme')
		button.get_node('Popup/ScrollContainer/VBoxContainer/MarginContainer/IO/Reload').connect('pressed', self, 'reload_theme')
		button.get_node('Popup/ScrollContainer/VBoxContainer/MarginContainer/IO/Save').connect('pressed', self, 'save_theme')
		
		button.get_node('ExportDialog').connect("visibility_changed", button.get_node('ExportDialog'), "invalidate")
		button.get_node('ImportDialog').connect("visibility_changed", button.get_node('ImportDialog'), "invalidate")
		
		for i in default_colors.keys():
			if colors[i] is String and colors[i] == '-':
				# setup color picker separators
				var separator = HSeparator.new()
				button.get_node("Popup/ScrollContainer/VBoxContainer").add_child(separator)
				continue
			
			# setup color pickers
			var margin = MarginContainer.new()
			margin.name = i
			button.get_node("Popup/ScrollContainer/VBoxContainer").add_child(margin)
			
			var separator = HSplitContainer.new()
			separator.name = 'HSplitContainer'
			separator.collapsed = true
			margin.add_child(separator)
			
			var title = Label.new()
			title.name = 'Name'
			title.text = i.capitalize()
			separator.add_child(title)
			
			var color = ColorPickerButton.new()
			color.name = 'Color'
			color.color = colors[i]
			
			# this does make it more optimized but i prefer updating always when you're editing :3
			# so updating the theme got way too intensive to make it always update when you move the color pickers so :c
			color.get_picker().deferred_mode = true
			separator.add_child(color)
			color.get_picker().connect('color_changed', self, 'set_color', [i])
		update()
		return
	
#	if str(node.get_path()).ends_with('xenon_menu/Panel/Panel2/ScrollContainer/VBoxContainer'):
#		yield(get_tree(),'idle_frame')
#		xenon_setting_panel = node.get_child(0).get_stylebox('panel')
	
	# apply text_mat to every single label that enters the scenetree
	if node is RichTextLabel or node is Label:
		node.material = text_mat
		return
	
	if node is Button and node.get_stylebox('normal') == preload("res://Assets/Themes/button_tan_normal.tres"):
		node.add_to_group('__menu_button')
		node.add_color_override('font_color', colors.menu_button_font)
		node.add_color_override('font_color_hover', colors.menu_button_font_hover)
		node.add_color_override('font_color_pressed', colors.menu_button_font_pressed)
		node.add_color_override('font_color_disabled', colors.menu_button_font)
		node.add_color_override('font_color_focus', colors.menu_button_font_pressed)
	
	if node is preload("res://Scenes/HUD/CosmeticMenu/cosmetic_button.gd"):
		node.add_to_group('__cosmetic_button')
		node.add_color_override('font_color', colors.title_cosmetic)
		node.add_color_override('font_color_hover', colors.title_cosmetic)
		node.add_color_override('font_color_pressed', colors.title_cosmetic)
		node.add_color_override('font_color_disabled', colors.title_cosmetic)
		node.add_color_override('font_color_focus', colors.title_cosmetic)
		return
	
	if node is preload('res://Scenes/Entities/Player/SpeechBubble/speech_bubble.gd'):
		node.get_node('RichTextLabel/TextureRect').texture = color_texture(preload("res://Assets/Textures/UI/bubble_arrow.png"), colors.panel_light)
	
	if node is TextureRect and (node.texture == preload("res://Assets/Textures/UI/knot_sep.png") or \
			node.texture == preload("res://Assets/Textures/UI/knot_sep1.png")):
		node.texture = colored_images.knot_separator_light
		return
		
	if node is TextureRect and node.texture == preload("res://Assets/Textures/UI/knot_sep2.png"):
		node.texture = colored_images.knot_separator_dim
		return


# quickly edit color
# used when moving the color pickers
func set_color(color, id):
	colors[id] = color
	update()


# apply all the colors
func update():
	# debugging ! hooray!
	print('[CopyKatt.ColorfulMenus] Updating Theme')
	
	# panel
	theme.get_stylebox('panel', 'Panel').bg_color = colors.panel_light
	_panel_green.bg_color = colors.panel_accent
	_panel_med.bg_color = colors.panel_dim
	_panel_red.bg_color = colors.panel_warning
	if xenon_setting_panel != null:
		xenon_setting_panel.bg_color = colors.panel_light
	
	# button
	theme.get_stylebox('normal', 'Button').bg_color = colors.normal_button
	theme.get_stylebox('hover', 'Button').bg_color = colors.hovered_button
	theme.get_stylebox('disabled', 'Button').bg_color = colors.disabled_button
	theme.get_stylebox('pressed', 'Button').bg_color = colors.pressed_button
	
	# button text
	theme.set_color('font_color', 'Button', colors.button_font)
	theme.set_color('font_color_disabled', 'Button', colors.disabled_button_font)
	theme.set_color('font_color_pressed', 'Button', colors.pressed_button_font)
	
	# lineedit
	theme.get_stylebox('normal', 'LineEdit').bg_color = colors.line_edit
	theme.set_color('cursor_color', 'LineEdit', colors.line_edit_font)
	theme.set_color('font_color', 'LineEdit', colors.line_edit_font)
	theme.set_color('font_color_uneditable', 'LineEdit', colors.disabled_line_edit_font)
	
	
	# scrollbar
	theme.get_stylebox('scroll', 'VScrollBar').bg_color = colors.scrollbar
	theme.get_stylebox('scroll', 'VScrollBar').border_color = colors.scrollbar
	theme.get_stylebox('grabber', 'VScrollBar').bg_color = colors.scrollbar_grabber
	
	
	# item
	theme_secondary.get_stylebox('normal', 'Button').bg_color = colors.item_background
	theme_secondary.get_stylebox('hover', 'Button').bg_color = colors.item_background_hover
	theme_secondary.get_stylebox('pressed', 'Button').bg_color = colors.item_background_pressed
	theme_secondary.get_stylebox('hover', 'Button').border_color = colors.item_background_outline
	theme_secondary.get_stylebox('pressed', 'Button').border_color = colors.item_background_outline
	_item_background_outline.border_color = colors.item_background_outline
	_cosmetic_background_outline.border_color = colors.item_background_outline
	
	
	# slider
	var slider_tex = color_texture(preload("res://Assets/Textures/UI/scrollbar.png"), colors.slider_grabber)
	
	theme.get_stylebox('slider', 'HSlider').bg_color = colors.slider
	theme.set_icon('grabber', 'HSlider', slider_tex)
	theme.set_icon('grabber_disabled', 'HSlider', slider_tex)
	theme.set_icon('grabber_highlight', 'HSlider', slider_tex)
	
	
	# text
	text_mat.set_shader_param('light_replace', colors.label_light)
	text_mat.set_shader_param('dim_replace', colors.label_dim)
	text_mat.set_shader_param('mid_replace', colors.label_mid)
	text_mat.set_shader_param('dark_replace', colors.label_dark)
	text_mat.set_shader_param('accent_replace', colors.label_accent)
	text_mat.set_shader_param('worth_replace', colors.label_worth)
	text_mat.set_shader_param('warning_replace', colors.label_warning)
	
#	theme.set_color('font_color','Label', colors.label_accent)
	
	
	# sold out bg
	theme_secondary.get_stylebox('disabled', 'Button').bg_color = colors.sold_out_bg
	
	
	# progress bar
	theme.get_stylebox('bg', 'ProgressBar').bg_color = colors.progress_bar_bg
	theme.get_stylebox('fg', 'ProgressBar').bg_color = colors.progress_bar
	
	
	# dropdown
	theme.get_stylebox('panel', 'PopupMenu').bg_color = colors.dropdown_bg
	theme.get_stylebox('hover', 'PopupMenu').bg_color = colors.dropdown_bg_hover
	theme.set_color('font_color', 'PopupMenu', colors.dropdown_text)
	theme.set_color('font_color_hover', 'PopupMenu', colors.dropdown_text_hover)
	
	# empty hand icon
	Globals.item_data.empty_hand.file.icon.set_data(color_image(preload('res://Assets/Textures/Items/toolicons1.png').get_data().duplicate(), colors.empty_hand_icon))
	
	# knot separators
	colored_images.knot_separator_light.set_data(color_image(preload("res://Assets/Textures/UI/knot_sep.png").get_data().duplicate(), colors.knot_separator_light))
	colored_images.knot_separator_dim.set_data(color_image(preload("res://Assets/Textures/UI/knot_sep2.png").get_data().duplicate(), colors.knot_separator_dim))
	
	# menu buttons
	var menu_buttons = {
		'normal': preload("res://Assets/Themes/button_tan_normal.tres"),
		'hover': preload("res://Assets/Themes/button_tan_hover.tres"),
		'pressed': preload("res://Assets/Themes/button_tan_pressed.tres"),
	}
	
	menu_buttons.normal.bg_color = colors.menu_button_bg
	menu_buttons.normal.border_color = colors.menu_button_shadow
	
	menu_buttons.hover.bg_color = colors.menu_button_bg_hover
	menu_buttons.hover.border_color = colors.menu_button_shadow
	
	menu_buttons.pressed.bg_color = colors.menu_button_bg_pressed
	menu_buttons.pressed.border_color = colors.menu_button_shadow_pressed

	for node in get_tree().get_nodes_in_group('__menu_button'):
		node.add_color_override('font_color', colors.menu_button_font)
		node.add_color_override('font_color_hover', colors.menu_button_font_hover)
		node.add_color_override('font_color_pressed', colors.menu_button_font_pressed)
		node.add_color_override('font_color_disabled', colors.menu_button_font)
		node.add_color_override('font_color_focus', colors.menu_button_font)
	
	# title cosmetic text
	for i in get_tree().get_nodes_in_group('__cosmetic_button'):
		i.add_color_override('font_color', colors.title_cosmetic)
		i.add_color_override('font_color_hover', colors.title_cosmetic)
		i.add_color_override('font_color_pressed', colors.title_cosmetic)
		i.add_color_override('font_color_disabled', colors.title_cosmetic)
		i.add_color_override('font_color_focus', colors.title_cosmetic)
	
	# playerhud specific stuff
	if playerhud != null:
		# backpack colors
		var backpack = playerhud.get_node('main/backpack/Viewport/Spatial/backpack/Armature/Skeleton/Cube')
		backpack.get_surface_material(0).albedo_color = colors.backpack_primary
		backpack.get_surface_material(1).albedo_color = colors.backpack_secondary
		backpack.get_surface_material(2).albedo_color = colors.backpack_zipper
		
		# backpack buttons
		var button_mat = ShaderMaterial.new()
		button_mat.shader = preload("res://mods/CopyKatt.ColorfulMenus/Assets/Shaders/backpack_icon_color_replace.gdshader")
		button_mat.set_shader_param('white_replace', colors.backpack_icons_primary)
		button_mat.set_shader_param('yellow_replace', colors.backpack_icons_secondary)
		button_mat.set_shader_param('green_replace', colors.backpack_icons_bg)
		
		for i in playerhud.get_node('main/menu/buttons').get_children():
			i.get_node('TextureButton').material = button_mat
		
		# inventory tabs
		for i in playerhud.get_node('main/menu/tabs/inventory/tabs').get_children():
			if i is Button:
				i.get_stylebox('disabled').bg_color = colors.inventory_tab_current
				i.get_stylebox('normal').bg_color = colors.inventory_tab_others
				i.get_stylebox('hover').bg_color = colors.inventory_tab_hover
				i.get_stylebox('pressed').bg_color = colors.inventory_tab_pressed
		
		# inventory display platform
		var platform = playerhud.get_node('main/menu/tabs/inventory/Panel2/ViewportContainer/inv_preview/root/MeshInstance')
		platform.set_surface_material(0, platform.get_surface_material(0).duplicate())
		platform.get_surface_material(0).albedo_color = colors.item_display_platform
		
		var platform_shadow = platform.get_node('MeshInstance2')
		platform_shadow.set_surface_material(0,platform_shadow.get_surface_material(0).duplicate())
		platform_shadow.get_surface_material(0).albedo_color = colors.item_display_platform_shadow
		
		# interaction prompt
		var tex = playerhud.get_node('main/in_game/interact_notif/TextureRect').texture
		for i in tex.frames:
			tex.set_frame_texture(i, color_texture(tex.get_frame_texture(i), colors.interaction_balloon))
		
		
		# shop dialogue arrow
		playerhud.get_node('main/shop/dialogue/TextureRect').texture = color_texture(preload("res://Assets/Textures/UI/dialogue_arrow.png"), colors.panel_light)
	
	
	# set color pickers
	if instance and is_instance_valid(instance):
		instance.get_node('Popup/ScrollContainer/VBoxContainer/UnsavedChanges').modulate = Color.white
		for i in instance.get_node('Popup/ScrollContainer/VBoxContainer').get_children():
			var colorpicker = i.get_node_or_null('HSplitContainer/Color')
			if colorpicker:
				if colors.has(i.name) and default_colors.has(i.name):
					# apply the colors on loading new themes
					colorpicker.color = colors[i.name]
				else:
					# get rid of any colors that were in the theme file but aren't used by the mod
					i.queue_free()

func color_image(image, color):
	var img = image.duplicate(true)
	var img_used_rect = img.get_used_rect()
	
	img.fill_rect(img_used_rect,color)
	image.blit_rect_mask(img,image,img_used_rect,img_used_rect.position)
	
	return image

func color_texture(texture, color):
	var img = texture.get_data().duplicate()
	
	var tex = ImageTexture.new()
	tex.create_from_image(color_image(img, color), texture.flags)
	
	return tex

func recursive_apply_text_shader(node):
	if node is Label:
		node.material = text_mat
	for i in node.get_children():
		recursive_apply_text_shader(i)

extends Node

var themes = {
	'dark_theme.theme.json': '{"colors":{"backpack_icons_bg":"ff24262d","backpack_icons_primary":"ffc0eeaa","backpack_icons_secondary":"ff54be9a","backpack_primary":"ff3f454f","backpack_secondary":"ff24262d","backpack_zipper":"ff4797a1","button_font":"ffc0eeaa","disabled_button":"ff24262d","disabled_button_font":"ff3f454f","disabled_line_edit_font":"ff3f454f","dropdown_bg":"ff38a196","dropdown_bg_hover":"ff54be9a","dropdown_text":"ffc0eeaa","dropdown_text_hover":"ffffeed5","dropdown_text_selected":"ffd5aa73","empty_hand_icon":"ff3f454f","hovered_button":"ff7ae395","interaction_balloon":"ff24262d","inventory_tab_current":"ff3f454f","inventory_tab_hover":"ff6b7174","inventory_tab_others":"ff24262d","inventory_tab_pressed":"ff24262d","item_background":"ff24262d","item_background_hover":"ff24262d","item_background_outline":"ff7ae395","item_background_pressed":"ff24262d","item_display_platform":"ff38a196","item_display_platform_shadow":"ff307881","knot_separator_dim":"ff3f454f","knot_separator_light":"ff24262d","label_accent":"ff307881","label_dark":"ff38a196","label_dim":"ff7ae395","label_light":"ffc0eeaa","label_mid":"ff54be9a","label_warning":"ffda5c9a","label_worth":"ff1cea3a","line_edit":"ff24262d","line_edit_font":"ffc0eeaa","menu_button_bg":"ff3f454f","menu_button_bg_hover":"ff54be9a","menu_button_bg_pressed":"ff24262d","menu_button_font":"ffc0eeaa","menu_button_font_hover":"ffc0eeaa","menu_button_font_pressed":"ff7ae395","menu_button_shadow":"ff24262d","menu_button_shadow_pressed":"ff24262d","normal_button":"ff54be9a","panel_accent":"ff54be9a","panel_dim":"ff3f454f","panel_light":"ff24262d","panel_warning":"ffda5c9a","pressed_button":"ff38a196","pressed_button_font":"ff7ae395","progress_bar":"ff54be9a","progress_bar_bg":"ff24262d","scrollbar":"ff24262d","scrollbar_grabber":"ffc0eeaa","slider":"ff24262d","slider_grabber":"ffc0eeaa","sold_out_bg":"ff24262d","title_cosmetic":"ff7ae395"},"format":"CopyKatt.ColorfulMenus_v1.0.0"}'
}

func save():
	var dir = Directory.new()
	dir.make_dir('user://theme-presets')
	for i in themes.keys():
		var file = File.new()
		file.open('user://theme-presets/'+i, File.WRITE_READ)
		file.store_string(themes[i])
		file.close()

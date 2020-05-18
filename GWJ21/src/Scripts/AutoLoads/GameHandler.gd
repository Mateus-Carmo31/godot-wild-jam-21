extends Node

var level_completion_table : Dictionary
var level_unlock_table : Dictionary
var finale_played := false

var last_level_id = null
var last_completed_level = null

func _ready():
	
	for level_key in RESOURCES.LEVELS.keys():
		level_completion_table[level_key] = false
		level_unlock_table[level_key] = false
	
	level_unlock_table["level0"] = true
	
	load_game()

func return_to_map(was_level_completed):
	
	if was_level_completed:
		
		if level_completion_table[last_level_id] == false:
			level_completion_table[last_level_id] = true
			last_completed_level = last_level_id
			
			for new_level in RESOURCES.LEVEL_UNLOCKS[last_level_id]:
				if level_unlock_table.has(new_level):
					level_unlock_table[new_level] = true
				else:
					print_debug("Error! Unlocked level is invalid!")
			
		else:
			last_completed_level = null
	
	var game_completed = true
	for level in level_completion_table.keys():
		if level_completion_table[level] == false:
			game_completed = false
			break
	
	if game_completed and not finale_played:
		get_tree().change_scene_to(RESOURCES.FINALE)
	else:
		get_tree().change_scene_to(RESOURCES.MAP_MENU)
	
	save_game()

func change_to_level(level_id):
	
	if RESOURCES.LEVELS.has(level_id):
		get_tree().change_scene_to(RESOURCES.LEVELS[level_id])
		last_level_id = level_id
	else:
		get_tree().change_scene_to(RESOURCES.MAP_MENU)

func return_to_main_menu():
	save_game()
	get_tree().change_scene_to(RESOURCES.MAIN_MENU)

func save_game():
	var save_file = File.new()
	save_file.open("user://janus_leyline.save", File.WRITE)
	
	save_file.store_line(to_json(level_completion_table))
	save_file.store_line(to_json(level_unlock_table))
	save_file.store_line("true" if finale_played else "")
	
	save_file.close()

func load_game():
	var save_file = File.new()
	
	if not save_file.file_exists("user://janus_leyline.save"):
		save_game()
		return
	
	save_file.open("user://janus_leyline.save", File.READ)
	
	if save_file.get_len() == 0:
		save_file.close()
		save_game()
		return
	
	level_completion_table = parse_json(save_file.get_line())
	level_unlock_table = parse_json(save_file.get_line())
	finale_played = bool(save_file.get_line())
	
	save_file.close()

# Debug function. DON'T CALL
func destroy_save():
	var save_file = File.new()
	
	save_file.open("user://janus_leyline.save", File.WRITE)
	save_file.close()

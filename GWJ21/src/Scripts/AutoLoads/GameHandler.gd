extends Node

var level_completion_table : Dictionary
var level_unlock_table : Dictionary

var last_level_id = null
var last_completed_level = null

func _ready():
	
	for level_key in RESOURCES.LEVELS.keys():
		level_completion_table[level_key] = false
		level_unlock_table[level_key] = false
	
	level_unlock_table["level0"] = true
	level_unlock_table["level1"] = true

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
	
	get_tree().change_scene_to(RESOURCES.MAP_MENU)

func change_to_level(level_id):
	
	if RESOURCES.LEVELS.has(level_id):
		get_tree().change_scene_to(RESOURCES.LEVELS[level_id])
		last_level_id = level_id
	else:
		get_tree().change_scene_to(RESOURCES.MAP_MENU)

func return_to_main_menu():
	save_game()
	
	get_tree().change_scene_to(RESOURCES.MAIN_MENU)

func initial_setup():
	pass

func save_game():
	pass

func load_game():
	pass

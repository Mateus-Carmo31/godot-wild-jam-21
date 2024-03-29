extends Node

const enemies = {
	"slasher" : preload("res://src/Scenes/Enemies and Objects/SlasherSkull.tscn"),
	"slasher2" : preload("res://src/Scenes/Enemies and Objects/SlasherSkull2.tscn"),
	"big_slasher" : preload("res://src/Scenes/Enemies and Objects/BigSlasher.tscn"),
	"big_slasher2" : preload("res://src/Scenes/Enemies and Objects/BigSlasher2.tscn"),
	"stabby" : preload("res://src/Scenes/Enemies and Objects/StabbySkull.tscn"),
	"big_stabby" : preload("res://src/Scenes/Enemies and Objects/BigStabber.tscn"),
	"fire_skull" : preload("res://src/Scenes/Enemies and Objects/FireballSkull.tscn"),
	"big_fire_skull" : preload("res://src/Scenes/Enemies and Objects/BigFireSkull.tscn")
}

const objects = {
	"barrel" : preload("res://src/Scenes/Enemies and Objects/Barrel.tscn"),
	"box" : preload("res://src/Scenes/Enemies and Objects/Box.tscn"),
	"shelf" : preload("res://src/Scenes/Enemies and Objects/Shelf.tscn")
}

const MAP_MENU = preload("res://src/Scenes/Map/MapMenu.tscn")
const MAIN_MENU = preload("res://src/Scenes/Menus/MainMenu.tscn")
const FINALE = preload("res://src/Scenes/Menus/EndGameScene.tscn")

const LEVELS = {
	"level0" : preload("res://src/Scenes/Levels/Level0.tscn"),
	"level1" : preload("res://src/Scenes/Levels/Level1.tscn"),
	"level2" : preload("res://src/Scenes/Levels/Level2.tscn"),
	"level3" : preload("res://src/Scenes/Levels/Level3.tscn"),
	"level4" : preload("res://src/Scenes/Levels/Level4.tscn"),
	"level5" : preload("res://src/Scenes/Levels/Level5.tscn"),
	"level6" : preload("res://src/Scenes/Levels/Level6.tscn"),
	"level7" : preload("res://src/Scenes/Levels/Level7.tscn"),
	"level8" : preload("res://src/Scenes/Levels/Level8.tscn"),
	"level9" : preload("res://src/Scenes/Levels/Level9.tscn"),
	"level10" : preload("res://src/Scenes/Levels/Level10.tscn")
}

const LEVEL_UNLOCKS = {
	"level0" : ["level1"],
	"level1" : ["level2", "level3"],
	"level2" : ["level4"],
	"level3" : ["level7"],
	"level4" : ["level5"],
	"level5" : ["level6"],
	"level6" : [],
	"level7" : ["level8"],
	"level8" : ["level9"],
	"level9" : ["level10"],
	"level10" : []
}

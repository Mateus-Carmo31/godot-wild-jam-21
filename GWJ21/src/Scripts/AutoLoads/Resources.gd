extends Node

const enemies = {
	"slasher" : preload("res://src/Scenes/Enemies and Objects/SlasherSkull.tscn"),
	"slasher2" : preload("res://src/Scenes/Enemies and Objects/SlasherSkull2.tscn"),
	"big_slasher" : preload("res://src/Scenes/Enemies and Objects/BigSlasher.tscn"),
	"big_slasher2" : preload("res://src/Scenes/Enemies and Objects/BigSlasher2.tscn"),
	"stabby" : preload("res://src/Scenes/Enemies and Objects/StabbySkull.tscn"),
	"big_stabby" : preload("res://src/Scenes/Enemies and Objects/BigStabber.tscn"),
	"fire_skull" : preload("res://src/Scenes/Enemies and Objects/FireballSkull.tscn"),
}

const objects = {
	"barrel" : preload("res://src/Scenes/Enemies and Objects/Barrel.tscn"),
	"box" : preload("res://src/Scenes/Enemies and Objects/Box.tscn"),
	"shelf" : preload("res://src/Scenes/Enemies and Objects/Shelf.tscn")
}

const MAP_MENU = preload("res://src/Scenes/Map/MapMenu.tscn")
const MAIN_MENU = preload("res://src/Scenes/Menus/MainMenu.tscn")

const LEVELS = {
	"level0" : preload("res://src/Scenes/Levels/TestLevel.tscn"),
	"level1" : "",
	"level2" : ""
}

const LEVEL_UNLOCKS = {
	"level0" : ["level1"],
	"level1" : ["level2"]
}

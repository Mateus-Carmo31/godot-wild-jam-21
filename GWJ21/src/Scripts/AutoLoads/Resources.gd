extends Node

const enemies = {
	"slash" : preload("res://src/Scenes/Tests/TestSlashMeleeEnemy.tscn"),
	"stab" : preload("res://src/Scenes/Tests/TestStabMeleeEnemy.tscn"),
	"ranged" : preload("res://src/Scenes/Tests/TestRangedEnemy.tscn"),
	"level0_slow_slash" : preload("res://src/Scenes/Tests/BalanceTest/SlowSlasher.tscn"),
	"level0_fast_stab" : preload("res://src/Scenes/Tests/BalanceTest/FastStaber.tscn"),
	"level0_static" : preload("res://src/Scenes/Tests/BalanceTest/StaticShooter.tscn")
}

const objects = {
	"test" : preload("res://src/Scenes/Tests/TestKinematicSelectable2.tscn")
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

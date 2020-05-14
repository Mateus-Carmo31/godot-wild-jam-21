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

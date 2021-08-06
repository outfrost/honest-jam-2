class_name Game
extends Node

export var level_scene: PackedScene

onready var main_menu: Control = $UI/MainMenu
onready var transition_screen: TransitionScreen = $UI/TransitionScreen
onready var level_container: Node = $LevelContainer

var debug: Reference

func _ready() -> void:
	if OS.has_feature("debug"):
		var debug_script = load("res://debug.gd")
		if debug_script:
			debug = debug_script.new(self)
			debug.startup()

	main_menu.connect("start_game", self, "on_start_game")

func _process(delta: float) -> void:
	DebugOverlay.display("fps %d" % Performance.get_monitor(Performance.TIME_FPS))

	if Input.is_action_just_pressed("menu"):
		back_to_menu()

func on_start_game() -> void:
	transition_screen.fade_in()
	yield(transition_screen, "animation_finished")
	main_menu.hide()
	var level = level_scene.instance()
	level_container.add_child(level)
	transition_screen.fade_out()

func back_to_menu() -> void:
	transition_screen.fade_in()
	yield(transition_screen, "animation_finished")
	var nodes = level_container.get_children()
	for node in nodes:
		level_container.remove_child(node)
		node.queue_free()
	main_menu.show()
	transition_screen.fade_out()

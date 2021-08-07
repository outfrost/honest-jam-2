class_name Game
extends Node

const MUSIC_FADEIN_DURATION: float = 4.0
const MUSIC_FADEOUT_DURATION: float = 1.0

export var level_scene: PackedScene

onready var music_player: AudioStreamPlayer = $MusicPlayer
onready var main_menu: Control = $UI/MainMenu
onready var transition_screen: TransitionScreen = $UI/TransitionScreen
onready var level_container: Node = $LevelContainer
onready var camera: Camera = $Camera

var debug: Reference

var fadeMusicIn: bool = false
var selected_building: Spatial = null

func _ready() -> void:
	if OS.has_feature("debug"):
		var debug_script = load("res://debug.gd")
		if debug_script:
			debug = debug_script.new(self)
			debug.startup()

	main_menu.connect("start_game", self, "on_start_game")

	AudioServer.set_bus_volume_db(0, linear2db(0.5))
	selected_building = preload("res://object/MineralExtractor.tscn").instance()

func _process(delta: float) -> void:
	DebugOverlay.display("fps %d" % Performance.get_monitor(Performance.TIME_FPS))

	if Input.is_action_just_pressed("menu"):
		back_to_menu()

	var volDelta: float
	if fadeMusicIn:
		volDelta = delta / MUSIC_FADEIN_DURATION
	else:
		volDelta = - delta / MUSIC_FADEOUT_DURATION

	var linearVol = db2linear(music_player.volume_db)
	linearVol += volDelta
	linearVol = clamp(linearVol, 0.0, 1.0)
	music_player.volume_db = linear2db(linearVol)

func on_start_game() -> void:
	transition_screen.fade_in()
	yield(transition_screen, "animation_finished")
	main_menu.hide()
	var level = level_scene.instance()
	level_container.add_child(level)
	music_player.volume_db = linear2db(0.0)
	music_player.play()
	fadeMusicIn = true
	transition_screen.fade_out()

func back_to_menu() -> void:
	fadeMusicIn = false
	transition_screen.fade_in()
	yield(transition_screen, "animation_finished")
	var nodes = level_container.get_children()
	for node in nodes:
		level_container.remove_child(node)
		node.queue_free()
	music_player.stop()
	main_menu.show()
	transition_screen.fade_out()

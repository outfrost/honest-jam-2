class_name Game
extends Control

const MUSIC_FADEIN_DURATION: float = 4.0
const MUSIC_FADEOUT_DURATION: float = 1.0

export var level_scene: PackedScene
export var day_limt:int = 30


onready var music_player: AudioStreamPlayer = $MusicPlayer
onready var main_menu: Control = $UI/MainMenu
onready var transition_screen: TransitionScreen = $UI/TransitionScreen
onready var level_container: Node = $LevelContainer
onready var camera: Camera = $Camera

var debug: Reference

var fadeMusicIn: bool = false
var selected_building: Spatial = null
var hovered_tile: Tile = null
var level = null
var day = 0

var win_climate:int = 500
var win_food:int = 500

var power: int = 0
var water: int = 0
var climate: int = 0
var food: int = 0
var minerals: int = 0
var metal: int = 0

var power_flow: int = 0
var water_flow: int = 0
var climate_flow: int = 0
var food_flow: int = 0
var minerals_flow: int = 0
var metal_flow: int = 0

func _ready() -> void:
	if OS.has_feature("debug"):
		var debug_script = load("res://debug.gd")
		if debug_script:
			debug = debug_script.new(self)
			debug.startup()

	main_menu.connect("start_game", self, "on_start_game")

	AudioServer.set_bus_volume_db(0, linear2db(0.5))

func _process(delta: float) -> void:
	if OS.has_feature("debug"):
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

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var tile: Tile = tile_under_mouse(event.position)
		if tile:
			if tile != hovered_tile:
				tile.hover()
				hovered_tile = tile
		elif hovered_tile:
			hovered_tile.unhover()
			hovered_tile = null

func _gui_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		&& event.button_index == BUTTON_LEFT
		&& event.pressed
		&& selected_building
	):
		var pos: Vector2 = event.position
		var tile: Tile = tile_under_mouse(pos)
		if tile:
			if tile.can_plop(selected_building):
				tile.plop(selected_building)
				if selected_building.get("power_flow") != null:
					power_flow += selected_building.power_flow
					water_flow += selected_building.water_flow
					climate_flow += selected_building.climate_flow
					food_flow += selected_building.food_flow
					minerals_flow += selected_building.minerals_flow
					metal_flow += selected_building.metal_flow
				selected_building = null
				$UI/ResourceView.update_resources()
			get_tree().set_input_as_handled()

func on_start_game() -> void:
	transition_screen.fade_in()
	yield(transition_screen, "animation_finished")
	main_menu.hide()
	level = level_scene.instance()
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
	level = null
	reset_stats()
	music_player.stop()
	main_menu.show()
	transition_screen.fade_out()

func tile_under_mouse(pos: Vector2) -> Tile:
	var from = camera.project_ray_origin(pos)
	var to = from + camera.project_ray_normal(pos) * camera.far
	var space_state = get_tree().root.world.direct_space_state
	var result = space_state.intersect_ray(
		from,
		to,
		[],
		~0,
		false,
		true)
	if result.has("collider") && result["collider"].get_parent() is Tile:
		return result["collider"].get_parent()
	return null

func reset_stats():
	power = 0
	water = 0
	climate = 0
	food = 0
	minerals = 0
	metal = 0
	day = 0

	power_flow = 0
	water_flow = 0
	climate_flow = 0
	food_flow = 0
	minerals_flow = 0
	metal_flow = 0

	$UI/ResourceView.update_resources()

func update_resources():
	for x in level.tilemap:
		for z in level.tilemap:
			if level.tilemap[x][z].building:
				power += level.tilemap[x][z].building.power_flow
				water += level.tilemap[x][z].building.water_flow
				climate += level.tilemap[x][z].building.climate_flow
				food += level.tilemap[x][z].building.food_flow
				minerals += level.tilemap[x][z].building.minerals_flow
				metal += level.tilemap[x][z].building.metal_flow
	$UI/ResourceView.update_resources()

func game_lost():
	pass

func game_won():
	pass

func advance_day():
	day += 1
	update_resources()
	if power < 0 || water < 0 || climate < 0 || food < 0 || minerals < 0 || metal < 0:
		game_lost()
	if day == day_limt:
		if climate >= win_climate && food >= win_food:
			game_won()
		else:
			game_lost()

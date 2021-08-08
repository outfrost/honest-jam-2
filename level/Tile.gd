class_name Tile
extends Spatial

enum Type {
	BLANK,
	BUILD,
	OBSTACLE,
	WATER,
	MINERAL,
	ORE,
}

enum Dir {
	NORTH,
	EAST,
	SOUTH,
	WEST,
}

const PLOP_ALLOWED_MATERIAL: Material = preload("res://asset/plop_allowed.tres")
const PLOP_FORBIDDEN_MATERIAL: Material = preload("res://asset/plop_forbidden.tres")

export(Type) var type = Type.BLANK

onready var game: Node = find_parent("Game")

var link = {
	Dir.NORTH: null,
	Dir.EAST: null,
	Dir.SOUTH: null,
	Dir.WEST: null,
}

var terrain = []
var building: Spatial = null

func _ready() -> void:
	var vis = $Visualisation
	remove_child(vis)
	vis.queue_free()

	var space_state = get_world().direct_space_state

	for v in [
		Vector3(0.5, 0.0, 0.5),
		Vector3(0.5, 0.0, 1.5),
		Vector3(1.5, 0.0, 0.5),
		Vector3(1.5, 0.0, 1.5),
	]:
		var from = global_transform.origin + Vector3.UP * 20.0 + v
		while true:
			var result = space_state.intersect_ray(
				from,
				from + Vector3(0.0, -40.0, 0.0),
				[$ClickArea],
				~0,
				false,
				true)
			if !result.has("collider") || !(result["collider"] is Node):
				break
			var collider: Node = result["collider"]
			var parent: Spatial = collider.get_parent()
			terrain.append(parent)
			parent.remove_child(collider)
			collider.queue_free()

#	for _node in terrain:
#		var node: Spatial = _node
#		node.hide()

func _process(delta: float) -> void:
	pass

func hover() -> void:
	if !game.selected_building:
		return
	if game.selected_building.get_parent():
		game.selected_building.get_parent().remove_child(game.selected_building)
	add_child(game.selected_building)
	if can_plop(game.selected_building):
		apply_mat_override_recursive(PLOP_ALLOWED_MATERIAL, game.selected_building)
	else:
		apply_mat_override_recursive(PLOP_FORBIDDEN_MATERIAL, game.selected_building)

func unhover() -> void:
	if !game.selected_building:
		return
	if game.selected_building.get_parent() == self:
		apply_mat_override_recursive(null, game.selected_building)
		remove_child(game.selected_building)

func plop(thing: Spatial):
	if building:
		push_error("Cannot plop: there already is a building here (%s)")
		return
	building = thing
	if thing.get_parent():
		thing.get_parent().remove_child(thing)
	apply_mat_override_recursive(null, thing)
	add_child(thing)

func can_plop(thing: Spatial) -> bool:
	if (
		building
		|| thing.get("build_on") == null
		|| thing.build_on != type
	):
		return false
	if !thing.requires_neighbour:
		return true
	for dir in link:
		if link[dir] && link[dir].type == thing.neighbour:
			return true
	return false

func apply_mat_override_recursive(mat: Material, node: Node):
	if node is MeshInstance:
		node.material_override = mat
	for child in node.get_children():
		apply_mat_override_recursive(mat, child)

static func type_str(type) -> String:
	return Type.keys()[type]

static func dir_str(dir) -> String:
	return Dir.keys()[dir]

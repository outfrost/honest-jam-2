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

export(Type) var type = Type.BLANK

onready var game: Game = find_parent("Game")

var link = {
	Dir.NORTH: null,
	Dir.EAST: null,
	Dir.SOUTH: null,
	Dir.WEST: null,
}

var terrain = []

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

	$ClickArea.connect("mouse_entered", self, "hover")
	$ClickArea.connect("mouse_exited", self, "unhover")

func _process(delta: float) -> void:
	pass

func hover() -> void:
	print("YEET")
	if game.selected_building.get_parent():
		game.selected_building.get_parent().remove_child(game.selected_building)
	add_child(game.selected_building)

func unhover() -> void:
	if game.selected_building.get_parent() == self:
		remove_child(game.selected_building)

static func type_str(type) -> String:
	return Type.keys()[type]

static func dir_str(dir) -> String:
	return Dir.keys()[dir]

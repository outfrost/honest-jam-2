extends Button

export var building: PackedScene

onready var game: Node = find_parent("Game")

func _ready() -> void:
	connect("pressed", self, "pressed")

func pressed() -> void:
	if game.selected_building:
		game.selected_building.queue_free()
	game.selected_building = building.instance()

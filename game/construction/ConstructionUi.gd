extends Control

onready var panel: PopupPanel = $PopupPanel

onready var game: Node = find_parent("Game")

func _ready() -> void:
	$PanelToggleButton.connect("pressed", self, "toggle_panel")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("build_menu"):
		toggle_panel()

func toggle_panel() -> void:
	if !panel.visible:
		panel.show()
	else:
		panel.hide()
		if game.selected_building:
			game.selected_building.queue_free()
			game.selected_building = null

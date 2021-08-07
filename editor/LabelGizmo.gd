tool
extends Position3D

export(String, MULTILINE) var text = "" setget set_text

var label

func _ready() -> void:
	var sprite = $LabelGizmoSprite
	if Engine.editor_hint:
		sprite.visible = true
		label = $LabelGizmoSprite/Viewport/Label
		label.text = text
	else:
		sprite.visible = false
		sprite.queue_free()

func set_text(t: String) -> void:
	text = t
	if label:
		label.text = text

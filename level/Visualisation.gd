tool
extends Spatial

func _process(delta: float) -> void:
	$LabelGizmo.text = Tile.type_str(get_parent().type)

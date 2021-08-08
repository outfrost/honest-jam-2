extends Panel

signal dismissed()

func _ready() -> void:
	$Button.connect("pressed", self, "button_pressed")

func button_pressed():
	hide()
	emit_signal("dismissed")

func set_text(s: String):
	$RichTextLabel.bbcode_text = s

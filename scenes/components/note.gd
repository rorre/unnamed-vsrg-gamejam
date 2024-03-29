extends Panel
class_name Note

enum NoteType { SLIDER = 1, NOTE = 2, TICK = 3 }

@export var time: int = 0
@export var end_time: int = 0
@export var type: NoteType = NoteType.NOTE
@export var colsize: int = 1
@export var col: int = 0
@export var clicked: bool = false
@export var parent: Note
@export var margin: int = 2

var settings: UserSettings

var slider_added = false
const WIDTH = 100
const HEIGHT = 15


func update_note_size() -> Vector2:
	var x_size = colsize * WIDTH - margin
	var px_per_ms = 605.0 / settings.ms_window
	var size: Vector2
	if type == NoteType.SLIDER:
		var new_height = px_per_ms * (end_time - time)
		size = Vector2(x_size, new_height)
	else:
		var new_height = HEIGHT
		size = Vector2(x_size, new_height)
	set_size(size)
	return size


func configure_style():
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10

	if type == NoteType.SLIDER:
		style.bg_color = Color.GREEN
		style.bg_color.a = 0.5
		modulate.a = 0.5
	else:
		if col < 2:
			style.bg_color = Color("#5BCEFA")
		else:
			style.bg_color = Color("#F5A9B8")

		if colsize == 4 or (col == 1 and colsize == 2):
			style.bg_color = Color.WHITE

		if col == 1 and colsize == 3:
			style.bg_color = Color("#F5A9B8")
	add_theme_stylebox_override("panel", style)
	return style


# Called when the node enters the scene tree for the first time.
func _ready():
	settings = get_node("/root/UserSettings")
	var new_size = update_note_size()
	set_position(Vector2(100 * col, -new_size.y))
	configure_style()
	hide()
	
	settings.speed_change.connect(func (_speed): return update_note_size())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_type(t: String):
	if t == "note":
		type = NoteType.NOTE
	elif t == "tick":
		type = NoteType.TICK
	else:
		type = NoteType.SLIDER


func is_valid_click(clickCol: int):
	return col == clickCol or (col < clickCol and col + colsize - 1 >= clickCol)

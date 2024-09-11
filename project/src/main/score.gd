class_name Score extends Node2D

const font_size := 48
const font_color := Color.DIM_GRAY

var value := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    self.position = Vector2(0, -Common.RADIUS * 0.993)

func _draw() -> void:
    var msg := "%02d" % value
    var text_size := Common.font.get_string_size(msg, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size)
    var posn := Vector2(-text_size.x/2, 0)
    draw_string(Common.font, posn, msg, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, font_color)

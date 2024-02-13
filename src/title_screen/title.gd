extends Node2D

const font:FontFile = preload("res://fonts/Orbitron Medium.otf")

func _draw():
    draw_string(font, Vector2(-750, -13500), "missile.cmd", HORIZONTAL_ALIGNMENT_CENTER, -1.0, 256, Color.BLACK)
    draw_string_outline(font, Vector2(-750, -13500), "missile.cmd", HORIZONTAL_ALIGNMENT_CENTER, -1.0, 256, 8, Color.CYAN)

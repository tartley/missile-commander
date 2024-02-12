extends Node2D

func _draw():
    var font:FontFile = preload("res://fonts/Orbitron Medium.otf")
    draw_string(font, Vector2(-750, -13500), "missile.cmd", HORIZONTAL_ALIGNMENT_CENTER, -1.0, 256, Color.BLACK)
    draw_string_outline(font, Vector2(-750, -13500), "missile.cmd", HORIZONTAL_ALIGNMENT_CENTER, -1.0, 256, 8, Color.CYAN)

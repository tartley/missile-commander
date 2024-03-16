class_name GameOver extends Node2D

const font:FontFile = preload("res://fonts/Orbitron Medium.otf")

func _draw():
    var rect = get_viewport_rect()
    var height = rect.size.y / 2
    draw_string(font, Vector2(0, height), "game", HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 256, Color.BLACK)
    draw_string_outline(font, Vector2(0, height), "game", HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 256, 8, Color.CYAN)

    draw_string(font, Vector2(0, height +  256), "over", HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 256, Color.BLACK)
    draw_string_outline(font, Vector2(0, height + 256), "over", HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 256, 8, Color.CYAN)

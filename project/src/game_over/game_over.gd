class_name GameOver extends Node2D

var text = "Game Over"

func _draw():
    var rect = get_viewport_rect()
    var y = rect.size.y / 2
    var height = 256
    draw_string(Main.font, Vector2(0, y), text, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, height, Color.BLACK)
    draw_string_outline(Main.font, Vector2(0, y), text, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, height, 8, Color.CYAN)

func _unhandled_input(event:InputEvent):
    if event is InputEventKey and event.pressed and not event.echo:
        queue_free()
    if event is InputEventMouseButton and event.pressed:
        queue_free()

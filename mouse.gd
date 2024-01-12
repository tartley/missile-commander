extends Node2D

func _notification(what):
    match what:
        MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
            position.x = 0
            position.y = 500
        MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent):
    if event is InputEventMouseMotion:
        position.x += event.relative[0] * 1.2
        position.y -= event.relative[1] * 1.2

func _draw():
    var verts: Array[Vector2] = [
        Vector2(-30, 0),
        Vector2(-10, 0),
        Vector2(10, 0),
        Vector2(30, 0),
        Vector2(0, -22),
        Vector2(0, -10),
        Vector2(0, 10),
        Vector2(0, 22),
    ]
    draw_multiline(verts, Color(.6, .8, .7), 3.0)

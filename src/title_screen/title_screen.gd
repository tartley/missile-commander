class_name TitleScreen extends Node2D

const font:FontFile = preload("res://fonts/Orbitron Medium.otf")

func _ready():
    for missile in get_tree().get_nodes_in_group("missiles"):
        missile.destroy()

func _draw():
    var rect = get_viewport_rect()
    var height = rect.size.y / 3
    # Title
    draw_string(font, Vector2(0, height), "Missile Commander", HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 256, Color.BLACK)
    draw_string_outline(font, Vector2(0, height), "Missile Commander", HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 256, 8, Color.CYAN)

    # Instructions
    var color := Color.DARK_CYAN
    var ypos : int = rect.size.y / 2
    for line in [
        "Use mouse to aim,",
        "and mouse buttons or A, S, and D,",
        "to fire from left, center, or right base.",
        "",
        "Press fire to start",
    ]:
        draw_string(
            font, Vector2(0, ypos), line, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 64, color,
        )
        ypos += 64

    # Version
    var vstr : String = "Version %s: Unfinished but playable for 30 seconds." % ProjectSettings.get_setting("application/config/version", "unknown")
    draw_string(
        font, Vector2(rect.position.x + 16, rect.end.y - 16), vstr, HORIZONTAL_ALIGNMENT_LEFT, rect.size.x, 48, Color("666")
    )


func _unhandled_input(event:InputEvent):
    if event is InputEventKey and event.pressed and not event.echo:
        if event.keycode in [KEY_A, KEY_W, KEY_S, KEY_D]:
            queue_free()
    if event is InputEventMouseButton and event.pressed:
        if event.button_index in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_MIDDLE, MOUSE_BUTTON_RIGHT]:
            queue_free()

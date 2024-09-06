class_name TitleScreen extends Node2D

const font:FontFile = preload("res://fonts/Orbitron-Medium.otf")

func _ready():
    for missile in get_tree().get_nodes_in_group("missiles"):
        missile.destroy()

func get_version() -> String:
    var version:String = ProjectSettings.get_setting("application/config/version")
    assert(version, "'version' not found")
    return version

func get_description() -> String:
    var description:String = ProjectSettings.get_setting("application/config/description")
    assert(description, "'description' not found")
    return description

func _draw():
    var rect = get_viewport_rect()
    # Title
    var ypos:int = rect.size.y / 3
    var font_size := 256
    for line in ["Missile", "Commander"]:
        draw_string(font, Vector2(0, ypos), line, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, font_size, Color.BLACK)
        draw_string_outline(font, Vector2(0, ypos), line, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, font_size, 8, Color.CYAN)
        ypos += font_size

    # Instructions
    ypos = rect.size.y * 7 / 12
    font_size = 64
    for line in [
        "Use mouse to aim,",
        "and mouse buttons or A, S, and D,",
        "to fire from left, center, or right base.",
        "",
        "Press fire to start",
    ]:
        draw_string_outline(font, Vector2(0, ypos), line, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, font_size, 8, Color.DARK_CYAN)
        draw_string(font, Vector2(0, ypos), line, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, font_size, Color.CYAN)
        ypos += font_size

    # Version
    var vstr : String = "Version %s: %s" % [get_version(), get_description()]
    draw_string(
        font, Vector2(rect.position.x + 16, rect.end.y - 16), vstr, HORIZONTAL_ALIGNMENT_LEFT, rect.size.x, 48, Color("888")
    )

func event_is_fire_button(event) -> bool:
    return bool(
        (
            event is InputEventKey and
            not event.echo and
            event.keycode in [KEY_A, KEY_W, KEY_S, KEY_D]
        ) or (
            event is InputEventMouseButton and
            event.button_index in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_MIDDLE, MOUSE_BUTTON_RIGHT]
        ) and
        event.pressed
    )

func _unhandled_input(event:InputEvent):
    if event_is_fire_button(event):
        queue_free()

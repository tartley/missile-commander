extends Camera2D

const PAN_CAMERA := true

func get_camera_position(input:Vector2) -> Vector2:
    var pos := Vector2(0, %Ground.RADIUS + get_viewport_rect().size.y * 0.4)
    if PAN_CAMERA:
        pos += Vector2(
            input.x * 1630,
            get_viewport_rect().size.y * 0.1 * input.y,
        )
    return pos

func _process(_delta):
    var radius:float = %Ground.RADIUS + get_viewport_rect().size.y * 0.4
    rotation = - %Ground.PLANET_ANGLE * 0.64 * %Mouse.normalized.x
    position = Vector2(
        -radius * sin(rotation),
         radius * cos(rotation) + get_viewport_rect().size.y * %Mouse.normalized.y * 0.1
    )

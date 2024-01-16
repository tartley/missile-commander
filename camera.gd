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

func get_camera_rotation(input:Vector2) -> float:
    return input.x / -7

func _process(_delta):
    position = get_camera_position(%Mouse.normalized)
    rotation = get_camera_rotation(%Mouse.normalized)


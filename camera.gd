extends Camera2D

const PAN_CAMERA := true

func get_camera_position(input:Vector2) -> Vector2:
    var pos := Vector2(0, %Ground.RADIUS + get_viewport_rect().size.y * 0.4)
    var rot := float(0.0)
    if PAN_CAMERA:
        pos += Vector2(
            input.x * 1500,
            get_viewport_rect().size.y * 0.1 * input.y,
        )
    return pos

func get_camera_rotation(input:Vector2) -> float:
    return input.x / -12
            
func _process(_delta):
    var pan:Vector2
    if Engine.is_editor_hint():
        # TODO draw extents
        pass
    else:
        position = get_camera_position(%Mouse.normalized)
        rotation = get_camera_rotation(%Mouse.normalized)        

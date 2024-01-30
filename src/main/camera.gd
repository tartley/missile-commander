extends Camera2D

# Need injecting by a parent
var mouse:Node2D

func _process(_delta):
    var radius:float = Const.RADIUS + get_viewport_rect().size.y * 0.4
    position = Vector2(
        -radius * sin(rotation),
        radius * cos(rotation) + get_viewport_rect().size.y * mouse.normalized.y * 0.1
    )
    rotation = Const.PLANET_ANGLE * -0.64 * mouse.normalized.x

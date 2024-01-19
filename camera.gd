extends Camera2D

func _process(_delta):
    var radius:float = %Ground.RADIUS + get_viewport_rect().size.y * 0.4
    rotation = - %Ground.PLANET_ANGLE * 0.64 * %Mouse.normalized.x
    position = Vector2(
        -radius * sin(rotation),
         radius * cos(rotation) + get_viewport_rect().size.y * %Mouse.normalized.y * 0.1
    )

extends Camera2D

var mouse:Node2D
var ground:Node2D

func _process(_delta):
    var radius:float = ground.RADIUS + get_viewport_rect().size.y * 0.4
    rotation = - ground.PLANET_ANGLE * 0.64 * mouse.normalized.x
    position = Vector2(
        -radius * sin(rotation),
         radius * cos(rotation) + get_viewport_rect().size.y * mouse.normalized.y * 0.1
    )

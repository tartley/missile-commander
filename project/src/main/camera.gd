extends Camera2D

# Need injecting by a parent
var mouse:Node2D

func _ready():
    self.zoom = Vector2(1, 1)

func _process(_delta):
    var radius:float = Common.RADIUS + get_viewport_rect().size.y * 0.4
    self.rotation = Common.PLANET_ANGLE * 0.64 * mouse.normalized.x
    self.position = Vector2(
        radius * sin(rotation),
        -radius * cos(rotation) - get_viewport_rect().size.y * mouse.normalized.y * 0.1
    )

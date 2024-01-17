extends Node2D

const SIZE := 40.0
const verts: Array[Vector2] = [
    Vector2(0.0, -SIZE/2.0),
    Vector2(-SIZE/4.0, +SIZE/2.0),
    Vector2(+SIZE/4.0, +SIZE/2.0),
    Vector2(0.0, -SIZE/2.0),
]

var velocity: Vector2

func _init() -> void:
    var rng = RandomNumberGenerator.new()
    position = Vector2(1960, 2160 - SIZE/2)
    var destination := Vector2(rng.randf_range(0, 2*1960), 0)
    var time = 10 # seconds
    velocity = (destination - position) / time
    rotation = tanh(velocity.x / -velocity.y)

func _ready() -> void:
    $Appearance.verts = verts
    $Exhaust.direction = Vector2(velocity.x, -velocity.y)

func launch(pos:Vector2, destination:Vector2, speed:float):
    position = pos
    rotation = (destination - position).angle() + PI / 2
    velocity = Vector2.from_angle(rotation - PI / 2) * speed

func _process(delta: float) -> void:
    position += velocity * delta

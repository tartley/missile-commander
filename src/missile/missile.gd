class_name Missile extends Node2D

const SIZE := 20.0
# A rightwards pointing triangle
const verts: Array[Vector2] = [
    Vector2(+SIZE/2,       0), # rightmost tip
    Vector2(-SIZE/2, -SIZE/4), # base bottom
    Vector2(-SIZE/2, +SIZE/4), # base top
    Vector2(+SIZE/2,       0), # rightmost tip
]

var velocity: Vector2
var target # City or Base or null

func _ready() -> void:
    # our trail
    $Trail.position = Vector2(SIZE/2, 0)
    $Trail.direction = Vector2.LEFT
    var speed := self.velocity.length()
    $Trail.initial_velocity_max = 250 - speed
    $Trail.initial_velocity_min = 250 - speed
    # collision shape
    $CollisionPolygon2D.polygon = self.verts

func launch(pos:Vector2, target_:Node2D, destination:Vector2, speed:float):
    self.position = pos
    self.target = target_
    self.rotation = (destination - position).angle()
    self.velocity = Vector2.from_angle(rotation) * speed

func _process(delta: float) -> void:
    self.position += velocity * delta

func _draw():
    draw_polygon(verts, [Color.BLACK])
    draw_polyline(verts, Color(.8, 7, .4), 2.0, true)

func destroy():
    var trail := $Trail
    trail.reparent(Common.world)
    trail.emitting = false
    queue_free()

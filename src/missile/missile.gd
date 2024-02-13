class_name Missile extends Node2D

const MissileScene:PackedScene = preload("res://src/missile/missile.tscn")

const SIZE := 20.0
# A rightwards pointing triangle
const verts: Array[Vector2] = [
    Vector2(+SIZE/2,       0), # rightmost tip
    Vector2(-SIZE/2, -SIZE/4), # base bottom
    Vector2(-SIZE/2, +SIZE/4), # base top
    Vector2(+SIZE/2,       0), # rightmost tip
]

var target:Node2D # City or Base or null
var velocity: Vector2

static func create(pos:Vector2, tgt:Node2D, dest:Vector2, speed:float):
    var missile := MissileScene.instantiate() as Missile
    missile.position = pos
    missile.target = tgt
    missile.rotation = (dest - pos).angle()
    missile.velocity = Vector2.from_angle(missile.rotation) * speed
    Common.world.add_child(missile)

func _ready() -> void:
    # our trail
    $Trail.position = Vector2(SIZE/2, 0)
    $Trail.direction = Vector2.LEFT
    var speed := self.velocity.length()
    $Trail.initial_velocity_max = 250 - speed
    $Trail.initial_velocity_min = 250 - speed
    # collision shape
    $CollisionPolygon2D.polygon = self.verts

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

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
var trail:Trail

static func create(pos:Vector2, tgt:Node2D, dest:Vector2, speed:float):
    var missile := MissileScene.instantiate() as Missile
    missile.position = pos
    missile.target = tgt
    missile.rotation = (dest - pos).angle()
    missile.velocity = Vector2.from_angle(missile.rotation) * speed
    Common.world.add_child(missile)

func _ready() -> void:
    self.add_to_group("missiles")
    # our trail
    var speed := self.velocity.length()
    self.trail = $Trail as Trail
    self.trail.position = Vector2(SIZE/2, 0)
    self.trail.direction = Vector2.LEFT
    self.trail.initial_velocity_max = 250 - speed
    self.trail.initial_velocity_min = 250 - speed
    # collision shape
    var collision := $CollisionPolygon2D as CollisionPolygon2D
    collision.polygon = self.verts

func _process(delta: float) -> void:
    self.position += velocity * delta

func _draw():
    draw_polygon(verts, [Color.BLACK])
    draw_polyline(verts, Color(.8, 7, .4), 2.0, true)

func destroy():
    self.trail.reparent(Common.world)
    self.trail.emitting = false
    queue_free()

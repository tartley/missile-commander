class_name Bomb extends Node2D

const BombScene:PackedScene = preload("res://src/bomb/bomb.tscn")

const SIZE := 20.0
# A rightwards pointing triangle
const verts: Array[Vector2] = [
    Vector2(+SIZE/2,       0), # rightmost tip
    Vector2(-SIZE/2, -SIZE/4), # base bottom
    Vector2(-SIZE/2, +SIZE/4), # base top
    Vector2(+SIZE/2,       0), # rightmost tip
]

static var all:Array[Bomb] = []

var target:Node2D # City or Base or null
var velocity: Vector2
var trail:Trail

static func create(pos:Vector2, tgt:Node2D, dest:Vector2, speed:float) -> Bomb:
    var bomb := BombScene.instantiate() as Bomb
    bomb.position = pos
    bomb.target = tgt
    bomb.rotation = (dest - pos).angle()
    bomb.velocity = Vector2.from_angle(bomb.rotation) * speed
    Main.world.add_child(bomb)
    return bomb

static func destroy_all():
    for bomb in Bomb.all.duplicate():
        bomb.destroy()

func _ready() -> void:
    Bomb.all.append(self)
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
    self.trail.reparent(Main.world)
    self.trail.emitting = false
    queue_free()
    Bomb.all.erase(self)

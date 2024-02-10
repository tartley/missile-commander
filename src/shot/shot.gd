class_name Shot extends Node2D

const BangSkyScene:PackedScene = preload("res://src/bang_sky/bang_sky.tscn")

const SPEED := 500
const SIZE := 1.0
# An upward pointing missile shape
const verts: Array[Vector2] = [
    Vector2(0*SIZE, 8*SIZE), # top
    Vector2(1*SIZE, 7*SIZE), # right peak
    Vector2(1*SIZE, -7*SIZE), # top of right fin
    Vector2(2*SIZE, -8*SIZE), # tip of right fin
    Vector2(0*SIZE, -8*SIZE), # center bottom
    Vector2(-2*SIZE, -8*SIZE), # tip of left fin
    Vector2(-1*SIZE, -7*SIZE), # top of left fin
    Vector2(-1*SIZE, 7*SIZE), # left peak
    Vector2(0*SIZE, 8*SIZE), # top
]

var velocity: Vector2
var destination: Vector2

func _ready():
    self.position += self.velocity * 100
    self.velocity = (self.destination - self.position).normalized() * SPEED
    self.rotation = (self.destination - self.position).angle() - PI / 2

func _process(delta: float) -> void:
    var dpos := velocity * delta
    self.position += dpos
    if self.position.distance_squared_to(self.destination) <= dpos.length_squared():
        destination_reached()

func _draw():
    draw_polygon(verts, [Color.BLACK])
    draw_polyline(verts, Color.WHITE, 2.0, true)

func destination_reached():
    # Fix any inaccuracy due to large inter-frame movement
    self.position = self.destination
    # TODO: Once we have a trail, reparent it to Main. see how Missile does it.
    var main := get_parent() as Main
    var bangsky = BangSkyScene.instantiate()
    bangsky.init_from_shot(self.destination)
    main.add_child(bangsky)
    # And this shot is done
    queue_free()

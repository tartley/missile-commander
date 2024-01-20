extends Node2D

const SIZE := 20.0
const verts: Array[Vector2] = [
    Vector2(0.0, -SIZE/2.0),
    Vector2(-SIZE/4.0, +SIZE/2.0),
    Vector2(+SIZE/4.0, +SIZE/2.0),
    Vector2(0.0, -SIZE/2.0),
]

var velocity: Vector2

func set_up_collisions():
    var collision = CollisionShape2D.new()
    collision.shape = ConvexPolygonShape2D.new()
    collision.shape.points = verts
    add_child(collision)

func _ready() -> void:
    $Trail.direction = Vector2(0, 1)
    $Trail.initial_velocity_max = velocity.length()
    $Trail.initial_velocity_min = velocity.length()
    set_up_collisions()

func launch(pos:Vector2, destination:Vector2, speed:float):
    self.position = pos
    self.rotation = (destination - position).angle() + PI / 2
    self.velocity = Vector2.from_angle(rotation - PI / 2) * speed

func _process(delta: float) -> void:
    self.position += velocity * delta

func _draw():
    draw_polyline(verts, Color(.8, 7, .4), 2.0, true)

func on_area_entered(area):
    print(area)
    queue_free()

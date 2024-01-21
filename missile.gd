extends Node2D

@export var Pop:PackedScene

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
    $Trail.initial_velocity_max = velocity.length() / 5
    $Trail.initial_velocity_min = velocity.length() / 5
    set_up_collisions()

func launch(pos:Vector2, destination:Vector2, speed:float):
    self.position = pos
    self.rotation = (destination - position).angle() + PI / 2
    self.velocity = Vector2.from_angle(rotation - PI / 2) * speed

func _process(delta: float) -> void:
    self.position += velocity * delta

func _draw():
    draw_polyline(verts, Color(.8, 7, .4), 2.0, true)

func on_area_entered(area:Area2D):
    # A Missile has collided with the Ground.
    # Reparent our trail onto the ground
    var trail = $Trail
    trail.reparent(area)
    trail.emitting = false
    # Add a Pop, parented to the World.
    # TODO: Hmmm maybe the trail should be parented to the World too?
    # TODO: is it useful to put them in groups, to control what draws in front?
    var world := get_parent()
    var pop = Pop.instantiate()
    pop.position = self.position
    world.add_child(pop)
    # Destroy ourselves.
    queue_free()

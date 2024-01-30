extends Node2D

var Pop:PackedScene = preload("res://src/pop/pop.tscn")

const SIZE := 20.0
# A rightwards pointing triangle
const verts: Array[Vector2] = [
    Vector2(+SIZE/2,       0), # rightmost tip
    Vector2(-SIZE/2, -SIZE/4), # base bottom
    Vector2(-SIZE/2, +SIZE/4), # base top
    Vector2(+SIZE/2,       0), # rightmost tip
]

var velocity: Vector2

signal missile_strike(position:Vector2)

func set_up_collisions():
    var collision = CollisionShape2D.new()
    collision.shape = ConvexPolygonShape2D.new()
    collision.shape.points = verts
    add_child(collision)

func _ready() -> void:
    $Trail.position = Vector2(SIZE/2, 0)
    $Trail.direction = Vector2(-1, 0)
    $Trail.initial_velocity_max = velocity.length() / 5
    $Trail.initial_velocity_min = velocity.length() / 5
    set_up_collisions()

func launch(pos:Vector2, destination:Vector2, speed:float):
    self.position = pos
    self.rotation = (destination - position).angle()
    self.velocity = Vector2.from_angle(rotation) * speed

func _process(delta: float) -> void:
    self.position += velocity * delta

func _draw():
    draw_polygon(verts, [Color.BLACK])
    draw_polyline(verts, Color(.8, 7, .4), 2.0, true)

func on_area_entered(ground:Area2D):
    # A Missile has collided with the Ground.
    # Reparent our trail onto the ground
    var trail = $Trail
    trail.reparent(ground)
    trail.emitting = false
    # Add a Pop, parented to the World.
    var world := get_parent()
    var pop = Pop.instantiate()
    pop.position = self.position
    world.add_child(pop)
    # Let Ground destroy any Cities that are too close
    missile_strike.emit(self.position)
    # And this missile is done
    queue_free()

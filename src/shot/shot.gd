extends Node2D

var Pop:PackedScene = preload("res://src/pop/pop.tscn")

const SIZE := 200.0
const verts: Array[Vector2] = [
    Vector2(0.0, -SIZE/2.0),
    Vector2(-SIZE/8.0, +SIZE/8.0),
    Vector2(+SIZE/8.0, +SIZE/8.0),
    Vector2(0.0, -SIZE/2.0),
]

var velocity: Vector2
var destination: Vector2

func launch(start, dest, speed):
    self.position = start
    self.destination = dest
    self.velocity = Vector2.from_angle((dest - self.position).angle()) * speed
    
func _process(delta: float) -> void:
    self.position += velocity * delta
    if self.position.distance_squared_to(self.destination) <= 100:
        destination_reached()

func _draw():
    draw_polygon(verts, [Color.BLACK])
    draw_polyline(verts, Color.WHITE, 2.0, true)

func destination_reached():
    ## Reparent our trail onto the ground
    #var trail = $Trail
    #trail.reparent(ground)
    #trail.emitting = false
    # Add a Pop, parented to the World.
    var world := get_parent()
    var pop = Pop.instantiate()
    pop.position = self.position
    world.add_child(pop)
    # And this shot is done
    queue_free()

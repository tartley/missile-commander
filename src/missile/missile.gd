extends Node2D

const SIZE := 20.0
# A rightwards pointing triangle
const verts: Array[Vector2] = [
    Vector2(+SIZE/2,       0), # rightmost tip
    Vector2(-SIZE/2, -SIZE/4), # base bottom
    Vector2(-SIZE/2, +SIZE/4), # base top
    Vector2(+SIZE/2,       0), # rightmost tip
]

var Pop:PackedScene = preload("res://src/pop/pop.tscn")

var velocity: Vector2
var target # City or Base or null

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

func on_area_entered(_ground:Area2D):
    ## This Missile has collided with the Ground.

    # We will cease to exist, so reparent our trail onto Main.
    var main := get_parent() as Main
    var trail = $Trail
    trail.reparent(main)
    trail.emitting = false

    # Destroy our target
    if self.target:
        self.target.destroyed = true

    # Add a Pop, parented to Main
    var pop = Pop.instantiate()
    pop.position = self.position
    main.add_child(pop)

    # And this missile is done
    queue_free()

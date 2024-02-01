extends Node2D

const SIZE := 20.0
# A rightwards pointing triangle
const verts: Array[Vector2] = [
    Vector2(+SIZE/2,       0), # rightmost tip
    Vector2(-SIZE/2, -SIZE/4), # base bottom
    Vector2(-SIZE/2, +SIZE/4), # base top
    Vector2(+SIZE/2,       0), # rightmost tip
]

var PopScene:PackedScene = preload("res://src/pop/pop.tscn")
var BangShotScene:PackedScene = preload("res://src/bang_shot/bang_shot.tscn")

var trail: Trail
var velocity: Vector2
var target # City or Base or null

func _ready() -> void:
    self.name = Common.get_unique_name(self)
    # our trail
    self.trail = get_child(0) as Trail # $Trail stops working if its name changes
    trail.position = Vector2(SIZE/2, 0)
    trail.direction = Vector2.LEFT
    var speed := self.velocity.length()
    trail.initial_velocity_max = 250 - speed
    trail.initial_velocity_min = 250 - speed
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

func on_area_entered(other):
    ## This Missile has collided...

    # We will cease to exist, so reparent our trail onto Main.
    var main := get_parent() as Main
    trail.reparent(main)
    trail.emitting = false

    if other is Ground:
        # Destroy our target
        if self.target:
            self.target.destroyed = true
        # Add a Pop, parented to Main
        var pop = PopScene.instantiate()
        pop.position = self.position
        main.add_child(pop)
    elif other is BangShot:
        # Add another BangShot, parented to Main
        var bangshot = BangShotScene.instantiate()
        bangshot.position = self.position
        main.call_deferred("add_child", bangshot)
    else:
        assert(false, "unrecognized collision {0}".format([other]))

    # And this missile is done
    queue_free()

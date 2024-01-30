extends Node2D

const SIZE := 100.0 # world co-ords
const DURATION := 2.0 # seconds

var age:float # seconds
var progress:float # 0..1
var dealt_damage:bool = false # Have we tried destroying nearby targets yet?

func _ready() -> void:
    self.age = 0.0

func _process(delta:float) -> void:
    self.age += delta
    self.progress = self.age / DURATION
    self.position += Vector2(0, -30 * delta)
    if progress < 1.0:
        queue_redraw()
        if not dealt_damage and progress > 0.25:
            # call this once to destroy nearby targets
            destroy_target()
    else:
        queue_free()

func _draw() -> void:
    var color := Color(1, 1 - self.progress, 0, 1 - self.progress)
    draw_circle(Vector2(0, 0), SIZE * self.progress ** 0.3, color)

func destroy_target():
    var tree := get_tree()
    var targets := tree.get_nodes_in_group("cities") + tree.get_nodes_in_group("bases")
    for target in targets:
        if self.position.distance_squared_to(target.position) < 1000:
            target.destroyed = true
    self.dealt_damage = true

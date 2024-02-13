"""
The explosion of a missile striking the ground (not a city or base)
"""
class_name BangGround extends Node2D

const BangGroundScene:PackedScene = preload("res://src/bang_ground/bang_ground.tscn")

const SIZE := 150.0 # world co-ords
const DURATION := 1.0 # seconds

var progress := 0.0 # 0..1

static func create(pos:Vector2):
    var bang = BangGroundScene.instantiate()
    bang.position = pos
    Common.world.add_child(bang)

func _process(delta:float) -> void:
    self.progress += delta / DURATION
    queue_redraw()
    if progress >= 1.0:
        queue_free()

func _draw() -> void:
    var color := Color(1, 1 - self.progress, 0, 1 - self.progress)
    var width := 1 + 20.0 * (1 -progress)
    draw_arc(Vector2.ZERO, SIZE * self.progress ** 0.5, -PI, PI, 16, color, width, true)

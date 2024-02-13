"""
The explosion of a missile striking a city or base.
"""
class_name BangFeature extends Node2D

enum Source {CITY, BASE}

const BangFeatureScene:PackedScene = preload("res://src/bang_feature/bang_feature.tscn")

const SIZE := 250.0 # world co-ords
const DURATION := 3.0 # seconds

var progress: float # 0..1
var color:Color

static func create(pos:Vector2, col:Color) -> BangFeature:
    var bang = BangFeatureScene.instantiate()
    bang.position = pos
    bang.progress = 0.0
    bang.color = col
    Common.main.call_deferred("add_child", bang)
    return bang

func _ready() -> void:
    self.name = Common.get_unique_name(self)

func _process(delta:float) -> void:
    self.progress += delta / DURATION
    queue_redraw()
    if progress >= 1.0:
        queue_free()

func _draw() -> void:
    self.color.a = 1 - self.progress
    for i in range(4):
        draw_arc(Vector2.ZERO, SIZE * (i + 1) * self.progress ** 0.5, -PI, PI, 16, color, (4 - i) * 6.0, true)

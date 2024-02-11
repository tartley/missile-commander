"""
The explosion of a missile striking a city or base.
"""
extends Node2D

const SIZE := 250.0 # world co-ords
const DURATION := 3.0 # seconds

var progress:float # 0..1

func _ready() -> void:
    self.name = Common.get_unique_name(self)

func _process(delta:float) -> void:
    self.progress += delta / DURATION
    queue_redraw()
    if progress >= 1.0:
        queue_free()

func _draw() -> void:
    var color := Color(1, 1 - self.progress / 2, 1, 1 - self.progress)
    for i in range(4):
        draw_arc(Vector2.ZERO, SIZE * (i + 1) * self.progress ** 0.5, -PI, PI, 16, color, (4 - i) * 6.0, true)

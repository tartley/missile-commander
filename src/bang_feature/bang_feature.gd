"""
The explosion of a missile striking a city or base.
"""
extends Node2D

const SIZE := 250.0 # world co-ords
const DURATION := 3.0 # seconds

var progress:float # 0..1
var on:bool

func _ready() -> void:
    self.name = Common.get_unique_name(self)
    self.on = false

func _process(delta:float) -> void:
    self.progress += delta / DURATION
    queue_redraw()
    if progress >= 1.0:
        queue_free()

func _draw() -> void:
    var color:Color
    if self.on:
        color = Color(1, 1 - self.progress / 2, 1, 1 - self.progress)
    else:
        color = Color.BLACK
    self.on = not self.on
    # var width := 1 + 20.0 * (1 - progress)
    for i in range(4):
        draw_arc(Vector2.ZERO, SIZE * i * self.progress ** 0.5, -PI, PI, 16, color, 3.0, true)

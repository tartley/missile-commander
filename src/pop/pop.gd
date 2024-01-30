extends Node2D

const SIZE := 100.0 # world co-ords
const DURATION := 2.0 # seconds

var age:float # seconds
var progress:float # 0..1

func _ready() -> void:
    self.age = 0.0

func _process(delta:float) -> void:
    self.age += delta
    self.progress = self.age / DURATION
    self.position += Vector2(0, -30 * delta)
    if progress < 1.0:
        queue_redraw()
    else:
        queue_free()

func _draw() -> void:
    var color := Color(1, 1 - self.progress, 0, 1 - self.progress)
    draw_circle(Vector2(0, 0), SIZE * self.progress ** 0.3, color)

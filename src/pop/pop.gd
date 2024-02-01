extends Node2D

const SIZE := 150.0 # world co-ords
const DURATION := 1.0 # seconds

var age:float # seconds
var progress:float # 0..1

func _ready() -> void:
    self.name = Common.get_unique_name(self)
    self.age = 0.0

func _process(delta:float) -> void:
    self.age += delta
    self.progress = self.age / DURATION
    queue_redraw()
    if progress >= 1.0:
        queue_free()

func _draw() -> void:
    var color := Color(1, 1 - self.progress, 0, 1 - self.progress)
    var width := 1 + 20.0 * (1 -progress)
    draw_arc(Vector2.ZERO, SIZE * self.progress ** 0.5, -PI, PI, 16, color, width, true)

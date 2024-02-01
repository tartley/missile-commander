class_name BangShot extends Node2D

const SIZE := 150.0 # world co-ords
const DURATION := 2.0 # seconds

var age:float # seconds
var progress:float # 0..1
var size:float = 0.0

func _ready() -> void:
    self.name = Common.get_unique_name(self)
    self.age = 0.0

func _process(delta:float) -> void:
    self.age += delta
    self.progress = self.age / DURATION
    self.size = SIZE * max(0.01, sin(progress * PI))
    $CollisionShape2D.shape.radius = self.size
    queue_redraw()
    if progress >= 1.0:
        queue_free()

func _draw() -> void:
    var color := Color(
        1 - self.progress, # red
        1 - min(1, self.progress * 2), # green
        1, # blue,
        0.5, # alpha
    )
    draw_circle(Vector2.ZERO, self.size, color)

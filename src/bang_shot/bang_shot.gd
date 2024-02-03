class_name BangShot extends Node2D

const SIZE := 50.0 # world co-ords
const DURATION := 2.5 # seconds

var age:float # seconds
var progress:float # 0..1
var size:float = 0.0
# 0 from detonation of a shot.
var generation:float # 0 from detonation of a shot. Increments for chain reactions.

func _ready() -> void:
    self.name = Common.get_unique_name(self)
    self.age = 0.0

func init_from_shot():
    self.generation = 0

func _process(delta:float) -> void:
    self.age += delta
    self.progress = self.age / DURATION
    self.size = SIZE * maxf(0.01, sin(progress * PI) * (3 + sin(progress * PI * self.generation)))
    $CollisionShape2D.shape.radius = self.size
    queue_redraw()
    if progress >= 1.0:
        queue_free()

func _draw() -> void:
    var color := Color(
        0.5 + 0.5 * sin(-PI/2 + progress * PI / 2), # red
        maxf(0.0, cos(progress * PI * 1.5)), # green
        1.0, # blue,
        0.75 - self.progress / 2, # alpha
    )
    draw_circle(Vector2.ZERO, self.size, color)

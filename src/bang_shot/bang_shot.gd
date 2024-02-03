class_name BangShot extends Node2D

const MAX_SIZE := 175.0 # world co-ords
const DURATION := 2.5 # seconds

var age:float # seconds
var progress:float # 0..1
var size:float = 0.0
var color_offset:float = 0.0

func _ready() -> void:
    self.name = Common.get_unique_name(self)
    self.age = 0.0
    $CollisionShape2D.shape.radius = MAX_SIZE

func init(pos:Vector2, offset:float=0.0) -> void:
    self.position = pos
    self.color_offset = offset

func _process(delta:float) -> void:
    self.age += delta
    self.progress = self.age / DURATION
    self.size = MAX_SIZE * (0.1 + 0.9 * sin(progress * PI))
    queue_redraw()
    if progress >= 1.0:
        queue_free()

func _draw() -> void:
    var color := Color(
        maxf(1 - progress * 2, progress * 2 - 1.5), # red
        1 - progress * 2, # green
        1.0, # blue,
        0.75 - self.progress / 2, # alpha
    )
    draw_circle(Vector2.ZERO, self.size, color)
    draw_arc(Vector2.ZERO, MAX_SIZE, -PI, +PI, 16, Color.DARK_MAGENTA)


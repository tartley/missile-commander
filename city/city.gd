extends Node2D

const verts: Array[Vector2] = [
    Vector2(-50, 0),
    Vector2(-50, 20),
    Vector2(-30, 20),
    Vector2(-30, 30),
    Vector2(-10, 30),
    Vector2(-10, 50),
    Vector2(10, 50),
    Vector2(10, 20),
    Vector2(30, 20),
    Vector2(30, 30),
    Vector2(50, 30),
    Vector2(50, 0),
]

func _ready() -> void:
    rotation = position.angle() - PI / 2

func _draw():
    draw_polyline(verts, Color(1, .3, .3), 4.0, true)

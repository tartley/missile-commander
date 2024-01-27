extends Node2D

const SIZE := 40.0
const verts:Array[Vector2] = [
    Vector2(+SIZE/8, -SIZE/8),
    Vector2(+SIZE/8, SIZE),
    Vector2(-SIZE/8, SIZE),
    Vector2(-SIZE/8, -SIZE/8),
]

func _draw():
    draw_polyline(self.verts, Color.YELLOW)

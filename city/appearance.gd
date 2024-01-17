extends Node2D

# must be populated by parent
var verts:Array[Vector2]

func _draw():
    draw_polyline(verts, Color(1, .3, .3), 4.0, true)

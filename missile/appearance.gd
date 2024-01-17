extends Node2D

# must be populated by parent
var verts:Array[Vector2]

func _draw():
    draw_polyline(verts, Color(.7, 1, .6), 2.0, true)

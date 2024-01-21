extends Node2D

const COLUMNS := 7
const SIZE := 100.0

var verts: Array[Vector2]

func get_verts() -> Array[Vector2]:
    var retval: Array[Vector2] = []
    var heights:Array[int] = [20, 30, 40, 40, 50, 50, 60]
    heights.shuffle()
    retval.append(Vector2(-SIZE/2.0, 0))
    for column in range(COLUMNS):
        retval.append(Vector2(-SIZE/2.0 + column * SIZE/COLUMNS, heights[column]))
        retval.append(Vector2(-SIZE/2.0 + (column + 1) * SIZE/COLUMNS, heights[column]))
    retval.append(Vector2(+SIZE/2.0, 0))
    return retval

func _init():
    self.verts = get_verts()

func _ready() -> void:
    self.rotation = position.angle() - PI / 2

func _draw():
    draw_polyline(verts, Color(1, .3, .3), 4.0, true)

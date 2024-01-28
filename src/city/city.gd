extends Node2D

const COLUMNS := 7
const SIZE := 100.0

var verts:Array[Vector2]
var color:Color
var destroyed: bool:
    set(value):
        if value:
            self.verts = get_destroyed_verts()
            self.color = Color(.3, .3, .3)
        else:
            self.verts = get_regular_verts()
            self.color = Color.RED
        destroyed = value
        self.queue_redraw()

func get_regular_verts():
    var retval: Array[Vector2] = []
    var heights:Array[int] = [20, 20, 30, 40, 40, 50, 50]
    heights.shuffle()
    retval.append(Vector2(-SIZE/2.0, 0))
    for column in range(COLUMNS):
        retval.append(Vector2(-SIZE/2.0 + column * SIZE/COLUMNS, heights[column] * SIZE/100.0))
        retval.append(Vector2(-SIZE/2.0 + (column + 1) * SIZE/COLUMNS, heights[column] * SIZE/100.0))
    retval.append(Vector2(+SIZE/2.0, 0))
    return retval

func get_destroyed_verts():
    var retval: Array[Vector2] = []
    var heights:Array[int] = [10, 10, 20, 20, 20, 30, 30]
    heights.shuffle()
    retval.append(Vector2(-SIZE/2.0, 0))
    for column in range(COLUMNS):
        retval.append(Vector2(-SIZE/2.0 + column * SIZE/COLUMNS, heights[column]))
    retval.append(Vector2(+SIZE/2.0, 0))
    return retval

func _init():
    self.destroyed = false
    
func _draw():
    draw_polygon(self.verts, [Color.BLACK])
    draw_polyline(self.verts, self.color, 2.0, true)

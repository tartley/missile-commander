extends Node2D

const SIZE := 50.0

const regular_verts:Array[Vector2] = [
    Vector2(0, -SIZE/2),
    Vector2(-SIZE/2, 0),
    Vector2(0, SIZE/4),
    Vector2(+SIZE/2, 0),
    Vector2(0, -SIZE/2),    
]
const destroyed_verts:Array[Vector2] = [
    Vector2(0, -SIZE/2),
    Vector2(-SIZE/2, 0),
    Vector2(0, 0),
    Vector2(+SIZE/2, 0),
    Vector2(0, -SIZE/2),    
]

var verts:Array[Vector2]
var color:Color
var destroyed: bool:
    set(value):
        if value:
            self.verts = destroyed_verts
            self.color = Color(.3, .3, .3)
        else:
            self.verts = regular_verts
            self.color = Color.YELLOW
        destroyed = value
        self.queue_redraw()

func _init():
    self.destroyed = false
    
func _draw():
    draw_polygon(self.verts, [Color.BLACK])
    draw_polyline(self.verts, self.color, 4.0, true)

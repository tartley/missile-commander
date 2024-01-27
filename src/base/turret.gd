extends Node2D

const SIZE := 60.0
const verts:Array[Vector2] = [
    Vector2(+SIZE/8, -SIZE/8),
    Vector2(+SIZE/8, SIZE),
    Vector2(-SIZE/8, SIZE),
    Vector2(-SIZE/8, -SIZE/8),
]
var color:Color

var destroyed:bool:
    set(value):
        if value:
            self.color = Color(.3, .3, .3)
        else:
            self.color = Color.YELLOW
        self.queue_redraw()

func _draw():
    draw_polyline(self.verts, self.color, 3.0)

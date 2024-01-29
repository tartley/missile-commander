extends Node2D

const SIZE := 40.0
const verts:Array[Vector2] = [
    Vector2(+SIZE/8, -SIZE/8),
    Vector2(+SIZE/8, SIZE),
    Vector2(-SIZE/8, SIZE),
    Vector2(-SIZE/8, -SIZE/8),
]
const fore := Color.YELLOW
const fill := Color.BLACK
const fore_destroyed := Color(.3, .3, .3)

var color:Color

var destroyed:bool:
    set(value):
        if value:
            self.color = fore_destroyed
        else:
            self.color = fore
        self.queue_redraw()

func _draw():
    draw_polygon(self.verts, [fill])
    draw_polyline(self.verts, self.color, 3.0)

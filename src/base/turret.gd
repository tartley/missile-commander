extends Node2D

const SIZE := 300.0
# A rectangular gun turret, pointing right
const verts:Array[Vector2] = [
    Vector2(-SIZE/8, +SIZE/8), # left(base) top
    Vector2(+SIZE,   +SIZE/8), # right(tip) top
    Vector2(+SIZE,   -SIZE/8), # right(tip) bottom
    Vector2(-SIZE/8, -SIZE/8), # left(base) bottom 
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

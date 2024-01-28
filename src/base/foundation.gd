extends Node2D

const SIZE := 80.0
const original_verts:Array[Vector2] = [
    Vector2(0, -SIZE/2), # bottom
    Vector2(-SIZE/2, 0), # left    
    Vector2(-SIZE/4, 0), # support left base
    Vector2(-SIZE/4, SIZE/4), # support left top
    Vector2(+SIZE/4, SIZE/4), # suppport right top
    Vector2(+SIZE/4, 0), # support right base
    Vector2(+SIZE/2, 0), # right
    Vector2(0, -SIZE/2), # bottom
]

var verts:Array[Vector2]
var color:Color
var destroyed: bool:
    set(value):
        if not value:
            self.verts = original_verts.duplicate()
            self.color = Color.YELLOW
        else:
            self.color = Color.DIM_GRAY
        destroyed = value
        self.queue_redraw()

# We use a reference to the mouse to swivel our turrets towards it
var mouse:Node2D
    
func _draw():
    draw_polygon(self.verts, [Color.BLACK])
    draw_polyline(self.verts, self.color, 3.0)

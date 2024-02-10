extends Node2D

const SIZE := 100.0
const FORE := Color.YELLOW
const FORE_DESTROYED := Color(.3, .3, .3)
const FILL := Color.BLACK

var destroyed:bool = false
var verts:Array[Vector2]
var color:Color

func _init():
    self.verts = get_verts()
    self.color = FORE

func _draw():
    draw_polygon(self.verts, [FILL])
    draw_polyline(self.verts, self.color, 3.0)

func get_verts() -> Array[Vector2]:
    # A rectangular gun turret, pointing +x
    return [
        Vector2(     0,  SIZE/16), # left(base) top
        Vector2(SIZE/2,  SIZE/16), # right(tip) top
        Vector2(SIZE/2, -SIZE/16), # right(tip) bottom
        Vector2(     0, -SIZE/16), # left(base) bottom
    ]

func destroy() -> void:
    self.color = FORE_DESTROYED
    if not self.destroyed:
        self.queue_redraw()
    self.destroyed = true

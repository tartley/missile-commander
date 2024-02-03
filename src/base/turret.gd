extends Node2D

# TODO turret and foundation have a couple of identical constructs

const FORE := Color.YELLOW
const FORE_DESTROYED := Color(.3, .3, .3)
const FILL := Color.BLACK

var size:float
var destroyed:bool:
    set(value):
        destroyed = value
        self.queue_redraw()

func get_verts() -> Array[Vector2]:
    # A rectangular gun turret, pointing right
    return [
        Vector2(      0, +size/16), # left(base) top
        Vector2(+size/2, +size/16), # right(tip) top
        Vector2(+size/2, -size/16), # right(tip) bottom
        Vector2(      0, -size/16), # left(base) bottom
    ]

func get_color() -> Color:
    if self.destroyed:
        return FORE_DESTROYED
    else:
        return FORE

func _draw():
    draw_polygon(get_verts(), [FILL])
    draw_polyline(get_verts(), get_color(), 3.0)

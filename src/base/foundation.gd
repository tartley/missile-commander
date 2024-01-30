extends Node2D

# TODO turret and foundation have a couple of identical constructs

const FORE := Color.YELLOW
const FORE_DESTROYED := Color(.3, .3, .3)
const FILL := Color.BLACK

var size:float
var destroyed: bool:
    set(value):
        destroyed = value
        self.queue_redraw()

func get_semicircle(center, radius) -> Array[Vector2]:
    const SEGMENTS := 5
    var vs:Array[Vector2] = []
    for segment in range(SEGMENTS + 1):
        var angle:float = PI - PI * segment / SEGMENTS
        var vert:Vector2 = center + Vector2.from_angle(angle) * radius
        vs.append(vert)
    return vs

func get_verts() -> Array[Vector2]:
    var vs:Array[Vector2] = []
    vs.append_array([
        Vector2(-size/4, 0), # support left base
        Vector2(-size/4, size/4), # support left top
    ])
    vs.append_array(get_semicircle(self.position + Vector2(0, size/4), size/4))
    vs.append_array([
        Vector2(+size/4, size/4), # suppport right top
        Vector2(+size/4, 0), # support right base
    ])
    return vs

func get_color() -> Color:
    if self.destroyed:
        return FORE_DESTROYED
    else:
        return FORE

func _draw():
    draw_polygon(get_verts(), [FILL])
    draw_polyline(get_verts(), get_color(), 3.0, true)

extends Node2D

const SIZE := 80.0

var verts:Array[Vector2]
var color:Color
var destroyed: bool:
    set(value):
        if not value:
            self.verts = get_verts()
            self.color = Color.YELLOW
        else:
            self.color = Color.DIM_GRAY
        destroyed = value
        self.queue_redraw()

# We use a reference to the mouse to swivel our turrets towards it
var mouse:Node2D

# TODO: how do verts get initialized at first anyhow?

func get_semicircle(center, radius) -> Array[Vector2]:
    const SEGMENTS := 4
    var vs:Array[Vector2] = []
    for segment in range(SEGMENTS + 1):
        var angle:float = PI - PI * segment / SEGMENTS
        var vert:Vector2 = center + Vector2.from_angle(angle) * radius
        vs.append(vert)
    return vs

func get_verts() -> Array[Vector2]:
    var vs:Array[Vector2] = []
    vs.append_array([
        Vector2(-SIZE/4, 0), # support left base
        Vector2(-SIZE/4, SIZE/4), # support left top
    ])
    vs.append_array(get_semicircle(self.position + Vector2(0, SIZE/4), SIZE/4))
    vs.append_array([
        Vector2(+SIZE/4, SIZE/4), # suppport right top
        Vector2(+SIZE/4, 0), # support right base
    ])
    return vs

func _draw():
    draw_polygon(self.verts, [Color.BLACK])
    draw_polyline(self.verts, self.color, 3.0)

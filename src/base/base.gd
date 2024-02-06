extends Node2D

const SIZE := 100.0
const FORE := Color.YELLOW
const FORE_DESTROYED := Color(.3, .3, .3)
const FILL := Color.BLACK

var ShotScene:PackedScene = preload("res://src/shot/shot.tscn")

# We use a reference to the mouse to swivel our turret towards it
var mouse:Node2D

var destroyed: bool:
    set(value):
        $Turret.destroyed = value
        destroyed = value
        self.queue_redraw()

func _ready():
    self.name = Common.get_unique_name(self)
    self.destroyed = false
    $Turret.size = SIZE
    $Turret.position = Vector2(0, SIZE / 4)
    self.add_to_group("bases")

func launch(dest:Vector2):
    var shot = ShotScene.instantiate()
    shot.position = to_global($Turret.position)
    shot.destination = dest
    return shot

# process

func _process(_delta:float):
    if not self.destroyed:
        var global = to_global($Turret.position)
        var relative = mouse.position - Vector2(global.x, global.y)
        $Turret.rotation = relative.angle() - self.rotation

# draw

func get_semicircle(center, radius, segments) -> Array[Vector2]:
    var vs:Array[Vector2] = []
    for segment in range(segments + 1):
        var angle:float = PI - PI * segment / segments
        var vert:Vector2 = center + Vector2.from_angle(angle) * radius
        vs.append(vert)
    return vs

func get_verts() -> Array[Vector2]:
    const DOME_SEGMENTS := 5
    var vs:Array[Vector2] = []
    vs.append_array([
        Vector2(-SIZE/4, 0), # support left base
        Vector2(-SIZE/4, SIZE/4), # support left top
    ])
    vs.append_array(get_semicircle(Vector2(0, SIZE/4), SIZE/4, DOME_SEGMENTS))
    vs.append_array([
        Vector2(+SIZE/4, SIZE/4), # suppport right top
        Vector2(+SIZE/4, 0), # support right base
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

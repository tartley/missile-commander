class_name Base extends Node2D

const ShotScene:PackedScene = preload("res://src/shot/shot.tscn")

const SIZE := 75.0
const FORE := Color.YELLOW
const FORE_DESTROYED := Color(.3, .3, .3)
const FILL := Color.BLACK

# We use a reference to the mouse to swivel our turret towards it
var mouse:Node2D
var verts:Array[Vector2] = get_verts()
var color:Color = FORE
var destroyed:bool = false

func _ready():
    $Turret.size = SIZE
    $Turret.position = Vector2(0, SIZE * 3/8)
    self.add_to_group("bases")

func _process(_delta:float):
    if not self.destroyed:
        var global = to_global($Turret.position)
        var relative = mouse.position - Vector2(global.x, global.y)
        $Turret.rotation = relative.angle() - self.rotation

func _draw():
    draw_polygon(self.verts, [FILL])
    draw_polyline(self.verts, self.color, 2.0, true)

func get_dome(center, radius, segments) -> Array[Vector2]:
    var vs:Array[Vector2] = []
    for segment in range(segments + 1):
        var angle:float = PI * 3/4 - PI/2 * segment / segments
        var vert:Vector2 = center + Vector2.from_angle(angle) * radius
        vs.append(vert)
    return vs

func get_verts() -> Array[Vector2]:
    const DOME_SEGMENTS := 10
    var vs:Array[Vector2] = []
    vs.append_array([
        Vector2(-SIZE*5/8, 0), # support left base
        Vector2(-SIZE*3/8, SIZE/4), # support left corner
        Vector2(-SIZE*2/8, SIZE/4), # left edge of dome
    ])
    vs.append_array(get_dome(Vector2(0, SIZE/4), SIZE/4, DOME_SEGMENTS))
    vs.append_array([
        Vector2(+SIZE*2/8, SIZE/4), # left edge of dome
        Vector2(+SIZE*3/8, SIZE/4), # suppport right corner
        Vector2(+SIZE*5/8, 0), # support right base
    ])
    return vs

func fire(dest:Vector2):
    if not self.destroyed:
        if $Ammo.count > 0:
            $Ammo.decrement()
            var shot:Shot = ShotScene.instantiate()
            shot.position = to_global($Turret.position)
            shot.destination = dest
            Common.world.add_child(shot)

func destroy():
    $Turret.destroy()
    $Ammo.destroy()
    self.color = FORE_DESTROYED
    if not self.destroyed:
        BangFeature.create(self.position, FORE)
        self.queue_redraw()
    else:
        BangGround.create(self.position)
    self.destroyed = true

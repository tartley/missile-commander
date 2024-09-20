class_name City extends Node2D

const COLUMNS := 7
const SIZE := 100.0
const FORE := Color.RED
const FORE_DESTROYED := Color(.3, .3, .3)
const FILL := Color.BLACK

static var all:Array[City] = []

var verts:Array[Vector2]
var color:Color
var destroyed:bool

signal city_destroyed

static func remaining() -> int:
    var r:int = 0
    for city in City.all:
        if not city.destroyed:
            r += 1
    return r

func _ready():
    self.reset()
    self.all.append(self)

func _draw():
    draw_polygon(self.verts, [FILL])
    draw_polyline(self.verts, self.color, 2.0, true)

func get_regular_verts() -> Array[Vector2]:
    var retval: Array[Vector2] = []
    var heights:Array[int] = [20, 25, 30, 35, 40, 45, 50]
    heights.shuffle()
    retval.append(Vector2(-SIZE/2.0, 0))
    for column in range(COLUMNS):
        retval.append(Vector2(-SIZE/2.0 + column * SIZE/COLUMNS, heights[column] * SIZE/100.0))
        retval.append(Vector2(-SIZE/2.0 + (column + 1) * SIZE/COLUMNS, heights[column] * SIZE/100.0))
    retval.append(Vector2(+SIZE/2.0, 0))
    return retval

func get_destroyed_verts():
    var retval: Array[Vector2] = []
    var heights:Array[int] = [10, 10, 20, 20, 20, 30, 30]
    heights.shuffle()
    retval.append(Vector2(-SIZE/2.0, 0))
    for column in range(COLUMNS):
        retval.append(Vector2(-SIZE/2.0 + column * SIZE/COLUMNS, heights[column]))
    retval.append(Vector2(+SIZE/2.0, 0))
    return retval

func reset():
    if not verts or destroyed:
        self.verts = get_regular_verts()
        self.color = FORE
        self.destroyed = false
        self.queue_redraw()

func destroy():
    self.verts = get_destroyed_verts()
    if not self.destroyed:
        BangFeature.create(self.position, FORE)
        self.color = FORE_DESTROYED
        self.destroyed = true
        self.queue_redraw()
        self.city_destroyed.emit()
    else:
        BangGround.create(self.position)

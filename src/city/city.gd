extends Node2D

const BangFeatureScene:PackedScene = preload("res://src/bang_feature/bang_feature.tscn")

const COLUMNS := 7
const SIZE := 100.0
const FORE := Color.RED
const FORE_DESTROYED := Color(.3, .3, .3)
const FILL := Color.BLACK

var verts := get_regular_verts()
var color := FORE
var destroyed := false

func _ready():
    self.name = Common.get_unique_name(self)
    self.destroyed = false
    self.add_to_group("cities")

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

func create_bangfeature():
    var main:Main = get_tree().root.get_node("Main")
    var bang = BangFeatureScene.instantiate()
    bang.position = self.position
    main.call_deferred("add_child", bang)

func destroy():
    self.verts = get_destroyed_verts()
    self.color = FORE_DESTROYED
    if not self.destroyed:
        self.create_bangfeature()
        self.queue_redraw()
    self.destroyed = true

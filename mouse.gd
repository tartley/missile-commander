extends Node2D

# mouse can move around in these world co-ordinates
var _world_polar: Vector2 # Mouse position, as (angle from up in radians, height above planet surface)
var extent_polar: Rect2

var world_polar: Vector2:
    get:
        return _world_polar
    set(value):
        _world_polar = value
        position = Vector2(_world_polar.x, _world_polar.y + %Ground.RADIUS)

func _ready():
    extent_polar = Rect2(-%Ground.ALPHA, 0, %Ground.ALPHA * 2.0, get_viewport_rect().size.y)
    
func _notification(what):
    match what:
        MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
            world_polar = extent_polar.get_center()
        MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent):
    if event is InputEventMouseMotion:
        world_polar.x += event.relative[0]
        world_polar.y -= event.relative[1]

func _draw():
    var verts: Array[Vector2] = [
        Vector2(-60, 0),
        Vector2(-20, 0),
        Vector2(20, 0),
        Vector2(60, 0),
        Vector2(0, -44),
        Vector2(0, -20),
        Vector2(0, 20),
        Vector2(0, 44),
    ]
    draw_multiline(verts, Color(.6, .8, .7), 8.0)

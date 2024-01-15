extends Node2D

# mouse can move around in these world co-ordinates
var extent_polar: Rect2

# Mouse position, as (angle from up in radians, height above planet surface)
var world_polar: Polar:
    get:
        return world_polar
    set(value):
        world_polar = value
        position = world_polar.cartesian()

func constrain(initial: Polar, extent: Rect2) -> void:
    "Modifies 'initial' in-place to lie within 'extent'"
    initial.angle = max(initial.angle, extent.position.x)
    initial.radius = max(initial.radius, extent.position.y)
    initial.angle = min(initial.angle, extent.end.x)
    initial.radius = min(initial.radius, extent.end.y)

func _ready():
    extent_polar = Rect2(-%Ground.PLANET_ANGLE, %Ground.RADIUS + get_viewport_rect().size.y * 0.11, %Ground.PLANET_ANGLE * 2.0, get_viewport_rect().size.y * 18/10)
    
func _notification(what):
    match what:
        MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
            world_polar = Polar.new(0, %Ground.RADIUS + get_viewport_rect().size.y * 5/10)
        MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
   
func _input(event: InputEvent):
    if event is InputEventMouseMotion:
        world_polar.angle += event.relative.x * 0.00012
        world_polar.radius -= event.relative.y * 4
        constrain(world_polar, extent_polar)
        position = world_polar.cartesian()

func _draw():
    var verts: Array[Vector2] = [
        Vector2(-120, 0),
        Vector2(-40, 0),
        Vector2(40, 0),
        Vector2(120, 0),
        Vector2(0, -88),
        Vector2(0, -40),
        Vector2(0, 40),
        Vector2(0, 88),
    ]
    draw_multiline(verts, Color(.5, .6, .7), 8.0)

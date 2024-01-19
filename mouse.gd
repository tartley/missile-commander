extends Node2D

# mouse can move around in these world co-ordinates
# TODO would be nice if this used a Polar extent instead of cartesian Rect2
var extent_polar: Rect2

# Mouse position normalized to lie within (-1 to 1, 0 to 1)
var normalized: Vector2

# Mouse position, as (angle from up in radians, height above planet surface)
var world_polar:= Polar.new(0, 0):
    set(value):
        world_polar = constrain(value, extent_polar)
        position = world_polar.cartesian()
        normalized = normalize(world_polar, extent_polar)

func _ready():
    extent_polar = Rect2(
        -%Ground.PLANET_ANGLE * 0.99,
        %Ground.RADIUS + get_viewport_rect().size.y * 0.11,
        %Ground.PLANET_ANGLE * 1.98,
        get_viewport_rect().size.y * .89
    )
    # Dupes behavior of "focus in" event, since we don't get that event on MacOS
    capture_mouse()

func constrain(initial: Polar, extent: Rect2) -> Polar:
    "Return 'initial', modified to lie within 'extent'"
    return Polar.new(
        min(extent.end.x, max(extent.position.x, initial.angle)),
        min(extent.end.y, max(extent.position.y, initial.radius)),
    )

func normalize(point:Polar, extent:Rect2) -> Vector2:
    '''Convert point's position within extent to range x:(-1 to +1), y:(0 to 1)'''
    return Vector2(
        point.angle / (extent.end.x - extent.position.x),
        (point.radius - extent.position.y) / (extent.end.y - extent.position.y),
    )

func capture_mouse():
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    world_polar = Polar.new(0, 0)

func _notification(what):
    match what:
        MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
            capture_mouse()
        MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent):
    if event is InputEventMouseMotion:
        world_polar = Polar.new(
            world_polar.angle + event.relative.x * 0.00012,
            world_polar.radius - event.relative.y * 2,
        )

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
    draw_multiline(verts, Color(.5, .6, .7), 4.0)

extends Node2D

# mouse can move around in these world co-ordinates
# TODO would be nice if this used a Polar extent instead of cartesian Rect2
var extent_polar:Rect2

# Mouse current position in polar world co-ordinates
var polar:Geometry.Polar:
    set(value):
        # constrain new mouse position to lie within maximum extent
        value.angle = min(extent_polar.end.x, max(extent_polar.position.x, value.angle))
        value.radius = min(extent_polar.end.y, max(extent_polar.position.y, value.radius))
        polar = value
        position = polar.radius * Vector2.from_angle(PI/2 - polar.angle)
        normalized = normalize(polar.angle, polar.radius, extent_polar)

# normalized mouse position to lie within (-1 to 1, 0 to 1)
var normalized:Vector2

func normalize(angle:float, radius:float, extent:Rect2) -> Vector2:
    '''Convert polar co-ord's position within polar extent to range x:(-1 to +1), y:(0 to 1)'''
    return Vector2(
        angle / (extent.end.x - extent.position.x),
        (radius - extent.position.y) / (extent.end.y - extent.position.y),
    )

func _ready():
    extent_polar = Rect2(
        -%Ground.PLANET_ANGLE * 0.99,
        %Ground.RADIUS + get_viewport_rect().size.y * 0.11,
        %Ground.PLANET_ANGLE * 1.98,
        get_viewport_rect().size.y * .89
    )
    # Dupes behavior of "focus in" event, since we don't get that event on startup on MacOS
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    polar = Geometry.Polar.new(0, 0)

func _notification(what):
    match what:
        MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
        MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent):
    if event is InputEventMouseMotion:
        polar = Geometry.Polar.new(
            polar.angle + event.relative.x * 0.00012,
            polar.radius - event.relative.y * 2,
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

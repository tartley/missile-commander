class_name Cursor extends Node2D

# Crosshair cursor
const verts: Array[Vector2] = [
    Vector2(-60, 0), Vector2(-20, 0),
    Vector2(+60, 0), Vector2(+20, 0),
    Vector2(0, -44), Vector2(0, -20),
    Vector2(0, +44), Vector2(0, +20),
]

# Cursor can move around in these world co-ordinates
var extent_polar:Geometry.PolarExtent

# Current position in polar world co-ordinates
var polar:Geometry.Polar:
    set(value):
        # constrain new position to lie within maximum extent
        value.constrain(extent_polar)
        polar = value
        position = polar.radius * Vector2.from_angle(-PI/2 + polar.angle)
        rotation = polar.angle
        normalized = extent_polar.normalize(polar)

# normalized position to lie within (-1 to 1, 0 to 1)
var normalized:Vector2

func _ready():
    extent_polar = Geometry.PolarExtent.new(
        Geometry.Polar.new(
            Common.PLANET_ANGLE * -0.99,
            Common.RADIUS + get_viewport_rect().size.y * 0.10,
        ),
        Geometry.Polar.new(
            Common.PLANET_ANGLE * +0.99,
            Common.RADIUS + get_viewport_rect().size.y * 1.0,
        ),
    )
    # Dupes behavior of "focus in" event, since we don't get that event on startup on MacOS
    # Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    polar = Geometry.Polar.new(0, 0)

func _notification(what):
    match what:
        MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
            # First time in here, Input.mouse_mode is 2 (captured already),
            # and setting it causes no problems.
            # Next time windows gains focus, we enter here, and value is 0 (visible)
            # Causing a "NO GRAB" error.
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
    draw_multiline(verts, Color.BLACK, 6.0)
    draw_multiline(verts, Color(.5, .6, .7), 4.0)

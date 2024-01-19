extends Node2D

# mouse can move around in these world co-ordinates
var extent_polar:Geometry.PolarExtent

# Mouse current position in polar world co-ordinates
var polar:Geometry.Polar:
    set(value):
        # constrain new mouse position to lie within maximum extent
        # TODO move this to Geometry.PolarExtent.constrain
        value.angle = min(extent_polar.end.angle, max(extent_polar.start.angle, value.angle))
        value.radius = min(extent_polar.end.radius, max(extent_polar.start.radius, value.radius))
        polar = value
        position = polar.radius * Vector2.from_angle(PI/2 - polar.angle)
        normalized = normalize(polar, extent_polar)

# normalized mouse position to lie within (-1 to 1, 0 to 1)
var normalized:Vector2

# TODO move this to geometry
func normalize(coord:Geometry.Polar, extent:Geometry.PolarExtent) -> Vector2:
    '''Convert polar co-ord's position within polar extent to range x:(-1 to +1), y:(0 to 1)'''
    return Vector2(
        coord.angle / (extent.end.angle - extent.start.angle),
        (coord.radius - extent.start.radius) / (extent.end.radius - extent.start.radius),
    )

func _ready():
    extent_polar = Geometry.PolarExtent.new(
        Geometry.Polar.new(
            %Ground.PLANET_ANGLE * -0.99,
            %Ground.RADIUS + get_viewport_rect().size.y * 0.11,
        ),
        Geometry.Polar.new(
            %Ground.PLANET_ANGLE * +0.99,
            %Ground.RADIUS + get_viewport_rect().size.y * 1.0,
        ),
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

extends Node2D

# mouse can move around in these world co-ordinates
# TODO would be nice if this used a Polar extent instead of cartesian Rect2
var extent_polar: Rect2

# Mouse current position in polar world co-ordinates
# Should only be set using set_polar, to keep position & normalized in sync
var polar := Polar.new(0, 0)

# normalized mouse position to lie within (-1 to 1, 0 to 1)
var normalized : Vector2

func normalize(angle:float, radius:float, extent:Rect2) -> Vector2:
    '''Convert polar co-ord's position within polar extent to range x:(-1 to +1), y:(0 to 1)'''
    return Vector2(
        angle / (extent.end.x - extent.position.x),
        (radius - extent.position.y) / (extent.end.y - extent.position.y),
    )

func set_polar(new_angle:float, new_radius:float) -> void:
    '''Given a new mouse cursor position in polar co-ords, constrain them, and update derived values'''
    polar.angle = min(extent_polar.end.x, max(extent_polar.position.x, new_angle))
    polar.radius = min(extent_polar.end.y, max(extent_polar.position.y, new_radius))
    # position is used by Godot to draw the crosshairs, in world-co-ordinates
    position = polar.radius * Vector2.from_angle(PI/2 - polar.angle)
    # normalized is used by camera, to decide how far to pan
    normalized = normalize(polar.angle, polar.radius, extent_polar)

func _ready():
    extent_polar = Rect2(
        -%Ground.PLANET_ANGLE * 0.99,
        %Ground.RADIUS + get_viewport_rect().size.y * 0.11,
        %Ground.PLANET_ANGLE * 1.98,
        get_viewport_rect().size.y * .89
    )
    # Dupes behavior of "focus in" event, since we don't get that event on startup on MacOS
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    set_polar(0, 0)

func _notification(what):
    match what:
        MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
        MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent):
    if event is InputEventMouseMotion:
        set_polar(
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

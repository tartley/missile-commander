'''
The ground at the bottom of the screen, including hills for each base.
The shape we draw determines the positions of the bases and cities,
which will ask us where they should be located.
'''
class_name Ground extends Node2D

# The ground is a pizza-slice shaped segment of a circular planet, centered at (0, 0), with:
const RADIUS := 12000.0
# extending for PLANET_ANGLE radians on either side of 'straight up':
const PLANET_ANGLE := PI / 16.0
const HILL_HEIGHT := RADIUS / 100.0
const COLOR := Color(0.1, 0.5, 0.2)

# Define the shape of ground in annotated polar co-ordinates, [angle, radius, feature]. Where:
# * angle=0 is straight up,
# * radius is relative to planet center at origin,
# * feature is a string indicating the in-game feature located at that point.
# Approximate the curved surface with straight segments.
const seg_ang := PLANET_ANGLE / 72
const annotated_polar_array := [
    [PI / 2 - 88 * seg_ang, 0],
    [PI / 2 - 88 * seg_ang, RADIUS],
    [PI / 2 - 72 * seg_ang, RADIUS],
    [PI / 2 - 56 * seg_ang, RADIUS, "gap", "hill1"],
    [PI / 2 - 52 * seg_ang, RADIUS + HILL_HEIGHT, "gap", "hill1"],
    [PI / 2 - 48 * seg_ang, RADIUS + HILL_HEIGHT, "base"],
    [PI / 2 - 44 * seg_ang, RADIUS + HILL_HEIGHT, "gap", "hill1"],
    [PI / 2 - 40 * seg_ang, RADIUS, "gap", "hill1"],
    [PI / 2 - 34 * seg_ang, RADIUS, "city"],
    [PI / 2 - 29 * seg_ang, RADIUS, "gap"],
    [PI / 2 - 24 * seg_ang, RADIUS, "city"],
    [PI / 2 - 19 * seg_ang, RADIUS, "gap"],
    [PI / 2 - 14 * seg_ang, RADIUS, "city"],
    [PI / 2 -  8 * seg_ang, RADIUS, "gap", "hill2"],
    [PI / 2 -  4 * seg_ang, RADIUS + HILL_HEIGHT, "gap", "hill2"],
    [PI / 2 +  0 * seg_ang, RADIUS + HILL_HEIGHT, "base"],
    [PI / 2 +  4 * seg_ang, RADIUS + HILL_HEIGHT, "gap", "hill2"],
    [PI / 2 +  8 * seg_ang, RADIUS, "gap", "hill2"],
    [PI / 2 + 14 * seg_ang, RADIUS, "city"],
    [PI / 2 + 19 * seg_ang, RADIUS, "gap"],
    [PI / 2 + 24 * seg_ang, RADIUS, "city"],
    [PI / 2 + 29 * seg_ang, RADIUS, "gap"],
    [PI / 2 + 34 * seg_ang, RADIUS, "city"],
    [PI / 2 + 40 * seg_ang, RADIUS, "gap", "hill3"],
    [PI / 2 + 44 * seg_ang, RADIUS + HILL_HEIGHT, "gap", "hill3"],
    [PI / 2 + 48 * seg_ang, RADIUS + HILL_HEIGHT, "base"],
    [PI / 2 + 52 * seg_ang, RADIUS + HILL_HEIGHT, "gap", "hill3"],
    [PI / 2 + 56 * seg_ang, RADIUS, "gap", "hill3"],
    [PI / 2 + 72 * seg_ang, RADIUS],
    [PI / 2 + 88 * seg_ang, RADIUS],
    [PI / 2 + 88 * seg_ang, 0],
]

var verts : PackedVector2Array
var cities : Array[Vector2] = []
var bases : Array[Vector2] = []
var gaps : Array[Vector2] = []

func get_annotated_vert_array(annotated_polars:Array) -> Array:
    '''Convert array of annotated polar co-ords to an array of annotated cartesian co-ords'''
    var retval := []
    var vert:Vector2
    for ap:Array in annotated_polars:
        vert = ap[1] * Vector2.from_angle(ap[0])
        retval.append([vert.x, vert.y, ap.slice(2)])
    return retval

func set_up_collisions(av:Geometry.AnnotatedVerts):
    var shapes:Array[Shape2D] = []

    # First shape is the circular planet
    var circle = CircleShape2D.new()
    circle.radius = RADIUS
    shapes.append(circle)

    # Next shapes are the three hills
    for hill_name in ["hill1", "hill2", "hill3"]:
        var polygon = ConvexPolygonShape2D.new()
        polygon.points = av.get_vertices(hill_name)
        shapes.append(polygon)

    # Add all shapes to the ground's collision area
    for shape in shapes:
        var collision = CollisionShape2D.new()
        collision.shape = shape
        add_child(collision)

func _ready() -> void:
    var annotated_vert_array := get_annotated_vert_array(annotated_polar_array)
    var annotated_verts := Geometry.AnnotatedVerts.new(annotated_vert_array)
    verts = annotated_verts.verts
    cities = annotated_verts.get_vertices("city")
    bases = annotated_verts.get_vertices("base")
    gaps = annotated_verts.get_vertices("gap")
    set_up_collisions(annotated_verts)

func _draw() -> void:
    draw_polygon(verts, [Color.BLACK])
    draw_polyline(verts, Color(.7, 1, .6), 2.0, true)

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
const seg_ang := PLANET_ANGLE / 36
const annotated_polars := [
    [PI / 2 - 44 * seg_ang, 0],
    [PI / 2 - 44 * seg_ang, RADIUS],
    [PI / 2 - 36 * seg_ang, RADIUS],
    [PI / 2 - 28 * seg_ang, RADIUS],
    [PI / 2 - 26 * seg_ang, RADIUS + HILL_HEIGHT, "gap"],
    [PI / 2 - 24 * seg_ang, RADIUS + HILL_HEIGHT, "base"],
    [PI / 2 - 22 * seg_ang, RADIUS + HILL_HEIGHT, "gap"],
    [PI / 2 - 20 * seg_ang, RADIUS, "gap"],
    [PI / 2 - 16 * seg_ang, RADIUS, "city"],
    [PI / 2 - 14 * seg_ang, RADIUS, "gap"],
    [PI / 2 - 12 * seg_ang, RADIUS, "city"],
    [PI / 2 - 10 * seg_ang, RADIUS, "gap"],
    [PI / 2 -  8 * seg_ang, RADIUS, "city"],
    [PI / 2 -  4 * seg_ang, RADIUS, "gap"],
    [PI / 2 -  2 * seg_ang, RADIUS + HILL_HEIGHT, "gap"],
    [PI / 2 +  0 * seg_ang, RADIUS + HILL_HEIGHT, "base"],
    [PI / 2 +  2 * seg_ang, RADIUS + HILL_HEIGHT, "gap"],
    [PI / 2 +  4 * seg_ang, RADIUS, "gap"],
    [PI / 2 +  8 * seg_ang, RADIUS, "city"],
    [PI / 2 + 10 * seg_ang, RADIUS, "gap"],
    [PI / 2 + 12 * seg_ang, RADIUS, "city"],
    [PI / 2 + 14 * seg_ang, RADIUS, "gap"],
    [PI / 2 + 16 * seg_ang, RADIUS, "city"],
    [PI / 2 + 20 * seg_ang, RADIUS, "gap"],
    [PI / 2 + 22 * seg_ang, RADIUS + HILL_HEIGHT, "gap"],
    [PI / 2 + 24 * seg_ang, RADIUS + HILL_HEIGHT, "base"],
    [PI / 2 + 26 * seg_ang, RADIUS + HILL_HEIGHT, "gap"],
    [PI / 2 + 28 * seg_ang, RADIUS],
    [PI / 2 + 36 * seg_ang, RADIUS],
    [PI / 2 + 44 * seg_ang, RADIUS],
    [PI / 2 + 44 * seg_ang, 0],
]

var verts : PackedVector2Array
var cities : Array[Vector2] = []
var bases : Array[Vector2] = []
var gaps : Array[Vector2] = []

func get_annotated_verts() -> Array:
    '''Return an array of annotated Vector2, ie. [ [ vector2, string ], ... ]'''
    var retval := []
    var vert:Vector2
    var annotation:String
    for ap:Array in annotated_polars:
        vert = Vector2.from_angle(ap[0]) * ap[1]
        annotation = ""
        if len(ap) == 3:
            annotation = ap[2]
        retval.append([vert, annotation])
    return retval

func get_verts(annotated_verts:Array) -> Array[Vector2]:
    var retval:Array[Vector2] = []
    for av in annotated_verts:
        retval.append(av[0])
    return retval

func get_annotation(annotated_verts:Array, annotation:String) -> Array[Vector2]:
    var retval:Array[Vector2] = []
    for av in annotated_verts:
        if av[1] == annotation:
            retval.append(av[0])
    return retval

#func set_up_collision_shape():
    #var collision_shape = CollisionShape2D.new()
    #collision_shape.shape = Shape.new()
    #collision_shape.shape = verts
    #add_child(collision_shape)

func _ready() -> void:
    var annotated_verts := get_annotated_verts()
    verts = get_verts(annotated_verts)
    cities = get_annotation(annotated_verts, "city")
    bases = get_annotation(annotated_verts, "base")
    gaps = get_annotation(annotated_verts, "gap")
    #set_up_collision_shape()

func _draw():
    draw_polygon(verts, [Color.BLACK])
    draw_polyline(verts, Color(.7, 1, .6), 2.0, true)

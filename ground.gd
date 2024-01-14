'''
The ground at the bottom of the screen, including hills for each base.
The shape we draw determines the positions of the bases and cities,
which will ask us where they should be located.
'''
@tool
extends Node2D

# Define the pizza-sliced planet segment
const RADIUS := 23000.0
const ALPHA := PI / 16.0 # Half angle subtended by planet segment, radians
const HILL_HEIGHT := RADIUS / 100.0
const COLOR := Color(0.1, 0.5, 0.2)

var verts : Array[Vector2]
var edges : Array[Vector2] = []
var cities : Array[Vector2] = []
var bases : Array[Vector2] = []

func create_annotated_polars(annotated_polars:Array, segment_angle:float, radius:float) -> Array:
    var retval: Array = []
    var annotation: String
    var vector: Vector2
    for p in annotated_polars:
        vector = Vector2(
            PI / 2.0 + p[0] * segment_angle,
            p[1] + radius
        )
        if len(p) == 2:
            annotation = ""
        elif len(p) == 3:
            annotation = p[2]
        else:
            const msg := "create_annotated_polars: len(item)=%s not in [2, 3], (%s)"
            assert(false, msg % [len(p), p])
        retval.append([vector, annotation])
    return retval

func _ready():
    # Shape of ground in annotated polar co-ordinates, ((angle, radius), feature).
    # Where angle=0 is straight up, and radius is relative to ground level.
    # Hence radius=0 actually represents a radius of RADIUS.
    # and 'feature' is a string indicating the point is the location of
    # an in-game feature. These aren't used as yet.

    # Approximate the curved surface with straight segments.
    # Expressed as [angle-relative-to-up, height-above-ground-level, feature]
    const SEGMENT_ANGLE := ALPHA / 36
    var polars := create_annotated_polars(
        [
            [-36, -RADIUS],
            [-36, 0, "edge"],
            [-32, 0],
            [-28, 0],
            [-26, HILL_HEIGHT],
            [-24, HILL_HEIGHT, "base"],
            [-22, HILL_HEIGHT],
            [-20, 0],
            [-16, 0, "city"],
            [-12, 0, "city"],
            [-8, 0, "city"],
            [-4, 0],
            [-2, HILL_HEIGHT],
            [0, HILL_HEIGHT, "base"],
            [2, HILL_HEIGHT],
            [4, 0],
            [8, 0, "city"],
            [12, 0, "city"],
            [16, 0, "city"],
            [20, 0],
            [22, HILL_HEIGHT],
            [24, HILL_HEIGHT, "base"],
            [26, HILL_HEIGHT],
            [28, 0],
            [32, 0],
            [36, 0, "edge"],
            [36, -RADIUS],
        ],
        SEGMENT_ANGLE, RADIUS
    )
    var verts_annotated := Polar.cartesian_from_polars(polars)
    
    # Extract from the annotated verts array an array of regular vector2
    # and the locations of the named features.
    for va in verts_annotated:
        verts.append(va[0])
        var collection:Array
        if va[1] == "edge":
            collection = edges
        elif va[1] == "city":
            collection = cities
        elif va[1] == "base":
            collection = bases
        elif va[1]:
            assert(false, "Unrecognized vertex annotation '%s'" % va[1])
        collection.append(va[0])
        
func _draw():
    draw_colored_polygon(verts, Color(.7, 1, .6))

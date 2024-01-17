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

var verts : Array[Vector2]
var cities : Array[Vector2] = []
var bases : Array[Vector2] = []
var gaps : Array[Vector2] = []

func _ready():
    # Shape of ground in annotated polar co-ordinates, (angle, radius, feature). Where:
    # * angle=0 is straight up,
    # * radius is relative to planet center at origin,
    # * feature is a string indicating the point is the location of an in-game feature.

    # Approximate the curved surface with straight segments.
    const seg_ang := PLANET_ANGLE / 36
    var annotated_polars : Array = [
        Polar.new(-44 * seg_ang, 0),
        Polar.new(-44 * seg_ang, RADIUS),
        Polar.new(-36 * seg_ang, RADIUS),
        Polar.new(-28 * seg_ang, RADIUS),
        Polar.new(-26 * seg_ang, RADIUS + HILL_HEIGHT, "gap"),
        Polar.new(-24 * seg_ang, RADIUS + HILL_HEIGHT, "base"),
        Polar.new(-22 * seg_ang, RADIUS + HILL_HEIGHT, "gap"),
        Polar.new(-20 * seg_ang, RADIUS, "gap"),
        Polar.new(-16 * seg_ang, RADIUS, "city"),
        Polar.new(-14 * seg_ang, RADIUS, "gap"),
        Polar.new(-12 * seg_ang, RADIUS, "city"),
        Polar.new(-10 * seg_ang, RADIUS, "gap"),
        Polar.new(-8 * seg_ang, RADIUS, "city"),
        Polar.new(-4 * seg_ang, RADIUS, "gap"),
        Polar.new(-2 * seg_ang, RADIUS + HILL_HEIGHT, "gap"),
        Polar.new(0 * seg_ang, RADIUS + HILL_HEIGHT, "base"),
        Polar.new(2 * seg_ang, RADIUS + HILL_HEIGHT, "gap"),
        Polar.new(4 * seg_ang, RADIUS, "gap"),
        Polar.new(8 * seg_ang, RADIUS, "city"),
        Polar.new(10 * seg_ang, RADIUS, "gap"),
        Polar.new(12 * seg_ang, RADIUS, "city"),
        Polar.new(14 * seg_ang, RADIUS, "gap"),
        Polar.new(16 * seg_ang, RADIUS, "city"),
        Polar.new(20 * seg_ang, RADIUS, "gap"),
        Polar.new(22 * seg_ang, RADIUS + HILL_HEIGHT, "gap"),
        Polar.new(24 * seg_ang, RADIUS + HILL_HEIGHT, "base"),
        Polar.new(26 * seg_ang, RADIUS + HILL_HEIGHT, "gap"),
        Polar.new(28 * seg_ang, RADIUS),
        Polar.new(36 * seg_ang, RADIUS),
        Polar.new(44 * seg_ang, RADIUS),
        Polar.new(44 * seg_ang, 0),
    ]
    var xys_annotated: Array = []
    for polar:Polar in annotated_polars:
        xys_annotated.append([polar.cartesian(), polar.annotation])

    # Extract from the annotated verts array an array of regular vector2
    # and the locations of the named features.
    for va in xys_annotated:
        verts.append(va[0])
        var collection:Array
        if va[1] == "city":
            collection = cities
        elif va[1] == "base":
            collection = bases
        elif va[1] == "gap":
            collection = gaps
        elif va[1]:
            assert(false, "Unrecognized vertex annotation '%s'" % va[1])
        collection.append(va[0])

    return xys_annotated


func _draw():
    draw_polygon(verts, [Color(0, 0, 0)])
    draw_polyline(verts, Color(.7, 1, .6), 2.0, true)

'''
The ground at the bottom of the screen, including hills for each base.
The shape we draw determines the positions of the bases and cities,
which will ask us where they should be located.
'''
extends Node2D

# Define the pizza-sliced planet segment
const RADIUS := 12000
const ANGLE := PI / 16
const HILL_HEIGHT := RADIUS / 150.0
const COLOR := Color(0.1, 0.5, 0.2)

func cartesian_from_polar(polar) -> Vector2:
    return Vector2(
        polar[1] * cos(polar[0]),
        polar[1] * sin(polar[0]),
    )

func cartesian_from_polars(polars:Array, offset:Vector2=Vector2(0, 0)) -> Array:
    var xys := []
    for p:Array in polars:
        xys.append([cartesian_from_polar([p[0][0], p[0][1]]) + offset, p[1]])
    return xys

func _draw():
    # Shape of ground in annotated polar co-ordinates, ((angle, radius), feature).
    # Where angle=0 is straight up, and radius is relative to ground level.
    # Hence radius=0 actually represents a radius of RADIUS.
    # and 'feature' is a string indicating the point is the location of
    # an in-game feature. These aren't used as yet.

    # Approximate the curved surface with straight segments/
    # Changing this
    const SEGMENT_COUNT := 72
    const SEGMENT_ANGLE := ANGLE / SEGMENT_COUNT
    var polars := [
        [[-36, -60], ""],
        [[-36, 0], ""],
        [[-32, 0], ""],
        [[-28, 0], ""],
        [[-26, HILL_HEIGHT], ""],
        [[-24, HILL_HEIGHT], "base"],
        [[-22, HILL_HEIGHT], ""],
        [[-20, 0], ""],
        [[-16, 0], "city"],
        [[-12, 0], "city"],
        [[-8, 0], "city"],
        [[-4, 0], ""],
        [[-2, HILL_HEIGHT], ""],
        [[0, HILL_HEIGHT], "base"],
        [[2, HILL_HEIGHT], ""],
        [[4, 0], ""],
        [[8, 0], "city"],
        [[12, 0], "city"],
        [[16, 0], "city"],
        [[20, 0], ""],
        [[22, HILL_HEIGHT], ""],
        [[24, HILL_HEIGHT], "base"],
        [[26, HILL_HEIGHT], ""],
        [[28, 0], ""],
        [[32, 0], ""],
        [[36, 0], ""],
        [[36, -60], ""],
    ]
    for p in polars:
        p[0][0] = p[0][0] * SEGMENT_ANGLE + PI / 2
        p[0][1] = p[0][1] + RADIUS
    var verts_annotated := cartesian_from_polars(polars, Vector2(0, -RADIUS))
    var verts: Array[Vector2] = []
    for v in verts_annotated:
        verts.append(v[0])
    draw_colored_polygon(verts, Color(.7, 1, .6))

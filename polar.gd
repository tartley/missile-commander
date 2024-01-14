class_name Polar extends Node

static func cartesian_from_polar(polar) -> Vector2:
    return Vector2(
        polar[1] * cos(polar[0]),
        polar[1] * sin(polar[0]),
    )

static func cartesian_from_polars(polars:Array) -> Array:
    var xys := []
    for p:Array in polars:
        xys.append([cartesian_from_polar([p[0][0], p[0][1]]), p[1]])
    return xys

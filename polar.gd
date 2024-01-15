class_name Polar extends Node

# Polar co-ordinates
var angle: float # Relative to straight up, in radians, increasing clockwise.
var radius: float
var annotation: String

func _init(_angle: float, _radius: float, _annotation: String = ""):
    angle=_angle
    radius=_radius
    annotation=_annotation

func cartesian() -> Vector2:
    return Vector2(
        radius * sin(angle),
        radius * cos(angle),
    )

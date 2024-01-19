class_name Polar extends Node

# Polar co-ordinates
var angle: float # Relative to straight up, in radians, increasing clockwise.
var radius: float

func _init(angle_: float, radius_: float):
    self.angle=angle_
    self.radius=radius_

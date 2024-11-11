# A polar co-ordinate
class_name Polar extends Node

var angle:float # Relative to straight up(!), in radians, increasing clockwise
var radius:float

func _init(a:float, r: float):
    self.angle = a
    self.radius = r

class_name Geometry extends Node

# A polar co-ordinate
class Polar:
    var angle:float # Relative to straight up, in radians, increasing clockwise.
    var radius:float

    func _init(angle:float, radius: float):
        self.angle=angle
        self.radius=radius


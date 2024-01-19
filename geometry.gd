class_name Geometry extends Node

# A polar co-ordinate
class Polar:
    var angle:float # Relative to straight up, in radians, increasing clockwise.
    var radius:float

    func _init(angle:float, radius: float):
        self.angle=angle
        self.radius=radius

# A section of an Annulus defined by two polar co-ordinates
class PolarExtent:
    var start:Polar
    var end:Polar

    func _init(start:Polar, end:Polar):
        self.start = start
        self.end = end

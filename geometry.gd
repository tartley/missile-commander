class_name Geometry extends Node

# A polar co-ordinate
class Polar:
    var angle:float # Relative to straight up, in radians, increasing clockwise.
    var radius:float

    func _init(a:float, r: float):
        self.angle=a
        self.radius=r

    func constrain(extent:PolarExtent) -> void:
        angle = min(extent.end.angle, max(extent.start.angle, angle))
        radius = min(extent.end.radius, max(extent.start.radius, radius))

# A section of an Annulus defined by two polar co-ordinates
class PolarExtent:
    var start:Polar
    var end:Polar

    func _init(s:Polar, e:Polar):
        self.start = s
        self.end = e

    func normalize(polar:Geometry.Polar) -> Vector2:
        '''Convert polar co-ord's position within polar extent to range x:(-1 to +1), y:(0 to 1)'''
        return Vector2(
            polar.angle / (end.angle - start.angle),
            (polar.radius - start.radius) / (end.radius - start.radius),
        )

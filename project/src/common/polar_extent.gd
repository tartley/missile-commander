# Polar equivalent of a Rect, defining a section of an Annulus.
class_name PolarExtent extends Node

var start:Polar
var end:Polar

var width:float:
    get:
        return self.end.angle - self.start.angle

var height:float:
    get:
        return self.end.radius - self.start.radius

func _init(s:Polar, e:Polar):
    self.start = s
    self.end = e

func constrain(polar:Polar) -> Polar:
    return Polar.new(
        min(self.end.angle, max(self.start.angle, polar.angle)),
        min(self.end.radius, max(self.start.radius, polar.radius)),
    )

func normalize(polar:Polar) -> Vector2:
    '''Convert given polar to range angle:(-1 to +1), radius:(0 to 1)'''
    return Vector2(
        polar.angle / self.width,
        (polar.radius - self.start.radius) / self.height,
    )

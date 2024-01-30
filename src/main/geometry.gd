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

# Manage an array of vertices, each one of which has an array of associated string annotations.
# .verts exposes the whole array of vector2s,
# .get_vertices(ANNO) returns an array of just the Vector2s with ANNO as an annotation.
class AnnotatedVerts:
    var verts:Array[Vector2] = []
    var verts_by_annotation := {}

    func _init(vertex_annotation_array:Array) -> void:
        var vert:Vector2
        for av:Array in vertex_annotation_array:
            vert = Vector2(av[0], av[1])
            verts.append(vert)
            for annotation:String in av.slice(2)[0]:
                if annotation not in verts_by_annotation:
                    self.verts_by_annotation[annotation] = [] as Array[Vector2]
                self.verts_by_annotation[annotation].append(vert)

    func get_vertices(annotation:String) -> Array[Vector2]:
        return self.verts_by_annotation[annotation]

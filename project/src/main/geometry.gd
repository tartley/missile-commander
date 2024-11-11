class_name Geometry extends Node

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

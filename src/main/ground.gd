'''
The ground at the bottom of the screen, including hills for each base.
The shape we draw determines the positions of the bases and cities,
which will ask us where they should be located.
'''
class_name Ground extends Node2D

const HILL_HEIGHT := Common.RADIUS / 100.0
const COLOR := Color(0.1, 0.5, 0.2)

# Define the shape of ground in annotated polar co-ordinates, [angle, radius, feature]. Where:
# * angle=0 is straight up,
# * radius is relative to planet center at origin,
# * feature is a string indicating the in-game feature located at that point.
# Approximate the curved surface with straight segments.
const seg_ang := Common.PLANET_ANGLE / 72
const annotated_polar_array := [
    [ -88 * seg_ang, -Common.RADIUS],
    [ -88 * seg_ang, 0],
    [ -72 * seg_ang, 0],
    [ -56 * seg_ang, 0, "gap", "hill1"],
    [ -52 * seg_ang, HILL_HEIGHT, "gap", "hill1"],
    [ -48 * seg_ang, HILL_HEIGHT, "base"],
    [ -44 * seg_ang, HILL_HEIGHT, "gap", "hill1"],
    [ -40 * seg_ang, 0, "gap", "hill1"],
    [ -34 * seg_ang, 0, "city"],
    [ -29 * seg_ang, 0, "gap"],
    [ -24 * seg_ang, 0, "city"],
    [ -19 * seg_ang, 0, "gap"],
    [ -14 * seg_ang, 0, "city"],
    [ - 8 * seg_ang, 0, "gap", "hill2"],
    [ - 4 * seg_ang, HILL_HEIGHT, "gap", "hill2"],
    [ + 0 * seg_ang, HILL_HEIGHT, "base"],
    [ + 4 * seg_ang, HILL_HEIGHT, "gap", "hill2"],
    [ + 8 * seg_ang, 0, "gap", "hill2"],
    [ +14 * seg_ang, 0, "city"],
    [ +19 * seg_ang, 0, "gap"],
    [ +24 * seg_ang, 0, "city"],
    [ +29 * seg_ang, 0, "gap"],
    [ +34 * seg_ang, 0, "city"],
    [ +40 * seg_ang, 0, "gap", "hill3"],
    [ +44 * seg_ang, HILL_HEIGHT, "gap", "hill3"],
    [ +48 * seg_ang, HILL_HEIGHT, "base"],
    [ +52 * seg_ang, HILL_HEIGHT, "gap", "hill3"],
    [ +56 * seg_ang, 0, "gap", "hill3"],
    [ +72 * seg_ang, 0],
    [ +88 * seg_ang, 0],
    [ +88 * seg_ang, -Common.RADIUS],
]

const City:PackedScene = preload("res://src/city/city.tscn")
const Base:PackedScene = preload("res://src/base/base.tscn")

var verts:PackedVector2Array
var gaps:Array[Vector2] = []

func get_annotated_vert_array(annotated_polars:Array) -> Array:
    '''Convert array of annotated polar co-ords to an array of annotated cartesian co-ords'''
    var retval := []
    for ap in annotated_polars:
        var angle = ap[0] - PI / 2
        var radius = ap[1] + Common.RADIUS
        var vert = radius * Vector2.from_angle(angle)
        retval.append([vert.x, vert.y, ap.slice(2)])
    return retval

func add_collision_shape(shape:Shape2D, name_:String):
    var collision = CollisionShape2D.new()
    collision.shape = shape
    collision.name = name_
    add_child(collision)

func set_up_collisions(av:Geometry.AnnotatedVerts):
    ## Set up collision shapes for the ground

    # 1. the circular planet
    var circle = CircleShape2D.new()
    circle.radius = Common.RADIUS
    add_collision_shape(circle, "circle")

    # 2. the three hills
    for hill_name in ["hill1", "hill2", "hill3"]:
        var polygon = ConvexPolygonShape2D.new()
        polygon.points = av.get_vertices(hill_name)
        add_collision_shape(polygon, hill_name)

func create_features(annotated_verts, feature_name:String, type:PackedScene) -> Array[Node2D]:
    var positions = annotated_verts.get_vertices(feature_name)
    var retval:Array[Node2D] = []
    var feature:Node2D
    for pos in positions:
        feature = type.instantiate()
        feature.position = pos
        feature.rotation = pos.angle() - PI / 2
        add_child(feature)
        retval.append(feature)
    return retval

func _ready() -> void:
    var annotated_verts := Geometry.AnnotatedVerts.new(get_annotated_vert_array(annotated_polar_array))
    self.verts = annotated_verts.verts
    create_features(annotated_verts, "city", City)
    create_features(annotated_verts, "base", Base)
    self.gaps = annotated_verts.get_vertices("gap")
    set_up_collisions(annotated_verts)

func _draw() -> void:
    draw_polygon(verts, [Color.BLACK])
    draw_polyline(verts, Color(.7, 1, .6), 3.0, true)

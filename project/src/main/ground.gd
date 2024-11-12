'''
The ground at the bottom of the screen, including hills for each base.
The shape we draw determines the positions of the bases and cities,
which will ask us where they should be located.
'''
class_name Ground extends Area2D

const BaseScene:PackedScene = preload("res://src/base/base.tscn")
const CityScene:PackedScene = preload("res://src/city/city.tscn")

# The ground is a pizza-slice shaped segment of a circular planet, centered at (0, 0), with:
const RADIUS := 12000.0
# extending for PLANET_ANGLE radians on either side of 'straight up':
const PLANET_ANGLE := PI / 16.0
const HILL_HEIGHT := RADIUS / 100.0
const COLOR := Color(0.1, 0.5, 0.2)
# How close must a bomb land to destroy a feature, squared
const EPSILON := 100


# Define the shape of ground in annotated polar co-ordinates, [angle, radius, feature]. Where:
# * angle=0 is straight up,
# * radius is relative to planet center at origin,
# * feature is a string indicating the in-game feature located at that point.
# Approximate the curved surface with straight segments.
const seg_ang := PLANET_ANGLE / 72
const annotated_polar_array := [
    [ -88 * seg_ang, -RADIUS],
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
    [ +88 * seg_ang, -RADIUS],
]

var verts:PackedVector2Array
var gaps:Array[Node2D] = []


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


func get_annotated_vert_array(annotated_polars:Array) -> Array:
    '''Convert array of annotated polar co-ords to an array of annotated cartesian co-ords'''
    var retval := []
    for ap:Array in annotated_polars:
        var angle:float = ap[0] - PI / 2.0
        var radius:float = ap[1] + RADIUS
        var vert:Vector2 = radius * Vector2.from_angle(angle)
        retval.append([vert.x, vert.y, ap.slice(2)])
    return retval

func add_collision_shape(shape:Shape2D, name_:String):
    var collision = CollisionShape2D.new()
    collision.shape = shape
    collision.name = name_
    add_child(collision)

func set_up_collisions(av:AnnotatedVerts):
    ## Set up collision shapes for the ground
    # 1. the circular planet
    var circle = CircleShape2D.new()
    circle.radius = RADIUS
    add_collision_shape(circle, "circle")
    # 2. the three hills
    for hill_name in ["hill1", "hill2", "hill3"]:
        var polygon = ConvexPolygonShape2D.new()
        polygon.points = av.get_vertices(hill_name)
        add_collision_shape(polygon, hill_name)

func create_features(annotated_verts, feature_name:String, type:PackedScene, cls:Object=null) -> Array[Node2D]:
    var positions:Array[Vector2] = annotated_verts.get_vertices(feature_name)
    var retval:Array[Node2D] = []
    var feature:Node2D
    for pos in positions:
        if type:
            feature = type.instantiate()
        else:
            feature = cls.new()
        feature.position = pos
        feature.rotation = pos.angle() - PI / 2
        feature.show_behind_parent = true
        add_child(feature)
        retval.append(feature)
    return retval

func _ready() -> void:
    var annotated_verts := AnnotatedVerts.new(get_annotated_vert_array(annotated_polar_array))
    self.verts = annotated_verts.verts
    create_features(annotated_verts, "city", CityScene)
    create_features(annotated_verts, "base", BaseScene)
    assert(Base.all.size() == 3)
    self.gaps = create_features(annotated_verts, "gap", null, Node2D)
    set_up_collisions(annotated_verts)

func _draw() -> void:
    draw_polygon(verts, [Color.BLACK])
    draw_polyline(verts, Color(.7, 1, .6), 3.0, true)

func find_target(pos:Vector2) -> Object:
    var features := City.all + Base.all
    for feature in features:
        if not feature.destroyed and pos.distance_squared_to(feature.position) < EPSILON:
            return feature
    return null

func on_area_entered(bomb:Bomb):
    var target := find_target(bomb.position)
    if target:
        target.destroy()
    else:
        BangGround.create(bomb.position)
    bomb.destroy()

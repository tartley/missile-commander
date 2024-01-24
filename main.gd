class_name Main extends Node

var Missile:PackedScene = preload("res://missile.tscn")
var City:PackedScene = preload("res://city.tscn")

func launch_missile():
    var missile = Missile.instantiate()
    var start := Vector2(randf_range(-2000, +2000), randf_range(14500, 30000))
    var targets:Array[Vector2] = $World/Ground.gaps + $World/Ground.cities
    var destination:Vector2 = targets.pick_random()
    var speed := randf_range(50, 300)
    missile.launch(start, destination, speed)
    $World.add_child(missile)

func create_cities():
    for city_pos in $World/Ground.cities:
        var city = City.instantiate()
        city.position = city_pos
        $World.add_child(city)

func begin_level():
    for _i in range(50):
        launch_missile()

func _ready() -> void:
    $World/Camera.mouse = $World/Mouse
    $World/Camera.ground = $World/Ground
    create_cities()
    begin_level()

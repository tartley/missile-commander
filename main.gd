class_name Main extends Node

var Missile = preload("res://missile/missile.tscn")
var City = preload("res://city/city.tscn")

func launch_missile():
    var missile = Missile.instantiate()
    var start := Vector2(randf_range(-2000, +2000), randf_range(14500, 15000))
    var targets:Array[Vector2] = %Ground.gaps + %Ground.cities
    var destination:Vector2 = targets.pick_random()
    var speed := randf_range(100, 200)
    missile.launch(start, destination, speed)
    %World.add_child(missile)

func create_cities():
    for city_pos in %Ground.cities:
        var city = City.instantiate()
        city.position = city_pos
        %World.add_child(city)

func begin_level():
    for _i in range(20):
        launch_missile()

func _ready() -> void:
    create_cities()
    begin_level()

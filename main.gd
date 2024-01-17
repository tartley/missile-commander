class_name Main extends Node

var Missile = preload("res://missile/missile.tscn")

func launch_missile():
    var missile = Missile.instantiate()
    var start := Vector2(randf_range(-2000, +2000), randf_range(14500, 15000)) # start position
    var targets:Array[Vector2] = %Ground.empties + %Ground.cities
    var destination:Vector2 = targets.pick_random()
    var speed := randf_range(100, 200)
    missile.launch(start, destination, speed)
    %World.add_child(missile)

func _ready() -> void:
    for _i in range(10):
        launch_missile()

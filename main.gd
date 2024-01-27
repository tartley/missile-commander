class_name Main extends Node

var Missile:PackedScene = preload("res://missile.tscn")

func positions(nodes:Array) -> Array[Vector2]:
    var retval:Array[Vector2] = []
    for node:Node2D in nodes:
        retval.append(node.position)
    return retval
            
func launch_missile():
    var missile = Missile.instantiate()
    var start := Vector2(randf_range(-2000, +2000), randf_range(14100, 20000))
    var targets:Array[Vector2] = positions($World/Ground.cities) + positions($World/Ground.bases) + $World/Ground.gaps
    var destination:Vector2 = targets.pick_random()
    var speed := randf_range(50, 400)
    missile.launch(start, destination, speed)
    $World.add_child(missile)
    missile.missile_strike.connect($World/Ground.on_missile_strike)
    
func begin_level():
    for _i in range(200):
        launch_missile()

func _unhandled_input(event):
    if event is InputEventKey:
        if event.pressed and event.keycode == KEY_ESCAPE:
            get_tree().quit()

func _ready() -> void:
    $World/Camera.mouse = $World/Mouse
    $World/Camera.ground = $World/Ground
    begin_level()

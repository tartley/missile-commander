class_name Main extends Node

var Missile:PackedScene = preload("res://src/missile/missile.tscn")
var Shot:PackedScene = preload("res://src/shot/shot.tscn")

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
    var speed := randf_range(50, 100)
    missile.launch(start, destination, speed)
    $World.add_child(missile)
    missile.missile_strike.connect($World/Ground.on_missile_strike)
    
func begin_level():
    for _i in range(200):
        launch_missile()

func launch_shot(base_id):
    # TODO should this be a method on Base?
    var shot = Shot.instantiate()
    shot.launch($World/Ground.bases[base_id].position, $World/Mouse.position)
    $World.add_child(shot)

func _unhandled_input(event):
    if event is InputEventKey and event.pressed:
        match event.keycode:
            KEY_A:
                launch_shot(0)
            KEY_ESCAPE:
                get_tree().quit()
            # ignore others

func _ready() -> void:
    # Inject dependencies
    $World/Camera.mouse = $World/Mouse
    $World/Camera.ground = $World/Ground
    $World/Ground.mouse = $World/Mouse
    $World/Sky.ground = $World/Ground
    # Also $Mouse needs to know $Ground,
    # But we do that as a global name because I'm too lazy to figure out the dependencies
    begin_level()

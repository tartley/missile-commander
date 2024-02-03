class_name Main extends Node

var MissileScene:PackedScene = preload("res://src/missile/missile.tscn")

func positions(nodes:Array) -> Array[Vector2]:
    var retval:Array[Vector2] = []
    for node:Node2D in nodes:
        retval.append(node.position)
    return retval

func choose_target() -> Array: # Array of [City|Base|null, Vector2]
    var targets:Array = []
    for target in get_tree().get_nodes_in_group("cities") + get_tree().get_nodes_in_group("bases"):
        targets.append([target, target.position])
    for pos in $Ground.gaps:
        targets.append([null, pos])
    return targets.pick_random()

func launch_missile(i):
    var missile = MissileScene.instantiate()
    var start := Vector2(randf_range(-200, +200), -14100 - i * 200)
    var td = choose_target()
    var target = td[0]
    var dest = td[1]
    var speed := randf_range(400, 500)
    missile.launch(start, target, dest, speed)
    self.add_child(missile)

func begin_level():
    for i in range(100):
        launch_missile(i)

func launch_shot(base_id):
    var base:Node2D = get_tree().get_nodes_in_group("bases")[base_id]
    var shot:Node2D = base.launch($Mouse.position)
    if shot:
        self.add_child(shot)

func _unhandled_input(event:InputEvent):
    if event is InputEventKey and event.pressed and not event.echo:
        match event.keycode:
            KEY_A:
                launch_shot(0)
            KEY_W:
                launch_shot(1)
            KEY_S:
                launch_shot(1)
            KEY_D:
                launch_shot(2)
            KEY_ESCAPE:
                get_tree().quit()
            _:
                pass

func _ready() -> void:
    # Inject dependencies
    $Camera.mouse = $Mouse
    for base in get_tree().get_nodes_in_group("bases"):
        base.mouse = $Mouse

    begin_level()

extends Node

const MissileScene:PackedScene = preload("res://src/missile/missile.tscn")

var mouse:Mouse

func _ready():
    for i in range(100):
        launch_missile(i)

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
            _:
                pass

func launch_missile(i):
    var missile = MissileScene.instantiate()
    var start := Vector2(randf_range(-2000, +2000), -14100 - i * 150)
    var td = choose_target()
    var target = td[0]
    var dest = td[1]
    var speed := randf_range(40, 300)
    missile.launch(start, target, dest, speed)
    self.add_child(missile)

func choose_target() -> Array: # Array of [City|Base|null, Vector2]
    var targets:Array = []
    for target in get_tree().get_nodes_in_group("cities") + get_tree().get_nodes_in_group("bases"):
        targets.append([target, target.position])
    for pos in Common.main.get_node("World/Ground").gaps: # TODO static on Ground?
        targets.append([null, pos])
    return targets.pick_random()

func launch_shot(base_id):
    var base:Node2D = get_tree().get_nodes_in_group("bases")[base_id]
    base.fire(self.mouse.position)

extends Node

var mouse:Mouse
var ground:Ground

func _ready():
    for i in range(1000):
        launch_missile(i)
    for city:City in get_tree().get_nodes_in_group("cities"):
        city.reset()
        city.city_destroyed.connect(on_city_destroyed)
    for base:Base in get_tree().get_nodes_in_group("bases"):
        base.reset()

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
            KEY_F1:
                for city in get_tree().get_nodes_in_group("cities"):
                    city.destroy()

func launch_missile(i):
    var start := Vector2(randf_range(-2000, +2000), -14100 - i * 150)
    var td = choose_target()
    var target = td[0]
    var dest = td[1]
    var speed := randf_range(40, 300)
    Missile.create(start, target, dest, speed)

func choose_target() -> Array: # Array of [City|Base|null, Vector2]
    var targets:Array = []
    for target in get_tree().get_nodes_in_group("cities") + get_tree().get_nodes_in_group("bases"):
        targets.append([target, target.position])
    for pos in Common.world.get_node("Ground").gaps: # TODO Static on Ground?
        targets.append([null, pos])
    return targets.pick_random()

func launch_shot(base_id):
    var base:Node2D = get_tree().get_nodes_in_group("bases")[base_id]
    base.fire(self.mouse.position)

func on_city_destroyed():
    var remaining := 0
    for city in get_tree().get_nodes_in_group("cities"):
        if not city.destroyed:
            remaining += 1
    if remaining == 0:
        # TODO some special effect first
        queue_free()



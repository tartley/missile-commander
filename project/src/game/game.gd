extends Node

var mouse:Mouse
var ground:Ground

func _ready():
    for i in range(1000):
        launch_bomb(i)
    for city:City in get_tree().get_nodes_in_group("cities"):
        city.reset()
        city.city_destroyed.connect(on_city_destroyed)
    for base:Base in get_tree().get_nodes_in_group("bases"):
        base.reset()
    Common.score.value = 0

func _unhandled_input(event:InputEvent):
    if event is InputEventKey and event.pressed and not event.echo:
        match event.keycode:
            KEY_A:
                launch_missile(0)
            KEY_W:
                launch_missile(1)
            KEY_S:
                launch_missile(1)
            KEY_D:
                launch_missile(2)
            KEY_F1:
                debug_destroy_cities()
    if event is InputEventMouseButton and event.pressed:
        match event.button_index:
            MOUSE_BUTTON_LEFT:
                launch_missile(0)
            MOUSE_BUTTON_MIDDLE:
                launch_missile(1)
            MOUSE_BUTTON_RIGHT:
                launch_missile(2)

func debug_destroy_cities():
    for city in get_tree().get_nodes_in_group("cities"):
        city.destroy()

func launch_missile(base_id):
    var base:Node2D = get_tree().get_nodes_in_group("bases")[base_id]
    base.fire(self.mouse.position)

func launch_bomb(i):
    var start := Vector2(randf_range(-2000, +2000), -14100 - i * 5)
    var td = choose_target()
    var target = td[0]
    var dest = td[1]
    var speed := randf_range(40, 300)
    Bomb.create(start, target, dest, speed)

func choose_target() -> Array: # Array of [City|Base|null, Vector2]
    var targets:Array = []
    for target in get_tree().get_nodes_in_group("cities") + get_tree().get_nodes_in_group("bases"):
        targets.append([target, target.position])
    for pos in Common.world.get_node("Ground").gaps: # TODO Static on Ground?
        targets.append([null, pos])
    return targets.pick_random()

func on_city_destroyed():
    var remaining := 0
    for city in get_tree().get_nodes_in_group("cities"):
        if not city.destroyed:
            remaining += 1
    if remaining == 0:
        # TODO some special effect first
        queue_free()

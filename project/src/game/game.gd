extends Node

var mouse:Mouse
var ground:Ground
var level:Level

func _ready():
    # repair all cities and bases
    for city:City in get_tree().get_nodes_in_group("cities"):
        city.reset()
        city.city_destroyed.connect(on_city_destroyed)
    for base:Base in get_tree().get_nodes_in_group("bases"):
        base.reset()
    Common.score.value = 0
    self.level = Level.create(1)
    self.add_child(self.level)

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

func on_city_destroyed():
    var remaining := 0
    for city in get_tree().get_nodes_in_group("cities"):
        if not city.destroyed:
            remaining += 1
    if remaining == 0:
        # TODO some special effect first
        queue_free()

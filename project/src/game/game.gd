extends Node

var mouse:Mouse
var ground:Ground
var level:Level

func _ready():
    # repair all cities
    for city:City in City.all:
        city.reset()
        city.city_destroyed.connect(on_city_destroyed)
    # repair & re-arm all bases
    for base:Base in Base.all:
        base.reset()
    Common.score.value = 0
    create_level(1)

func create_level(difficulty:int):
    self.level = Level.create(difficulty)
    self.add_child.call_deferred(self.level)
    self.level.tree_exiting.connect(level_exiting)

func level_exiting():
    create_level(self.level.difficulty + 1)

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
            KEY_F2:
                debug_destroy_bombs()
    if event is InputEventMouseButton and event.pressed:
        match event.button_index:
            MOUSE_BUTTON_LEFT:
                launch_missile(0)
            MOUSE_BUTTON_MIDDLE:
                launch_missile(1)
            MOUSE_BUTTON_RIGHT:
                launch_missile(2)

func debug_destroy_cities():
    for city in City.all:
        city.destroy()

func debug_destroy_bombs():
    print("dd bombs")
    for bomb in get_tree().get_nodes_in_group("bombs"):
        print(bomb)
        bomb.destroy()

func launch_missile(base_id):
    var base:Node2D = Base.all[base_id]
    base.fire(self.mouse.position)

func on_city_destroyed():
    if City.remaining() == 0:
        # TODO some special effect first
        queue_free()

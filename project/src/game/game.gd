extends Node

var mouse:Mouse
var level:Level

func _ready():
    Common.score.value = 0
    # repair all cities
    for city:City in City.all:
        city.reset()
        city.city_destroyed.connect(on_city_destroyed)
    # repair & re-arm all bases
    for base:Base in Base.all:
        base.reset()
    create_level(1)

func create_level(difficulty:int):
    self.level = Level.create(difficulty)
    self.add_child.call_deferred(self.level)
    self.level.tree_exiting.connect(on_level_exit)

func on_level_exit():
    create_level(self.level.difficulty + 1)

func _unhandled_input(event:InputEvent):
    if event is InputEventKey and event.pressed and not event.echo:
        match event.keycode:
            KEY_A:
                Base.left.fire(self.mouse.position)
            KEY_W:
                Base.center.fire(self.mouse.position)
            KEY_S:
                Base.center.fire(self.mouse.position)
            KEY_D:
                Base.right.fire(self.mouse.position)
            KEY_F1:
                debug_destroy_city()
            KEY_F2:
                debug_destroy_base()
            KEY_F3:
                Bomb.destroy_all()
    if event is InputEventMouseButton and event.pressed:
        match event.button_index:
            MOUSE_BUTTON_LEFT:
                Base.left.fire(self.mouse.position)
            MOUSE_BUTTON_MIDDLE:
                Base.center.fire(self.mouse.position)
            MOUSE_BUTTON_RIGHT:
                Base.right.fire(self.mouse.position)

func debug_destroy_feature(type):
    var intact := []
    for feature in type.all:
        if not feature.destroyed:
            intact.append(feature)
    if intact:
        var feature = intact.pick_random()
        feature.destroy()

func debug_destroy_city():
    debug_destroy_feature(City)

func debug_destroy_base():
    debug_destroy_feature(Base)

func on_city_destroyed():
    if City.remaining() == 0:
        # TODO some special effect first
        queue_free()

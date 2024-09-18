class_name Level extends Node

var difficulty:int = 0

static func create(difficulty_:int) -> Level:
    var level:Level = Level.new()
    level.difficulty = difficulty_
    return level

func asleep(duration:float) -> void:
    await get_tree().create_timer(duration, false).timeout

func _ready() -> void:
    await asleep(1)
    intro()
    await asleep(1)
    create_bombs()
    await asleep(1)
    Common.labels.remove_all()

func intro() -> void:
    Common.labels.add("Wave %s" % self.difficulty, Vector2(0, -Common.RADIUS * 1.1), 64, Color.PURPLE)

func create_bombs() -> void:
    for i in range(2 ** (self.difficulty + 1)):
        launch_bomb(i)

func choose_target() -> Array: # Array of [City|Base|null, Vector2]
    var targets:Array = []
    for target in get_tree().get_nodes_in_group("cities") + get_tree().get_nodes_in_group("bases"):
        targets.append([target, target.position])
    for pos in Common.world.get_node("Ground").gaps: # TODO Static on Ground?
        targets.append([null, pos])
    return targets.pick_random()

func launch_bomb(i):
    var start := Vector2(randf_range(-2000, +2000), -14100 - i * 5)
    var td = choose_target()
    var target = td[0]
    var dest = td[1]
    var speed := randf_range(40, 300)
    Bomb.create(start, target, dest, speed)

func _process(_delta: float) -> void:
    pass

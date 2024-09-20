class_name Level extends Node

var difficulty:int = 0
var bomb_count:int = 0

static func create(difficulty_:int) -> Level:
    var level:Level = Level.new()
    level.difficulty = difficulty_
    return level

func asleep(duration:float) -> void:
    await get_tree().create_timer(duration, false).timeout

func _ready() -> void:
    await asleep(1)
    Common.labels.add("Wave %s" % self.difficulty, Vector2(0, -Common.RADIUS * 1.1), 64, Color.PURPLE)
    await asleep(1)
    create_bombs()
    await asleep(1)
    Common.labels.remove_all()

func choose_target() -> Array: # Array of [City|Base|null, Vector2]
    var targets:Array = []
    for target in City.all + Base.all:
        targets.append([target, target.position])
    for pos in Common.world.get_node("Ground").gaps: # TODO Static on Ground?
        targets.append([null, pos])
    return targets.pick_random()

func create_bomb(i):
    var start := Vector2(randf_range(-2000, +2000), -14100 - i * 5)
    var td = choose_target()
    var target = td[0]
    var dest = td[1]
    var speed := randf_range(40, 300)
    var bomb := Bomb.create(start, target, dest, speed)
    bomb.tree_exiting.connect(bomb_exiting)
    self.bomb_count += 1

func create_bombs() -> void:
    for i in range(2 ** (self.difficulty + 1)):
        create_bomb(i)

func rearm_bases():
    for base:Base in Base.all:
        base.rearm()
        await asleep(0.5)

func outro() -> void:
    await asleep(2)
    Common.labels.add("End of wave", Vector2(0, -Common.RADIUS * 1.1), 64, Color.PURPLE)
    await asleep(1.5)
    self.rearm_bases()
    await asleep(1.5)
    Common.labels.remove_all()
    self.queue_free()

func bomb_exiting() -> void:
    self.bomb_count -= 1
    if self.bomb_count <= 0:
        self.outro.call_deferred()

class_name Level extends Node

const LevelScene:PackedScene = preload("res://src/level/level.tscn")

var player:AudioStreamPlayer
var difficulty:int = 0

signal last_bomb_done

static func create(difficulty_:int) -> Level:
    var level:Level = LevelScene.instantiate()
    level.difficulty = difficulty_
    return level

func _ready() -> void:
    self.player = $AudioStreamPlayer
    lifecycle.call_deferred()

func asleep(duration:float) -> void:
    await get_tree().create_timer(duration, false).timeout

func lifecycle():
    await asleep(1)
    Common.labels.add("Wave %s" % self.difficulty, Vector2(0, -Common.RADIUS * 1.1), 64, Color.PURPLE)
    await asleep(1)
    create_bombs()
    await asleep(1)
    Common.labels.remove_all()
    await self.last_bomb_done
    await asleep(2.75)
    Common.labels.add("End of wave", Vector2(0, -Common.RADIUS * 1.1), 64, Color.PURPLE)
    await asleep(1.5)
    self.rearm_bases()
    await asleep(1.5)
    Common.labels.remove_all()
    self.queue_free()

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

func create_bombs() -> void:
    for i in range(2 ** (self.difficulty + 1)):
        create_bomb(i)

func bomb_exiting() -> void:
    if Bomb.all.size() <= 0 and get_tree():
        self.last_bomb_done.emit()

func rearm_bases():
    self.player.pitch_scale = 1.0
    for base:Base in Base.all:
        if base.needs_rearm():
            base.rearm()
            self.player.play()
            self.player.pitch_scale *= 1.27
            await asleep(0.5)

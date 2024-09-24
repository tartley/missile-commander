class_name Level extends Node

const LevelScene:PackedScene = preload("res://src/level/level.tscn")

var player:AudioStreamPlayer
var difficulty:int = 0
var bombs:int

signal last_bomb_done

static func create(difficulty_:int) -> Level:
    var level:Level = LevelScene.instantiate()
    level.difficulty = difficulty_
    return level

func _ready() -> void:
    self.player = $AudioStreamPlayer
    self.bombs = 2 ** (self.difficulty + 1)
    lifecycle.call_deferred()

func asleep(duration:float) -> void:
    var tree:SceneTree = get_tree()
    if tree:
        await tree.create_timer(duration, false).timeout

func lifecycle():
    await asleep(1)
    # TODO:
    # * Decide whether to add labels to Screen or World (ie should they move with camera)
    # * Perhaps this call should become ".create_label", then caller can choose which to add it to.
    Common.screen.add_label("Wave %s" % self.difficulty, Vector2(0.5, 0.4), 64, Color.PURPLE)
    await asleep(1)
    create_bombs()
    await asleep(1)
    Common.screen.remove_all_labels()
    await self.last_bomb_done
    await asleep(2.75)
    Common.screen.add_label("End of wave", Vector2(0.5, 0.4), 64, Color.PURPLE)
    await asleep(1.5)
    await self.bonus_for_ammo()
    await self.rearm_bases()
    await self.restore_one_base()
    await asleep(1.5)
    Common.screen.remove_all_labels()
    self.queue_free()

func choose_target() -> Array: # Array of [City|Base|null, Vector2]
    var targets:Array = []
    for target in City.all + Base.all:
        targets.append([target, target.position])
    for pos in Common.world.get_node("Ground").gaps: # TODO Static on Ground?
        targets.append([null, pos])
    return targets.pick_random()

func create_bomb():
    var start := Vector2(randf_range(-2000, +2000), -14300)
    var td = choose_target()
    var target = td[0]
    var dest = td[1]
    var speed := randf_range(40, 300)
    var bomb := Bomb.create(start, target, dest, speed)
    bomb.tree_exiting.connect(bomb_exiting)
    self.bombs -= 1

func create_bombs() -> void:
    for i in range(self.bombs):
        await asleep(1)
        create_bomb()

func bomb_exiting() -> void:
    if get_tree() and Bomb.all.size() <= 0 and self.bombs <= 0:
        self.last_bomb_done.emit()

func bonus_for_ammo():
    pass

func rearm_bases():
    self.player.pitch_scale = 1.0
    for base:Base in Base.all:
        if base.needs_rearm():
            Common.screen.add_label("Rearming bases", Vector2(0.5, 0.45), 64, Color.WEB_PURPLE)
            base.rearm()
            self.player.play()
            self.player.pitch_scale *= 1.27
            await asleep(0.5)

func restore_one_base():
    var sides:Array[Base] = [Base.left, Base.right]
    sides.shuffle()
    var bases:Array[Base] = [Base.center]
    bases.append_array(sides)
    for base:Base in bases:
        if base.destroyed:
            Common.screen.add_label("Rebuilding one base", Vector2(0.5, 0.5), 64, Color.WEB_PURPLE)
            base.reset()
            self.player.pitch_scale = 1 / 1.27
            self.player.play()
            break

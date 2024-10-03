class_name Level extends Node

const LevelScene:PackedScene = preload("res://src/level/level.tscn")

var player:AudioStreamPlayer
var labeller:Labeller

var difficulty:int = 0
var bombs:int

signal last_bomb_done

static func create(difficulty_:int) -> Level:
    var level:Level = LevelScene.instantiate()
    level.difficulty = difficulty_
    return level

func _ready() -> void:
    self.player = $AudioStreamPlayer
    $Labeller.init(Common.screen)
    self.bombs = 2 ** (self.difficulty + 1)
    lifecycle.call_deferred()

func asleep(duration:float) -> void:
    var tree:SceneTree = get_tree()
    if tree:
        await tree.create_timer(duration, false).timeout

func lifecycle():
    await asleep(1)
    $Labeller.add_centered([$Labeller.get_label("Wave %s" % self.difficulty, 64, Color.PURPLE)] as Array[Label], 0.4)
    await asleep(1)
    create_bombs()
    await asleep(1)
    $Labeller.remove_all_labels()
    await self.last_bomb_done
    await asleep(2.75)
    $Labeller.add_centered([$Labeller.get_label("End of wave", 64, Color.PURPLE)] as Array[Label], 0.4)
    await asleep(1.5)
    await self.bonus_for_ammo()
    await self.rebuild_one_base()
    await self.rearm_bases()
    await asleep(0.5)
    $Labeller.remove_all_labels()
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
    if not Main.exiting and Bomb.all.size() <= 0 and self.bombs <= 0:
        self.last_bomb_done.emit()

func bonus_for_ammo():
    var desc:Label = $Labeller.get_label("Bonus for remaining ammo: ", 64, Color.WEB_PURPLE)
    var value:Label = $Labeller.get_label("000", 64, Color.WEB_PURPLE)
    $Labeller.add_centered([desc, value] as Array[Label])
    for i in range(100): # TODO use real bonus value
        value.text = "%3d" % i
        await asleep(0.03)


func rebuild_one_base():
    var sides:Array[Base] = [Base.left, Base.right]
    sides.shuffle()
    var bases:Array[Base] = [Base.center]
    bases.append_array(sides)
    for base:Base in bases:
        if base.destroyed:
            $Labeller.add_centered([$Labeller.get_label("Rebuilding one base", 64, Color.WEB_PURPLE)])
            base.rebuild()
            self.player.pitch_scale = 1 / 1.27
            self.player.play()
            await asleep(0.5)
            break

func rearm_bases():
    var labelled := false
    self.player.pitch_scale = 1.0
    for base:Base in Base.all:
        if base.needs_rearm():
            if not labelled:
                $Labeller.add_centered([$Labeller.get_label("Rearming bases", 64, Color.WEB_PURPLE)])
                labelled = true
            base.rearm()
            self.player.play()
            self.player.pitch_scale *= 1.27
            await asleep(0.5)

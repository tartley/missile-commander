class_name Wave extends Node

const WaveScene:PackedScene = preload("res://src/wave/wave.tscn")

const color1 := Color.MEDIUM_PURPLE
const color3 := Color(0.531, 0.216, 0.565)
const color2 := (color1 + color3) / 2

var labeller:Labeller

var number:int = 0
var bombs:int

signal last_bomb_done

static func create(wave_number:int) -> Wave:
    var wave:Wave = WaveScene.instantiate()
    wave.number = wave_number
    return wave

func _ready() -> void:
    $Labeller.init(Main.screen)
    self.bombs = 2 ** (self.number + 1)
    lifecycle.call_deferred()

func asleep(duration:float) -> void:
    var tree:SceneTree = get_tree()
    if tree:
        await tree.create_timer(duration, false).timeout

func lifecycle():
    await asleep(1)
    $Labeller.add_centered([$Labeller.get_label("Wave %s" % self.number, 64, Color.YELLOW)] as Array[Label], 0.4)
    await asleep(1)
    create_bombs()
    await asleep(1)
    $Labeller.remove_all_labels()
    await self.last_bomb_done
    await asleep(2.75)
    $Labeller.add_centered([$Labeller.get_label("End of wave", 64, Color.YELLOW)] as Array[Label], 0.4)
    await asleep(1.5)
    await self.bonus_for_ammo()
    await self.rebuild_one_base()
    await self.rearm_bases()
    await asleep(0.75)
    $Labeller.remove_all_labels()
    self.queue_free()

func choose_target() -> Array: # Array of [City|Base|null, Vector2]
    var targets:Array = []
    for target in City.all + Base.all:
        targets.append([target, target.position])
    for pos in Main.world.get_node("Ground").gaps:
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
    while self.bombs > 0:
        await asleep(1)
        create_bomb()
        self.bombs -= 1

func end_bombs() -> void:
    self.bombs = 0
    Bomb.destroy_all()
    self.last_bomb_done.emit()

func bomb_exiting() -> void:
    # A bomb has left the scene tree.
    # Was it the last one of the wave?
    if not Main.exiting and Bomb.all.size() <= 0 and self.bombs <= 0:
        self.last_bomb_done.emit()

func bonus_for_ammo():
    var desc:Label = $Labeller.get_label("Bonus for remaining ammo:", 64, color1)
    var value:Label = $Labeller.get_label("0000", 64, color1)
    $Labeller.add_centered([desc, value] as Array[Label])
    # value label should be right aligned as we modify the bonus it displays
    value.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
    value.grow_horizontal = Control.GROW_DIRECTION_BEGIN
    value.position.x = value.position.x + value.size.x
    value.text = "0"

    await asleep(0.75)

    $AudioStreamPlayer.pitch_scale = 1 / 1.27 / 1.27
    var bonus := 0
    var counter := 0
    for base:Base in [Base.left, Base.right, Base.center]:
        for i in range(base.ammo - 1, -1, -1):
            $AudioStreamPlayer.play(0.01)
            base.ammo = i
            counter += 1
            bonus += counter
            Main.score.add(counter)
            value.text = "%4d" % bonus
            await asleep(0.07)
    await asleep(0.75)

func _sorted_bases() -> Array[Base]:
    var sides:Array[Base] = [Base.left, Base.right]
    sides.shuffle()
    var bases:Array[Base] = [Base.center]
    bases.append_array(sides)
    return bases

func rebuild_one_base():
    $AudioStreamPlayer.pitch_scale = 1 / 1.27
    for base:Base in _sorted_bases():
        if base.destroyed:
            $Labeller.add_centered([$Labeller.get_label("Rebuilding one base", 64, color2)])
            base.rebuild()
            $AudioStreamPlayer.play()
            await asleep(1)
            break

func rearm_bases():
    $Labeller.add_centered([$Labeller.get_label("Rearming bases", 64, color3)])
    $AudioStreamPlayer.play()
    $AudioStreamPlayer.pitch_scale *= 1.27
    for base:Base in Base.all:
        base.rearm()
    await asleep(0.75)

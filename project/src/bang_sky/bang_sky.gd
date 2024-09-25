"""
The explosion from missiles or bombs detonating in the sky.
"""
class_name BangSky extends Area2D

const BangSkyScene:PackedScene = preload("res://src/bang_sky/bang_sky.tscn")

const MAX_SIZE := 175.0 # world co-ords
const DURATION := 3.0 # seconds

var progress:float = 0.0 # [0..1]
var size:float = 0.0 # [0..MAX_SIZE]

enum Source {MISSILE, BOMB}
var source:Source # What caused this Bang?

var nearby_bombs:Array[Bomb]

static func create(pos:Vector2, src:Source):
    var bang := BangSkyScene.instantiate() as BangSky
    bang.position = pos
    bang.source = src
    bang.get_node("CollisionShape2D").shape.radius = MAX_SIZE
    Common.world.add_child(bang)

static func create_from_missile(pos:Vector2):
    create(pos, Source.MISSILE)

static func create_from_bomb(pos:Vector2):
    create(pos, Source.BOMB)

func _process(delta:float) -> void:
    self.progress += delta / DURATION
    if progress < 1.0:
        self.size = MAX_SIZE * maxf(0, sin(progress * PI))
        self.destroy_nearby_bombs()
        queue_redraw()
    else:
        queue_free()

func _draw() -> void:
    var color:Color
    match self.source:
        Source.MISSILE:
            color = Color(
                maxf(1 - progress * 2, progress * 2 - 1.0), # red
                1 - progress * 2, # green
                1.0, # blue,
                .75 - progress * 0.5, # alpha
            )
        Source.BOMB:
            color = Color(
                1.0 - progress, # red
                maxf(0.0, progress * 2 - 0.5), # green
                1.0 - progress, # blue
                .75 - progress * 0.5, # alpha
            )
    draw_circle(Vector2.ZERO, self.size, color)
    if Common.DEBUG:
        draw_arc(Vector2.ZERO, MAX_SIZE, 0, TAU, 20, Color.DARK_MAGENTA)

func on_entered(bomb:Bomb):
    self.nearby_bombs.append(bomb)

func on_leave(bomb:Bomb):
    self.nearby_bombs.erase(bomb)

func destroy_nearby_bombs() -> void:
    var valid_bombs:Array[Bomb] = []
    for bomb:Bomb in self.nearby_bombs:
        if bomb and is_instance_valid(bomb) and !bomb.is_queued_for_deletion():
            if self.position.distance_to(bomb.position) < self.size:
                bomb.destroy()
                BangSky.create_from_bomb(bomb.position)
                Common.score.value += Score.BOMB_DESTROYED
            else:
                valid_bombs.append(bomb)
    self.nearby_bombs = valid_bombs

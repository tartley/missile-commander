"""
The explosion from shots or missiles detonating in the sky.
"""
class_name BangSky extends Area2D

enum Source {SHOT, MISSILE}

const BangSkyScene:PackedScene = preload("res://src/bang_sky/bang_sky.tscn")

const MAX_SIZE := 175.0 # world co-ords
const DURATION := 3.0 # seconds

var progress:float = 0.0 # [0..1]
var size:float = 0.0 # [0..MAX_SIZE]
var source:Source # What caused this Bang?
var nearby_missiles:Array[Missile]

static func create(pos:Vector2, src:Source):
    var bang := BangSkyScene.instantiate() as BangSky
    bang.position = pos
    bang.source = src
    bang.get_node("CollisionShape2D").shape.radius = MAX_SIZE
    Common.world.add_child(bang)

static func create_from_shot(pos:Vector2):
    create(pos, Source.SHOT)

static func create_from_missile(pos:Vector2):
    create(pos, Source.MISSILE)

func _process(delta:float) -> void:
    self.progress += delta / DURATION
    if progress < 1.0:
        self.size = MAX_SIZE * maxf(0, sin(progress * PI))
        self.destroy_nearby_missiles()
        queue_redraw()
    else:
        queue_free()

func _draw() -> void:
    var color:Color
    match self.source:
        Source.SHOT:
            color = Color(
                maxf(1 - progress * 2, progress * 2 - 1.0), # red
                1 - progress * 2, # green
                1.0, # blue,
                .75 - progress * 0.5, # alpha
            )
        Source.MISSILE:
            color = Color(
                1.0 - progress, # red
                maxf(0.0, progress * 2 - 0.5), # green
                1.0 - progress, # blue
                .75 - progress * 0.5, # alpha
            )
    draw_circle(Vector2.ZERO, self.size, color)
    if Common.DEBUG:
        draw_arc(Vector2.ZERO, MAX_SIZE, 0, TAU, 20, Color.DARK_MAGENTA)

func on_entered(missile:Missile):
    self.nearby_missiles.append(missile)

func on_leave(missile:Missile):
    self.nearby_missiles.erase(missile)

func destroy_nearby_missiles() -> void:
    var valid_missiles:Array[Missile] = []
    for missile:Missile in self.nearby_missiles:
        if is_instance_valid(missile):
            if self.position.distance_to(missile.position) < self.size:
                missile.destroy()
                BangSky.create_from_missile(missile.position)
            else:
                valid_missiles.append(missile)
    self.nearby_missiles = valid_missiles

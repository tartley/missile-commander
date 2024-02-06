"""
The explosion from shots or missiles detonating in the sky.
"""
class_name BangSky extends Node2D

const MAX_SIZE := 150.0 # world co-ords
const DURATION := 2.5 # seconds

var BangSkyScene:PackedScene = preload("res://src/bang_sky/bang_sky.tscn")

var progress:float = 0.0 # [0..1]
var size:float = 0.0 # [0..MAX_SIZE]
var source:Source # What caused this Bang?
var nearby_missiles:Array[Missile]

enum Source {SHOT, MISSILE}

func init(position_:Vector2, source_:Source) -> void:
    self.name = Common.get_unique_name(self)
    self.position = position_
    self.source = source_
    $CollisionShape2D.shape.radius = MAX_SIZE

func init_from_shot(position_:Vector2) -> void:
    self.init(position_, Source.SHOT)

func init_from_missile(position_:Vector2) -> void:
    self.init(position_, Source.MISSILE)

func _process(delta:float) -> void:
    self.progress += delta / DURATION
    self.size = MAX_SIZE * (0.1 + 0.9 * sin(progress * PI))
    queue_redraw()
    self.destroy_nearby_missiles()
    if progress >= 1.0:
        queue_free()

func _draw() -> void:
    var color:Color
    match self.source:
        Source.SHOT:
            color = Color(
                maxf(1 - progress * 2, progress * 2 - 1.5), # red
                1 - progress * 2, # green
                1.0, # blue,
                1 - progress * 0.75, # alpha
            )
        Source.MISSILE:
            color = Color(
                1.0 - progress, # red
                maxf(0.0, progress - 0.5), # green
                1.0 - progress, # blue
                1 - progress * 0.75, # alpha
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
                self.nearby_missiles.erase(missile)
                missile.destroy()
                # create an explosion
                # TODO should this be in missile.destroy?
                # but then missile has to choose between bangsky and bangground and bangfeature
                var main:Main = get_parent()
                var bangsky = BangSkyScene.instantiate()
                bangsky.init_from_missile(missile.position)
                main.call_deferred("add_child", bangsky)
            else:
                valid_missiles.append(missile)
    self.nearby_missiles = valid_missiles

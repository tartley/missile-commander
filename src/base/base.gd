extends Node2D
var Shot:PackedScene = preload("res://src/shot/shot.tscn")

var destroyed: bool:
    set(value):
        $Foundation.destroyed = value
        $Turret.destroyed = value
        destroyed = value

# We use a reference to the mouse to swivel our turret towards it
var mouse:Node2D

func _ready():
    self.destroyed = false
    $Turret.position = Vector2(0, 20)

func _process(_delta:float):
    if not self.destroyed:
        var global = to_global($Turret.position)
        var relative = mouse.position - Vector2(global.x, -global.y)
        $Turret.rotation = relative.angle() - PI / 2 - self.rotation

func launch(dest:Vector2):
    if not self.destroyed:
        var shot = Shot.instantiate()
        # stupid -y thing here:
        var pos = to_global($Turret.position)
        pos.y *= -1
        shot.position = pos
        shot.destination = dest
        return shot
    else:
        return null


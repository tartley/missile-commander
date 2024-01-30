extends Node2D

const SIZE := 100.0

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
    $Turret.size = SIZE
    $Foundation.size = SIZE
    $Turret.position = Vector2(0, SIZE / 4)
    self.add_to_group("bases")

func _process(_delta:float):
    if not self.destroyed:
        var global = to_global($Turret.position)
        var relative = mouse.position - Vector2(global.x, global.y)
        $Turret.rotation = relative.angle() - self.rotation

func launch(dest:Vector2):
    if not self.destroyed:
        var shot = Shot.instantiate()
        shot.position = to_global($Turret.position)
        shot.destination = dest
        return shot
    else:
        return null


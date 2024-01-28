extends Node2D

var destroyed: bool:
    set(value):
        $Foundation.destroyed = value
        $Turret.destroyed = value
        destroyed = value

# We use a reference to the mouse to swivel our turret towards it
var mouse:Node2D

func _ready():
    self.destroyed = false

func _process(_delta:float):
    if not self.destroyed:
        var global = to_global(Vector2.ZERO)
        var relative = mouse.position - Vector2(global.x, -global.y)
        $Turret.rotation = relative.angle() - PI / 2 - self.rotation

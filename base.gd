extends Node2D

const SIZE := 50.0
const original_verts:Array[Vector2] = [
    Vector2(0, -SIZE/2), # bottom
    Vector2(-SIZE/2, 0), # left
    Vector2(-SIZE/8, SIZE/4), # barrel base left
    Vector2(-SIZE/8, SIZE), # barrel tip left
    Vector2(SIZE/8, SIZE), # barrrel tip right
    Vector2(SIZE/8, SIZE/4), # barrel base right
    Vector2(+SIZE/2, 0), # right
    Vector2(0, -SIZE/2), # bottom
]

var verts:Array[Vector2]
var color:Color
var destroyed: bool:
    set(value):
        if not value:
            self.verts = original_verts.duplicate()
            self.color = Color.YELLOW
        else:
            for _i in randi_range(0, 3):
                var index = randi_range(1, len(self.verts) - 2)
                self.verts.remove_at(index)
            self.color = Color(.3, .3, .3)
        destroyed = value
        self.queue_redraw()

# We use a reference to the mouse to swivel our turrets towards it
var mouse:Node2D
    
func _ready():
    self.destroyed = false
    self.position += Vector2(0, -SIZE/9)
    
func _draw():
    draw_polygon(self.verts, [Color.BLACK])
    draw_polyline(self.verts, self.color, 4.0, true)

func _process(_delta:float):
    if not self.destroyed:
        var global = to_global(Vector2.ZERO)
        global.y *= -1
        var relative = mouse.position - global
        self.rotation = relative.angle() - PI / 2

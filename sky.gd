extends Node2D
    
func _draw():
    var random = RandomNumberGenerator.new()
    var verts: Array[Vector2] = []
    var x: int
    var y: int
    var size:float
    var bright: float
    for i in range(100):
        x = random.randi_range(-5400, 5400)
        y = random.randi_range(22500, 27500)
        size = random.randf_range(2, 8.0)
        bright = random.randf_range(0.5, 1.0)
        verts.append(Vector2(x, y))
        verts.append(Vector2(x + size, y))
    draw_multiline(verts, Color(bright, bright, bright), size)

extends Node2D

func _draw():
    var random = RandomNumberGenerator.new()
    var verts: Array[Vector2]
    var x: int
    var y: int
    for i in range(100):
        x = random.randi_range(-1000, 1000)
        y = random.randi_range(0, 1000)
        verts.append(Vector2(x, y))
        verts.append(Vector2(x+1, y))
    draw_multiline(verts, Color(1, 1, 1), 3.0)

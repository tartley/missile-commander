extends Node2D

const SCROLL_SPEED := 0.1

var _random = RandomNumberGenerator.new()

func _draw():
    var verts: Array[Vector2] = []
    var colors: Array[Color] = []
    var x: int
    var y: int
    var size:float
    var bright: float
    for i in range(10000):
        x = _random.randi_range(-5400, 5400)
        y = _random.randi_range(%Ground.RADIUS * 0.9, %Ground.RADIUS + get_viewport_rect().size.y * 0.9)
        size = _random.randf_range(5.0, 8.0)
        bright = _random.randf_range(0.5, 1.0)
        verts.append(Vector2(x, y))
        verts.append(Vector2(x + size, y))
        colors.append(Color(bright, bright, bright))
    draw_multiline_colors(verts, colors, size)

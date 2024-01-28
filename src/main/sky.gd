extends Node2D

var ground:Node2D

func _draw():
    var verts: Array[Vector2] = []
    var colors: Array[Color] = []
    var x: float
    var y: float
    var size:float
    for i in range(1000):
        x = randf_range(-2800.0, 2800.0)
        y = randf_range(
            ground.RADIUS - get_viewport_rect().size.y * 0.14,
            ground.RADIUS + get_viewport_rect().size.y * 1.04
        )
        size = randf_range(2.0, 6.0)
        verts.append(Vector2(x, y))
        verts.append(Vector2(x + size, y))
        var red = randf_range(0.0, 1.0) ** 0.2
        var blue = randf_range(0.0, 1.0) ** 0.2
        var green = min(red, blue)
        colors.append(Color(red, green, blue))
    draw_multiline_colors(verts, colors, 4.0)

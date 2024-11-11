extends Node2D

const STAR_COUNT := 1000

func get_star_verts() -> Array[Vector2]:
    var x := randf_range(-2800.0, 2800.0)
    var y: = randf_range(
        -Ground.RADIUS + get_viewport_rect().size.y * 0.14,
        -Ground.RADIUS - get_viewport_rect().size.y * 1.04
    )
    var size := randf_range(2.0, 6.0)
    return [
        Vector2(x, y),
        Vector2(x + size, y),
    ]

func get_stars_verts(count:int) -> Array[Vector2]:
    var verts: Array[Vector2] = []
    for _i in range(count):
        verts.append_array(get_star_verts())
    return verts

func get_star_color() -> Color:
    var color:Color
    var bright:float
    bright = randf()
    if bright > 0.1:
        color = Color(bright, bright - 0.05, bright)
    else:
        var red := randf_range(0.0, 0.9) ** 0.2
        var blue := randf_range(0.0, 1.0) ** 0.2
        var green:float = min(red, blue)
        color = Color(red, green, blue)
    return color

func get_stars_colors(count:int) -> Array[Color]:
    var colors: Array[Color] = []
    for _i in range(count):
        colors.append(get_star_color())
    return colors

func _draw():
    draw_multiline_colors(get_stars_verts(STAR_COUNT), get_stars_colors(STAR_COUNT), 4.0)

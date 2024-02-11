extends Node2D

const SIZE := 8.0
const FORE := Color.GRAY

var count := 15

func get_verts() -> Array[Vector2]:
    """A single triangle pointing along +y"""
    return [
        Vector2(0, SIZE/2),
        Vector2(-SIZE/2, -SIZE/2),
        Vector2(+SIZE/2, -SIZE/2),
        Vector2(0, SIZE/2),
    ]

func offset_verts(offset, verts):
    var result:Array[Vector2] = []
    for v in verts:
        result.append(v + offset)
    return result

func get_offset(index:int) -> Vector2:
    """Convert an ammo index (0-15), return the co-ordinates that ammo should be drawn at below it's base"""
    assert(0 <= index and index <= 14, "Ammo.get_offset index {0} out of range".format([index]))
    var x:int
    var y:int
    if index >= 14:
        y = -5
        x = 0
    elif index >= 12:
        y = -4
        x = index * 2 - 25
    elif index >= 9:
        y = -3
        x = index * 2 - 20
    elif index >= 5:
        y = -2
        x = index * 2 - 13
    else:
        y = -1
        x = index * 2 - 4
    return Vector2(x * SIZE * 2, y * SIZE * 3)

func _draw():
    for i in range(self.count):
        draw_polyline(offset_verts(get_offset(i), get_verts()), FORE, 3.0)

extends Node2D

const SIZE := 8.0
const FORE := Color.GRAY
const MAX := 10

var count : int = MAX:
    set(value):
        assert(0 <= value and value <= MAX)
        count = value
        queue_redraw()

func _draw():
    for i in range(self.count):
        draw_polyline(offset_verts(get_offset(i), get_verts()), FORE, 3.0)

func decrement():
    assert(self.count > 0)
    self.count -= 1

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
    """Convert an ammo index (0-14) into co-ordinates at which that ammo should be drawn"""
    assert(0 <= index and index < MAX, "Ammo.get_offset index {0} out of range".format([index]))
    var x:int
    var y:int
    if index >= 9: # >=12  i in [12, 13]       [9]
        y = -4
        x = 0
    elif index >= 7: # >=9  i in [9, 10, 11]      [7, 8]
        y = -3
        x = 15 - index * 2
    elif index >= 4: # i>=5  i in [5, 6, 7, 8]    [4, 5, 6]
        y = -2
        x = 10 - index * 2
    else: # i==0  i in [0, 1, 2, 3, 4]            [0, 1, 2, 3]
        y = -1
        x = 3 - index * 2
    return Vector2(x * SIZE * 2, y * SIZE * 3)

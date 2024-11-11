class_name Score extends Node2D

const BOMB_DESTROYED := 10

const font_size := 48
const font_color := Color.DIM_GRAY

var value:int:
    set(new):
        value = new
        self.queue_redraw()

func _ready() -> void:
    Common.score = self
    self.position = Vector2(0, -Ground.RADIUS * 0.993)
    self.reset()

func _draw() -> void:
    var msg := format(value)
    var text_size := Common.font.get_string_size(msg, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size)
    var posn := Vector2(-text_size.x/2, 0)
    draw_string(Common.font, posn, msg, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, font_color)

func reset():
    self.value = 0

func add(amount:int):
    self.value += amount

func format(number:int, separator:String=" ") -> String:
    # Format positive integers with "thin space" thousands separators
    var text := "%02d" % number
    var chunks := []
    var chunk:String
    var start:int
    var end = len(text)
    while end > 0:
        start = end - 3
        if start < 0:
            start = 0
        chunk = text.substr(start, end)
        chunks.push_back(chunk)
        end -= 3
    chunks.reverse()
    return separator.join(chunks)

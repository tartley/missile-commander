class_name Labeller extends Node

var target:Node
var current:Vector2
var line_spacing := 1.5

func _ready():
    self.current = get_viewport().get_visible_rect().get_center()

func add(text:String, font_size:int, color:Color, relpos:Vector2=Vector2.INF, newline:bool=true) -> Label:
    var rect := get_viewport().get_visible_rect()
    var pos:Vector2
    if relpos == Vector2.INF:
        pos = current
    else:
        pos = Vector2(rect.end.x * relpos.x, rect.end.y * relpos.y)
    var label_size := Common.font.get_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size)
    var label := Label.new()
    label.text = text
    label.position = pos - label_size / 2
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    var settings := LabelSettings.new()
    settings.font = Common.font
    settings.font_size = font_size
    settings.font_color = color
    label.label_settings = settings
    target.add_child(label)
    if newline:
        self.current = Vector2(rect.end.x / 2, pos.y + label_size.y * self.line_spacing)
    else:
        self.current += Vector2(label_size.x / 2, 0)
    return label

func remove_all_labels() -> void:
    # TODO: only remove the labels
    # TODO: only remove the labels we added
    for label:Label in target.get_children():
        target.remove_child(label)
        label.queue_free()

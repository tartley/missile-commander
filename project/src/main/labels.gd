class_name Labels extends Node2D

func _ready() -> void:
    Common.labels = self

func add(text:String, pos:Vector2, font_size:int, color:Color) -> Label:
    var size := Common.font.get_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size)
    var label := Label.new()
    label.text = text
    label.position = Vector2(pos.x - size.x / 2, pos.y)
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    var settings := LabelSettings.new()
    settings.font = Common.font
    settings.font_size = font_size
    settings.font_color = color
    label.label_settings = settings
    add_child(label)
    return label

func remove_all() -> void:
    for label in get_children():
        remove_child(label)
        label.queue_free()

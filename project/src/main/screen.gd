"""
A container for UI elements
"""
class_name Screen extends Node

func _ready():
    # Make this node available from everywhere
    Common.screen = self

func add_label(text:String, relpos:Vector2, font_size:int, color:Color) -> Label:
    var label_size := Common.font.get_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size)
    var label := Label.new()
    label.text = text
    var viewport := get_viewport().get_visible_rect()
    label.position = Vector2(viewport.end.x * relpos.x - label_size.x / 2, viewport.end.y * relpos.y - label_size.y / 2)
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    var settings := LabelSettings.new()
    settings.font = Common.font
    settings.font_size = font_size
    settings.font_color = color
    label.label_settings = settings
    add_child(label)
    return label

func remove_all_labels() -> void:
    for label in get_children():
        remove_child(label)
        label.queue_free()

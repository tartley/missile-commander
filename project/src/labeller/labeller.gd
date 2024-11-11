class_name Labeller extends Node

var target:Node
var extent:Rect2
var curpos:Vector2

var line_spacing := 1.25

func init(target_):
    self.target = target_
    self.extent = target.get_viewport().get_visible_rect()
    self.curpos = self.extent.get_center()

func get_label(text:String, font_size:int, color:Color) -> Label:
    var label := Label.new()
    label.text = text
    var settings := LabelSettings.new()
    settings.font = Common.font
    settings.font_size = font_size
    settings.font_color = color
    label.label_settings = settings
    return label

func add_centered(labels:Array, rel_y:float=-1):
    # Where rel_y=0 means top of screen, rel_y=1 means bottom of screen.

    # width of all labels placed side-by-side
    var width:=0.0
    for label in labels:
        width += Common.font.get_string_size(label.text, HORIZONTAL_ALIGNMENT_CENTER, -1, label.label_settings.font_size).x

    # Set current to where we should place these labels
    if rel_y != -1:
        self.curpos = Vector2(self.extent.end.x / 2, self.extent.end.y * rel_y)
    else:
        self.curpos.x = self.extent.end.x / 2
    self.curpos.x -= width / 2

    # add each label in turn at the correct x ordinate
    var max_height := 0.0
    for label in labels:
        label.position = self.curpos
        label.grow_horizontal = Control.GROW_DIRECTION_END
        target.add_child(label)
        self.curpos += Vector2(label.size.x, 0)
        max_height = max(max_height, label.size.y)
    # remember new position for next call
    self.curpos += Vector2(0, max_height * line_spacing)

func remove_all_labels() -> void:
    for label:Label in target.get_children():
        target.remove_child(label)
        label.queue_free()

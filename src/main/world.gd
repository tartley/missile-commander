class_name World extends Node

func _ready():
    # Make this node available from everywhere
    Common.world = get_tree().root.get_node("Main/World")

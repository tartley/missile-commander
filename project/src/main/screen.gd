"""
A container for UI elements
"""
class_name Screen extends Node

func _ready():
    # Make this node available from everywhere
    Main.screen = self

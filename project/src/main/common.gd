class_name Common extends Node

const font:FontFile = preload("res://fonts/Orbitron.light.otf")
const font_bold:FontFile = preload("res://fonts/Orbitron.black.otf")

# Populated in respective _ready handlers
static var score:Score
static var screen:Screen
static var world:World

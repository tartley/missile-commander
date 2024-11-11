class_name Common extends Node

# The ground is a pizza-slice shaped segment of a circular planet, centered at (0, 0), with:
const RADIUS := 12000.0
# extending for PLANET_ANGLE radians on either side of 'straight up':
const PLANET_ANGLE := PI / 16.0

const font:FontFile = preload("res://fonts/Orbitron.light.otf")
const font_bold:FontFile = preload("res://fonts/Orbitron.black.otf")

# Populated in respective _ready handlers
static var score:Score
static var screen:Screen
static var world:World

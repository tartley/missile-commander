class_name Common extends Node

# Draw a few on-screen debug hints
const DEBUG := false

# The ground is a pizza-slice shaped segment of a circular planet, centered at (0, 0), with:
const RADIUS := 12000.0
# extending for PLANET_ANGLE radians on either side of 'straight up':
const PLANET_ANGLE := PI / 16.0

const font:FontFile = preload("res://fonts/Orbitron-Medium.otf")

# Populated in respective _ready handlers
static var score:Score
static var screen:Screen
static var world:World
static var labels:Labels

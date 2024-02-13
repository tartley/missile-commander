class_name Common extends Node

# Draw a few on-screen debug hints
const DEBUG := false

# The ground is a pizza-slice shaped segment of a circular planet, centered at (0, 0), with:
const RADIUS := 12000.0
# extending for PLANET_ANGLE radians on either side of 'straight up':
const PLANET_ANGLE := PI / 16.0

# Populated in respective _ready handler
static var world:World

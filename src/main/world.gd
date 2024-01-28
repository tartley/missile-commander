extends Node2D

func _ready():
    # Inject dependencies
    $Ground.mouse = $Mouse
    $Sky.ground = $Ground
    # Also $Mouse needs to know $Ground,
    # But we do that as a global name because I'm too lazy to figure out the dependencies

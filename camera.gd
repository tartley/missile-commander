extends Camera2D

func _ready():
    zoom = Vector2(0.5, 0.5) # TODO Is this deliberate?

func _process(_delta):
    if Engine.is_editor_hint():
        # TODO draw extents
        pass
    else:
        position.x = %Mouse.position.x / 3.6
        position.y = %Ground.RADIUS + get_viewport_rect().size.y * 0.8 + (%Mouse.position.y - %Ground.RADIUS) * 0.1
        rotation = position.x / -20000
        

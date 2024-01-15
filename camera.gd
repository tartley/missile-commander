extends Camera2D

const PAN := true

func _ready():
    zoom = Vector2(0.5, 0.5) # TODO Is this deliberate?

func _process(_delta):
    if Engine.is_editor_hint():
        # TODO draw extents
        pass
    else:
        var pos := Vector2(0, %Ground.RADIUS + get_viewport_rect().size.y * 0.8)
        if PAN:
            pos += Vector2(%Mouse.position.x / 3.6, (%Mouse.position.y - %Ground.RADIUS) * 0.1)
            rotation = position.x / -20000
        position = pos
        

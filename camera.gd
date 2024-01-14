@tool
extends Camera2D

func _process(_delta):
    if Engine.is_editor_hint():
        # TODO draw extents
        pass
    else:
        # TODO pan left/right
        position.x = 0
        # TODO pan up/down
        position.y = %Ground.RADIUS + get_viewport_rect().size.y * 0.8
        # TODO rotate as we pan
        #rotation = %mouse.position.x / 1500
        zoom = Vector2(0.5, 0.5)


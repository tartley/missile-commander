class_name TitleScreen extends Node

func _unhandled_input(event:InputEvent):
    if event is InputEventKey and event.pressed and not event.echo:
        match event.keycode:
            KEY_A:
                queue_free()
            KEY_W:
                queue_free()
            KEY_S:
                queue_free()
            KEY_D:
                queue_free()
            _:
                pass

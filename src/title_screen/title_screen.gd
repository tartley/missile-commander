class_name TitleScreen extends Node

func _unhandled_input(event:InputEvent):
    print("TitleScreen._unhandled_input")
    if event is InputEventKey and event.pressed and not event.echo:
        match event.keycode:
            KEY_A:
                exit()
            KEY_W:
                exit()
            KEY_S:
                exit()
            KEY_D:
                exit()
            _:
                pass

func exit():
    print("TitleScreen.exit")
    queue_free()

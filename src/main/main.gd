class_name Main extends Node

const TitleScreenScene:PackedScene = preload("res://src/title_screen/title_screen.tscn")
const GameScene:PackedScene = preload("res://src/game/game.tscn")

func _ready():
    # Inject dependencies
    # TODO A lot of things need Mouse injecting. Should it be globally available? Like main is?
    $World/Camera.mouse = $World/Mouse
    for base in get_tree().get_nodes_in_group("bases"):
        base.mouse = $World/Mouse

    # Begin by showing the title screen
    var title_screen:TitleScreen = TitleScreenScene.instantiate()
    title_screen.tree_exited.connect(on_title_screen_exit)
    add_child(title_screen)

func _unhandled_input(event:InputEvent):
    if event is InputEventKey and event.pressed and not event.echo:
        match event.keycode:
            KEY_ESCAPE:
                get_tree().quit()
            _:
                pass

func on_title_screen_exit():
    var game = GameScene.instantiate()
    game.mouse = $World/Mouse
    add_child.call_deferred(game)

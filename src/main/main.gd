class_name Main extends Node

const TitleScreenScene:PackedScene = preload("res://src/title_screen/title_screen.tscn")
const GameScene:PackedScene = preload("res://src/game/game.tscn")

func _ready() -> void:
    # Inject dependencies
    $Camera.mouse = $Mouse
    for base in get_tree().get_nodes_in_group("bases"):
        base.mouse = $Mouse

    # Begin by showing the title screen
    add_child(TitleScreenScene.instantiate())

func _unhandled_input(event:InputEvent):
    if event is InputEventKey and event.pressed and not event.echo:
        match event.keycode:
            KEY_ESCAPE:
                get_tree().quit()
            _:
                pass

func on_child_exit(node:Node):
    print("Main.titlescreen_exit ", node, " ", typeof(node), ":", TitleScreen)
    if node is TitleScreen:
        var game = GameScene.instantiate()
        game.mouse = $Mouse
        add_child.call_deferred(game)
    else:
        print("no")

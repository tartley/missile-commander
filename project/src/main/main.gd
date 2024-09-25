class_name Main extends Node

const TitleScreenScene:PackedScene = preload("res://src/title_screen/title_screen.tscn")
const GameScene:PackedScene = preload("res://src/game/game.tscn")
const GameOverScene:PackedScene = preload("res://src/game_over/game_over.tscn")

static var exiting := false

func _ready():
    # Inject dependencies
    # TODO A lot of things need Mouse injecting. Should it be globally available? Like main is?
    $World/Camera.mouse = $World/Mouse
    for base in Base.all:
        base.mouse = $World/Mouse
    show_title_screen()

func _unhandled_input(event:InputEvent):
    if event is InputEventKey and event.pressed and not event.echo:
        match event.keycode:
            KEY_ESCAPE:
                exit()

func exit():
    Main.exiting = true
    get_tree().quit()

func show_title_screen():
    var title_screen:TitleScreen = TitleScreenScene.instantiate()
    title_screen.tree_exited.connect(start_game)
    Common.screen.add_child.call_deferred(title_screen)

func start_game():
    if Main.exiting:
        return
    # start the game
    var game = GameScene.instantiate()
    game.mouse = $World/Mouse
    game.ground = $World/Ground
    game.tree_exited.connect(on_game_exit)
    add_child.call_deferred(game)

func on_game_exit():
    var game_over:GameOver = GameOverScene.instantiate()
    game_over.tree_exited.connect(on_game_over_exit)
    Common.screen.add_child(game_over)

func on_game_over_exit():
    show_title_screen()

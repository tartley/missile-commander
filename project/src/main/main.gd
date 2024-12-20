class_name Main extends Node

const TitleScreenScene:PackedScene = preload("res://src/title_screen/title_screen.tscn")
const GameScene:PackedScene = preload("res://src/game/game.tscn")
const GameOverScene:PackedScene = preload("res://src/game_over/game_over.tscn")
const font:FontFile = preload("res://fonts/Orbitron.light.otf")
const font_bold:FontFile = preload("res://fonts/Orbitron.black.otf")

# Draw a few on-screen debug hints
const DEBUG := false

# Populated in respective _ready handlers
static var score:Score
static var screen:Screen
static var world:World

static var exiting := false

func _ready():
    $World/Camera.cursor = $World/Cursor
    for base in Base.all:
        base.cursor = $World/Cursor
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
    Main.screen.add_child.call_deferred(title_screen)

func start_game():
    if Main.exiting:
        return
    # start the game
    var game = GameScene.instantiate()
    game.cursor = $World/Cursor
    game.tree_exited.connect(on_game_exit)
    add_child.call_deferred(game)

func on_game_exit():
    var game_over:GameOver = GameOverScene.instantiate()
    game_over.tree_exited.connect(on_game_over_exit)
    Main.screen.add_child(game_over)

func on_game_over_exit():
    show_title_screen()

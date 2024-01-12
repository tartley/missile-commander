extends Camera2D

func _process(delta):
    var mouse := get_node("/root/game/mouse")
    position.x = mouse.position.x / 10
    rotation = mouse.position.x / -150000

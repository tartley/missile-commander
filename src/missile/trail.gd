class_name Trail extends CPUParticles2D

func _ready():
    self.add_to_group("trails")

func on_finished() -> void:
    queue_free()

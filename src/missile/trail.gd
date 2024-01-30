class_name Trail extends CPUParticles2D

func _ready():
    self.name = Common.get_unique_name(self)

func on_finished() -> void:
    queue_free()

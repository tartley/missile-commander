extends CPUParticles2D

func on_finished() -> void:
    queue_free()

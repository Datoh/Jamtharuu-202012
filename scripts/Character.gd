extends Sprite

signal animation_finished(anim_name)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
  emit_signal("animation_finished", anim_name)

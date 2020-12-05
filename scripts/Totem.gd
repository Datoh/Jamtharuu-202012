extends Area2D

signal on_totem_touched(player, totem)

func _on_Totem_body_entered(body: Node) -> void:
  emit_signal("on_totem_touched", body, self)

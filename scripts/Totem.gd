extends Area2D

signal on_totem_touched(player, totem)

var rng = RandomNumberGenerator.new()

func _ready() -> void:
  rng.randomize()
  prepare_random_anim()
  
  
func prepare_random_anim() -> void:
  $Timer.wait_time = rng.randf_range(1.0, 5.0)
  $Timer.start()
 
  
func _on_Totem_body_entered(body: Node) -> void:
  emit_signal("on_totem_touched", body, self)


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
  prepare_random_anim()


func _on_Timer_timeout() -> void:
  var anim_index = rng.randi_range(0, 2)
  $AnimationPlayer.play("idle" + str(anim_index))

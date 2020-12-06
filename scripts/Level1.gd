extends Node2D

export (int) var NB_BOT := 50
export (int) var level_duration := 180

onready var time = find_node("Time")

var scores_label = {}

func _ready() -> void:
  var move_area_size = $MoveableArea/CollisionShape2D.shape.extents
  var move_area_position = $MoveableArea/CollisionShape2D.get_global_position() - move_area_size
  move_area_size = move_area_size * 2
  var move_area = Rect2(move_area_position, move_area_size)
  
  for _i in range(NB_BOT):
    $Objects.add_child(preload("res://scenes/Bot.tscn").instance())
  
  for object in $Objects.get_children():
    if object.is_in_group("character"):
      object.init_position(move_area)
      
  scores_label[find_node("Player1")] = find_node("ScorePlayer1")
  scores_label[find_node("Player2")] = find_node("ScorePlayer2")
  scores_label[find_node("Player3")] = find_node("ScorePlayer3")
  scores_label[find_node("Player4")] = find_node("ScorePlayer4")
  
  find_node("TimerTimeLeft").start()
  set_time()


func _on_totem_touched(player, totem) -> void:
  if player.touch_totem(totem):
    scores_label[player].text = str(player.totem_touched_count)
    print(player, " ", player.totem_touched_count)


func _on_TimerTimeLeft_timeout() -> void:
  level_duration -= 1
  set_time()
  if level_duration == 0:
    end()
  
func set_time() -> void:
  var seconds = level_duration % 60
  var minutes = (level_duration - seconds) / 60
  time.text = str(minutes) + ":" + str(seconds).pad_zeros(2)


func _on_smoke(position) -> void:
  var smoke = preload("res://scenes/Smoke.tscn").instance()
  smoke.position = position
  find_node("Smokes").add_child(smoke)


func _on_player_die(player) -> void:
  var players_alive = 0
  for player in get_tree().get_nodes_in_group("player"):
    players_alive += 1 if player.alive else 0
  if players_alive < 2:
    end()


func end() -> void:
  var winner = null
  var draw := false
  for player in get_tree().get_nodes_in_group("player"):
    if player.alive:
      if winner != null and winner.score == player.score:
        draw = true
      elif winner == null or winner.score < player.score:
        draw = false
        winner = player
  if draw:
    print("draw")
  else:
    print("winner is: ", winner)


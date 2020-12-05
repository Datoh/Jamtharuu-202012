extends Node2D

export (int) var NB_BOT := 50

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


func _on_totem_touched(player, totem) -> void:
  if player.touch_totem(totem):
    scores_label[player].text = str(player.totem_touched_count)
    print(player, " ", player.totem_touched_count)

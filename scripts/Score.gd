extends MarginContainer

func _ready() -> void:
  find_node("ColorSwitch").visible = Global.color_switch

  if Global.winner != -1:
    Global.players_scores[Global.winner] += 1
  
  find_node("Draw").visible = Global.winner == -1
  find_node("Winner1").visible = Global.winner == 0
  find_node("Winner2").visible = Global.winner == 1
  find_node("Winner3").visible = Global.winner == 2
  find_node("Winner4").visible = Global.winner == 3
  for i in range(Global.players_input_id.size()):
    find_node("Score" + str(i+1)).text = str(Global.players_scores[i])
    find_node("MarginContainer" + str(i+1)).visible = Global.players_input_id[i] != -1
    find_node("Score" + str(i+1)).visible = Global.players_input_id[i] != -1


func _physics_process(delta: float) -> void:
  if Input.is_action_just_pressed("ui_color") or Input.is_action_just_pressed("ui_back_1") or Input.is_action_just_pressed("ui_back_2") or Input.is_action_just_pressed("ui_back_3"):
    Global.color_switch = !Global.color_switch
    find_node("ColorSwitch").visible = Global.color_switch
  for id in Global.players_input_id:
    if id != -1 and Input.is_action_just_pressed("ui_fight_" + str(id)):
      get_tree().change_scene("res://scenes/Level1.tscn")
    if id != -1 and Input.is_action_just_pressed("ui_back_" + str(id)):
      get_tree().change_scene("res://scenes/Lobby.tscn")

extends MarginContainer

var next_player := 0
var ready_to_start := false

func _ready() -> void:
  Global.players_input_id = [ -1, -1, -1, -1]
  Global.players_scores = [ 0, 0, 0, 0]
  find_node("ColorSwitch").visible = Global.color_switch


func _physics_process(_delta: float) -> void:
  if Input.is_action_just_pressed("ui_back_0") or Input.is_action_just_pressed("ui_back_1") or Input.is_action_just_pressed("ui_back_2") or Input.is_action_just_pressed("ui_back_3"):
    get_tree().quit()
  if Input.is_action_just_pressed("ui_color") or Input.is_action_just_pressed("ui_back_1") or Input.is_action_just_pressed("ui_back_2") or Input.is_action_just_pressed("ui_back_3"):
    Global.color_switch = !Global.color_switch
    find_node("ColorSwitch").visible = Global.color_switch

  var input_id := -1
  if Input.is_action_just_pressed("ui_fight_0"):
    input_id = 0
  elif Input.is_action_just_pressed("ui_fight_1"):
    input_id = 1
  elif Input.is_action_just_pressed("ui_fight_2"):
    input_id = 2
  elif Input.is_action_just_pressed("ui_fight_3"):
    input_id = 3
  
  if ready_to_start:
    for id in Global.players_input_id:
      if id != -1 and Input.is_action_just_pressed("ui_start_" + str(id)):
        get_tree().change_scene("res://scenes/Level1.tscn")
  
  if input_id != -1: # Check id is not used yep
    for id in Global.players_input_id:
      if id == input_id:
        input_id = -1
  
  if input_id != -1:
    Global.players_input_id[next_player] = input_id
    find_node("Sprite" + str(next_player + 1)).visible = true
    find_node("LabelPressButton" + str(next_player + 1)).visible = false
    next_player += 1
    if next_player == 2:
      find_node("Start").visible = true
      ready_to_start = true

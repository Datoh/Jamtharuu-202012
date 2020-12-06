extends KinematicBody2D

export (float) var speed := 200
export (int) var smoke_count := 10

enum State {MOVING, DIYNG, DIED, LAUNCHING_SMOKE, APPLYING_SMOKE, FIGHTING, FIGHTING_RESULT}
var state = State.MOVING

signal smoke(position)
signal player_die(player)

onready var animation_player = find_node("AnimationPlayer")
onready var sprite = find_node("Character")
onready var weapon_area = find_node("WeaponArea")

var rng = RandomNumberGenerator.new()
var totem_touched: Node2D = null
var totem_touched_count := 0
var alive := false

var input_id = -1

func _ready() -> void:
  rng.randomize()


func init_position(move_area: Rect2) -> void:
  position.x = move_area.position.x + rng.randf_range(0.0, move_area.size.x)
  position.y = move_area.position.y + rng.randf_range(0.0, move_area.size.y)


func touch_totem(totem: Node2D) -> bool:
  var is_new = totem != totem_touched
  totem_touched_count += 1 if is_new else 0
  totem_touched = totem
  return is_new


func _physics_process(delta: float) -> void:
  if state == State.MOVING:
    var velocity := Vector2()
    if input_id == 4:   #keyboard
      velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    elif input_id != 4: #joystick
      var axis_x_input := Input.get_joy_axis(input_id, JOY_AXIS_0)
      velocity.x += axis_x_input if abs(axis_x_input) > 0.1 else 0.0;
    if input_id == 4:   #keyboard
      velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
    elif input_id != 4: #joystick
      var axis_y_input := Input.get_joy_axis(input_id, JOY_AXIS_1)
      velocity.y += axis_y_input if abs(axis_y_input) > 0.1 else 0.0;
    velocity = velocity.normalized() * speed
    move_and_collide(velocity * delta)
    
    var anim = "idle" if velocity == Vector2.ZERO else "move"
    if animation_player.current_animation != anim:
      animation_player.play(anim)
    if velocity != Vector2.ZERO:
      sprite.scale.x = 1 if velocity.x > 0 else -1

    if smoke_count > 0 and Input.is_action_just_pressed("ui_smoke_" + str(input_id)):
      launch_smoke()
    
    if Input.is_action_just_pressed("ui_fight_" + str(input_id)):
      fight()
  

func next_state() -> void:
  match state:
    State.LAUNCHING_SMOKE:
      apply_smoke()
    State.APPLYING_SMOKE:
      move()
    State.FIGHTING:
      fight_result()
    State.FIGHTING_RESULT:
      move()
    State.DIYNG:
      remove()


func move() -> void:
  state = State.MOVING
  animation_player.play("move")


func fight() -> void:
  state = State.FIGHTING
  animation_player.play("fight")
  weapon_area.scale = sprite.scale
  weapon_area.monitoring = true


func die() -> void:
  if state == State.DIYNG or state == State.DIED:
    return
  state = State.DIYNG
  alive = false
  animation_player.play("die")


func remove() -> void:
  state = State.DIED
  emit_signal("player_die", self)
  

func fight_result() -> void:
  state = State.MOVING
  weapon_area.monitoring = false


func launch_smoke() -> void:
  state = State.LAUNCHING_SMOKE
  smoke_count -= 1
  animation_player.play("smoke")


func apply_smoke() -> void:
  state = State.APPLYING_SMOKE
  emit_signal("smoke", position)
  next_state()


func _on_animation_finished(anim_name) -> void:
  next_state()


func _on_WeaponArea_area_entered(area: Area2D) -> void:
  var player = area.get_parent()
  if player != self:
    player.die()

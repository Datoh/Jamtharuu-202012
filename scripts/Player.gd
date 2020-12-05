extends KinematicBody2D

export (float) var speed := 200

enum State {MOVING, DIYNG, SMOKING, FIGHTING}

var rng = RandomNumberGenerator.new()
var totem_touched: Node2D = null
var totem_touched_count := 0

export (int, -1, 3) var input_id = -1

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
  var velocity := Vector2()
  if input_id == -1:
    velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
  else:
    var axis_x_input := Input.get_joy_axis(input_id, JOY_AXIS_0)
    velocity.x += axis_x_input if abs(axis_x_input) > 0.1 else 0.0;
  if input_id == -1:
    velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
  else:
    var axis_y_input := Input.get_joy_axis(input_id, JOY_AXIS_1)
    velocity.y += axis_y_input if abs(axis_y_input) > 0.1 else 0.0;
  velocity = velocity.normalized() * speed
  move_and_collide(velocity * delta)

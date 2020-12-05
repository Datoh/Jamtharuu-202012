extends KinematicBody2D

export (float) var speed := 200

enum State {MOVING, DIYNG, IDLING}

onready var timer := $Timer

const IDLE_MIN_TIME = 0.3
const IDLE_MAX_TIME = 3.0
const MIN_MOVE_DISTANCE = 100.0
const MAX_MOVE_DISTANCE = 400.0

var move_area := Rect2()

var move_destination := Vector2()
var velocity := Vector2()

var current_state = State.IDLING
var rng = RandomNumberGenerator.new()

func _ready() -> void:
  rng.randomize()
  idle()

 
func init_position(move_area_: Rect2) -> void:
  move_area = move_area_
  position.x = move_area.position.x + rng.randf_range(0.0, move_area.size.x)
  position.y = move_area.position.y + rng.randf_range(0.0, move_area.size.y)


func _physics_process(delta: float) -> void:
  if current_state == State.MOVING:
    move_and_collide(velocity * delta)
    if abs(position.distance_to(move_destination)) < 10.0:
      next_state()


func next_state() -> void:
  match current_state:
    State.IDLING:
      move()
    State.MOVING:
      idle()
    State.DIYNG:
      idle()


func idle() -> void:
  current_state = State.IDLING
  timer.start(rng.randf_range(IDLE_MIN_TIME, IDLE_MAX_TIME))


func move() -> void:
  current_state = State.MOVING
  var new_position_ok := false
  while !new_position_ok:
    velocity.x = rng.randf_range(MIN_MOVE_DISTANCE, MAX_MOVE_DISTANCE)
    velocity.x = velocity.x * (-1.0 if rng.randi()%2 == 0 else 1.0)
    velocity.y = rng.randf_range(MIN_MOVE_DISTANCE, MAX_MOVE_DISTANCE)
    velocity.y = velocity.y * (-1.0 if rng.randi()%2 == 0 else 1.0)
    move_destination = position + velocity
    new_position_ok = move_area.has_point(move_destination)   
  velocity = velocity.normalized() * speed


func _on_Timer_timeout() -> void:
  next_state()

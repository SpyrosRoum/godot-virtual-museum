extends KinematicBody

const GRAVITY = -1.4

export(float, 1.0, 1.5, 0.1) var move_speed: float = 1
export var decceleration: float = 0.8
export var mouse_sensitivity: float = 0.1

var velocity: Vector3 = Vector3.ZERO

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	movement(delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_look(event.relative)
	elif event.is_action_pressed("toggle_cursor"):
		toggle_mouse()

func mouse_look(mouse_movement: Vector2) -> void:
	rotate_y(-deg2rad(mouse_movement.x * mouse_sensitivity))
	$Head.rotate_x(deg2rad(mouse_movement.y * mouse_sensitivity))
	$Head.rotation.x = clamp($Head.rotation.x, -PI/3, PI/3)

func movement(_delta: float) -> void:
	var input = get_input_vector().normalized() * move_speed
	velocity += transform.basis.xform(input)
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, Vector3.UP, true) 
	velocity *= decceleration

func get_input_vector() -> Vector3:
	var i = Input.get_vector("right", "left", "backward", "forward")
	return Vector3(i.x, 0, i.y)

func toggle_mouse() -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_HIDDEN:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

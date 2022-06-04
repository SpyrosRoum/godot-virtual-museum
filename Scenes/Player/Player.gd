extends KinematicBody

const GRAVITY = -1.4

export(float, 1.0, 1.5, 0.1) var move_speed: float = 1
export var decceleration: float = 0.8
export var mouse_sensitivity: float = 0.1

export(NodePath) onready var ui_manager = get_node(ui_manager) as UIManager

onready var ray = $Head/Camera/RayCast
var velocity: Vector3 = Vector3.ZERO

var active_exhibit: Exhibit

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	check_exhibit()
	if !ui_manager.active_info():
		movement(delta)
	ui_manager.set_minimap(get_node("Viewport").get_texture())

func check_exhibit() -> void:
	if ray.is_colliding():
		var obj = ray.get_collider().get_parent()
		if active_exhibit == null and obj is Exhibit:
			active_exhibit = obj as Exhibit
			ui_manager.spawn_prompt("Interact with %s" % [active_exhibit.exhibit_data.name])
	elif active_exhibit != null:
		active_exhibit = null
		ui_manager.destroy_prompt()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if !ui_manager.active_info():
			mouse_look(event.relative)
	elif event.is_action_pressed("toggle_cursor"):
		toggle_mouse()
	elif event.is_action_pressed("interact"):
		if active_exhibit != null and !ui_manager.active_info():
			var data = active_exhibit.exhibit_data
			ui_manager.spawn_info(data.name, data.description)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

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
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

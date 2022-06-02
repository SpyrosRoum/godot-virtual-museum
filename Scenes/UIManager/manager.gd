extends Node
class_name UIManager

onready var _PROMPT: Label = get_node("Prompt");
onready var _INFO_POPUP = get_node("InfoPopUp");

func check_input() -> void:
	# This is just to check that prompt works correctly,
	# the trigger for the prompt will be the user looking at something eventually
	if Input.is_action_just_pressed("test_toggle_prompt"):
		if !active_prompt():
			spawn_prompt("Press `E` to interact")
		else:
			destroy_prompt();

	if Input.is_action_just_pressed("interact"):
		spawn_info("Title", "text");

func _process(delta: float) -> void:
	# The event checking should happen at the player,
	# This is just for testing
	check_input()

## A helper method to get if the prompt is visible or not
func active_prompt() -> bool:
	return _PROMPT.visible

## Set the text of the prompt to the given text and make it visible
func spawn_prompt(text: String) -> void:
	_PROMPT.text = text
	_PROMPT.show()

## Hide the prompt
func destroy_prompt() -> void:
	_PROMPT.hide()

## Open a window with the given title and info text.
## Note that the text is BBCode enabled
func spawn_info(title: String, text: String) -> void:
	var window = _INFO_POPUP.get_node("WindowDialog");
	var text_lbl = _INFO_POPUP.get_node("WindowDialog/RichTextLabel");
	window.window_title = title;
	window.popup_centered_ratio(0.6);
	text_lbl.text = text;

func show_tip() -> void:
	print("Hello from tip!")

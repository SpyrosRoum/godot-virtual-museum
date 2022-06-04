extends Node
class_name UIManager

onready var _PROMPT: Label = get_node("Prompt");
onready var _INFO_POPUP: WindowDialog = get_node("InfoPopUp/WindowDialog");
onready var _VIDEO_POPUP: WindowDialog = get_node("VideoPopUp/WindowDialog");
onready var _MINIMAP: TextureRect = get_node("MiniMap");

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

func _ready() -> void:
	_VIDEO_POPUP.connect("hide", self, "on_video_popup_close");
	var video_stream = _VIDEO_POPUP.get_node("VideoPlayer");
	video_stream.connect("finished", self, "on_video_finished");

	_VIDEO_POPUP.connect("hide", self, "on_generic_popup_close");
	_INFO_POPUP.connect("hide", self, "on_generic_popup_close");


## A helper method to get if the prompt is visible or not
func active_prompt() -> bool:
	return _PROMPT.visible

## A helper method to get if info is visible or not
func active_info() -> bool:
	return _INFO_POPUP.visible;

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
	var text_lbl = _INFO_POPUP.get_node("RichTextLabel");
	_INFO_POPUP.window_title = title;
	_INFO_POPUP.popup_centered_ratio(0.6);
	text_lbl.text = text;

## Set the texture of the minimap
func set_minimap(texture: Texture) -> void:
	_MINIMAP.texture = texture

## Spawn a video popup with the given stream and start playing.
func spawn_video(title: String, stream: VideoStream) -> void:
	_VIDEO_POPUP.window_title = title;
	_VIDEO_POPUP.popup_centered_ratio(0.6);

	var video_stream: VideoPlayer = _VIDEO_POPUP.get_node("VideoPlayer");
	video_stream.stream = stream;
	video_stream.play();

func on_generic_popup_close() -> void:
	# Capture the mouse!
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func on_video_popup_close() -> void:
	# Automatically stop the video(, is this needed?)
	var video_stream = _VIDEO_POPUP.get_node("VideoPlayer");
	video_stream.stop();

func on_video_finished() -> void:
	# Automatically close pop-up when video ends
	_VIDEO_POPUP.visible = false;

func show_tip() -> void:
	print("Hello from tip!")

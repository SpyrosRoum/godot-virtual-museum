extends Node
class_name UIManager

onready var _PROMPT: Label = get_node("Prompt");
onready var _INFO_POPUP: WindowDialog = get_node("InfoPopUp/WindowDialog");
onready var _VIDEO_POPUP: WindowDialog = get_node("VideoPopUp/WindowDialog");
onready var _MINIMAP: TextureRect = get_node("MiniMap");
onready var _CART_ITEMS: Label = get_node("CartPrompt/HBoxContainer/ItemCount");
# What is the current item
var _CURRENT_ITEM: ExhibitData = null;

func _ready() -> void:
	_VIDEO_POPUP.connect("popup_hide", self, "on_video_popup_close");
	var video_stream = _VIDEO_POPUP.get_node("VideoPlayer");
	video_stream.connect("finished", self, "on_video_finished");

	_VIDEO_POPUP.connect("popup_hide", self, "on_generic_popup_close");
	_INFO_POPUP.connect("popup_hide", self, "on_generic_popup_close");
	_INFO_POPUP.get_node("VBoxContainer/Button").connect("button_up", self, "_on_add_to_cart");

## A helper method to get if there is any visible popup
func active_popup() -> bool:
	return _INFO_POPUP.visible or _VIDEO_POPUP.visible;

## Set the text of the prompt to the given text and make it visible
func spawn_prompt(text: String) -> void:
	_PROMPT.text = text
	_PROMPT.show()

## Hide the prompt
func destroy_prompt() -> void:
	_PROMPT.hide()

## Open a window with the given title and info text.
## Note that the text is BBCode enabled
func spawn_info(data: ExhibitData) -> void:
	_CURRENT_ITEM = data;
	var text_lbl = _INFO_POPUP.get_node("VBoxContainer/RichTextLabel");
	_INFO_POPUP.window_title = data.name;
	_INFO_POPUP.popup_centered_ratio(0.6);
	text_lbl.text = data.description;

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

func _on_add_to_cart() -> void:
	if _CURRENT_ITEM == null:
		# This really shouldn't happen
		return;
	CART.add_to_cart(_CURRENT_ITEM);
	_CART_ITEMS.set_text(String(CART.items.size()));
	_INFO_POPUP.hide()

func on_video_finished() -> void:
	# Automatically close pop-up when video ends
	_VIDEO_POPUP.visible = false;

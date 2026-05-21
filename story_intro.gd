extends Control

@onready var tap_to_continue = $TapToContinue
@onready var line1 = $Line1
@onready var line2 = $Line2
@onready var line3 = $Line3
@onready var line4 = $Line4
@onready var line5 = $Line5

var can_continue = false
var is_typing = true
var typing_speed = 0.05  # seconds per character (lower = faster)
var line_pause = 1.0  # pause between lines in seconds

# Store the full text for each line
var line_texts = []

func _ready():
	# Store original text and clear labels
	line_texts = [
		line1.text,
		line2.text,
		line3.text,
		line4.text,
		line5.text
	]
	
	# Clear all text and hide lines
	line1.text = ""
	line2.text = ""
	line3.text = ""
	line4.text = ""
	line5.text = ""
	
	line1.visible = false
	line2.visible = false
	line3.visible = false
	line4.visible = false
	line5.visible = false
	
	# Start typing animation
	start_story()

func start_story():
	await type_line(line1, line_texts[0])
	await get_tree().create_timer(line_pause).timeout
	
	await type_line(line2, line_texts[1])
	await get_tree().create_timer(line_pause).timeout
	
	await type_line(line3, line_texts[2])
	await get_tree().create_timer(line_pause).timeout
	
	await type_line(line4, line_texts[3])
	await get_tree().create_timer(line_pause).timeout
	
	await type_line(line5, line_texts[4])
	await get_tree().create_timer(line_pause).timeout
	
	# Show "tap to continue" after everything is typed
	tap_to_continue.visible = true
	can_continue = true

func type_line(label: Label, full_text: String):
	is_typing = true
	label.visible = true
	label.text = ""
	
	for i in range(full_text.length()):
		if not is_typing:  # Skip to end if player clicked
			label.text = full_text
			return
		label.text += full_text[i]
		await get_tree().create_timer(typing_speed).timeout
	
	is_typing = false

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if is_typing:
			is_typing = false  # Skip typing animation
		elif can_continue:
			get_tree().change_scene_to_file("res://scene1_intro.tscn")  # Changed this line

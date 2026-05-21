extends Node2D

# Inventory system
var inventory = []  # Array to store collected items
var max_inventory_size = 8  # Changed from 10 to 8
var selected_slot = -1  # Which inventory slot is currently selected (-1 = none)

# References to inventory slot buttons
@onready var inventory_slots = []

func _ready():
	# Get references to all 8 inventory slots
	for i in range(1, 9):  # Changed from 11 to 9
		var slot = get_node("UI/InventoryBar/Slot" + str(i))
		inventory_slots.append(slot)
		# Connect each slot's pressed signal
		slot.pressed.connect(_on_inventory_slot_pressed.bind(i - 1))
	
	# Initialize empty inventory
	for i in range(max_inventory_size):
		inventory.append(null)
	
	update_inventory_display()
	
	# TEST: Add a test item after 2 seconds
	await get_tree().create_timer(2.0).timeout
	test_add_item()

func test_add_item():
	# Create a red square texture that fits the slot (smaller size)
	var img = Image.create(50, 50, false, Image.FORMAT_RGB8)  # Changed from 64 to 50
	img.fill(Color(1.0, 0.0, 0.0))  # Red color
	var test_texture = ImageTexture.create_from_image(img)
	add_item_to_inventory("Test Coin", test_texture)

# Called when player clicks an inventory slot
func _on_inventory_slot_pressed(slot_index: int):
	if inventory[slot_index] != null:  # If slot has an item
		if selected_slot == slot_index:
			# Deselect if clicking the same slot again
			selected_slot = -1
			print("Deselected item")
		else:
			# Select this slot
			selected_slot = slot_index
			print("Selected item: ", inventory[slot_index])
		update_inventory_display()

# Add an item to inventory
func add_item_to_inventory(item_name: String, item_texture: Texture2D):
	# Find first empty slot
	for i in range(max_inventory_size):
		if inventory[i] == null:
			inventory[i] = {
				"name": item_name,
				"texture": item_texture
			}
			print("Added ", item_name, " to inventory slot ", i)
			update_inventory_display()
			return true
	
	print("Inventory is full!")
	return false

# Remove item from inventory
func remove_item_from_inventory(slot_index: int):
	if slot_index >= 0 and slot_index < max_inventory_size:
		inventory[slot_index] = null
		if selected_slot == slot_index:
			selected_slot = -1
		update_inventory_display()

# Update the visual display of inventory slots
# Update the visual display of inventory slots
func update_inventory_display():
	for i in range(inventory_slots.size()):
		var slot_button = inventory_slots[i]
		var item_sprite = slot_button.get_node("ItemSprite")
		var selection_border = slot_button.get_node("SelectionBorder")
		
		if inventory[i] != null:
			# Show the item texture in the sprite
			item_sprite.texture = inventory[i]["texture"]
			item_sprite.visible = true
			# Scale down the sprite to fit nicely in the slot
			item_sprite.scale = Vector2(0.8, 0.8)  # Adjust this to make items smaller/bigger
		else:
			# Empty slot - hide sprite
			item_sprite.visible = false
		
		# Show/hide selection border
		if i == selected_slot:
			selection_border.visible = true
		else:
			selection_border.visible = false

# Get currently selected item
func get_selected_item():
	if selected_slot >= 0 and selected_slot < max_inventory_size:
		return inventory[selected_slot]
	return null

# Use/consume the selected item
func use_selected_item():
	if selected_slot >= 0:
		var item = inventory[selected_slot]
		remove_item_from_inventory(selected_slot)
		return item
	return null

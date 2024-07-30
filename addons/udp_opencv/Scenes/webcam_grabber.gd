extends Control

@onready var output_screen: TextureRect = $OutputScreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_udp_server_image_ready(image: Variant) -> void:
	output_screen.texture = ImageTexture.new().create_from_image(image)
	pass # Replace with function body.

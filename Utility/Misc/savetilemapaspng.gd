extends TileMapLayer


@onready var tilemap = self

func _ready():
	#return
	# Create a viewport
	var viewport = get_viewport()
	print('sizeveiw:',tilemap.get_used_rect().size * 32,viewport)
	
	viewport.set_size(Vector2i(2560, 2208))
	#viewport.size_2d_override_stretch(Vector2i(3104, 2304))
	#viewport.size = tilemap.get_used_rect().size * 32
	await RenderingServer.frame_post_draw
	viewport.get_texture().get_image().save_png("res://hubScreenshot.png")

	# Cleanup
	#viewport.queue_free()

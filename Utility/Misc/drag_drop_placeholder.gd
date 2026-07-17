extends Sprite2D
class_name DragDrop

var is_inside_dropzone := false
var ref_dropzone = null

var data = null
var origin_pos:Vector2
var rarity = 0
var Source = null

var spritedata = []

func picked_up(source_texture,hframe,vframe,Frame,Rarity,transfer_data,source):
	texture = source_texture
	hframes = hframe
	vframes = vframe
	frame = Frame
	rarity = Rarity
	data = transfer_data
	origin_pos = source.global_position
	Source = source
	Global.is_DraggingObject = true
	spritedata = [texture,hframes,vframes,frame]
	print(data)

func _process(delta: float) -> void:
	if Global.is_DraggingObject:
		self.global_position = get_global_mouse_position()
	
	if Input.is_action_just_released("LeftClick"): #When dropped, either move back to initial location,
			Global.is_DraggingObject = false         # or into place in hovered slot.
			print("Global_Dragging: ",Global.is_DraggingObject)
			var tween = get_tree().create_tween()
			print("is in dropzone? ",ref_dropzone)
			#print("has slot_filled? ","slot_filled" in ref_dropzone)
			if is_inside_dropzone and "slot_filled" in ref_dropzone:
				print("HAS SLOTFILLED VAR")
				#print("TileRarity:",rarity," SlotRarity:",ref_dropzone.rarity," IsFilled?:",ref_dropzone.slot_filled)
				if ! ref_dropzone.slot_filled and ref_dropzone.rarity >= rarity:
					tween.tween_property(self,"global_position",ref_dropzone.global_position,0.1).set_ease(tween.EASE_OUT)
					ref_dropzone.slot_filled = true
					ref_dropzone.take_data(data,spritedata,Source)
					print("found dropzone, delivered data")
					queue_free()
				
				else:
					tween.tween_property(self,"global_position",origin_pos,0.1).set_ease(tween.EASE_OUT)
					Source.drag_failed()
					print("drag failed")
					queue_free()
			else:
				tween.tween_property(self,"global_position",origin_pos,0.1).set_ease(tween.EASE_OUT)
				Source.drag_failed()
				print("drag failed")
				queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("dropzone"):
		is_inside_dropzone = true
		ref_dropzone = body
		print("in dropzone: ",ref_dropzone)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("dropzone"):
		print("left dropzone: ",ref_dropzone)
		is_inside_dropzone = false
		ref_dropzone = null
		

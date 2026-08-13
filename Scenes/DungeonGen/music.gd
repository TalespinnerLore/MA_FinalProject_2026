extends Control

const tracks = [preload("res://Sounds/islands.ogg"),preload("res://Sounds/volcano.ogg"),preload("res://Sounds/islands.ogg"),preload("res://Sounds/mesas.ogg"),preload("res://Sounds/skylands.ogg")]

func play_theme(biomenum:int):
	process_mode = Node.PROCESS_MODE_ALWAYS
	$AudioStreamPlayer.stream = tracks[biomenum]
	var music = $AudioStreamPlayer
	music.play()

class_name EnvironmentObjectManager
extends Node2D

var unpassable_tiles:Array[Vector2i]
var portal_ref:HomePortal


func portal_visibility():
	print("envmanager; portal vis swap trigger")
	portal_ref.enable_disable()

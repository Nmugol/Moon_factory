extends Node2D

@onready var SingleTile = preload("res://Script/Class/Tiles.gd")
var nest_scene = preload("res://Scenes/alien_nest.tscn")

func _on_teren_plase_nest(cord,z):
	
	#Szansa na pojawinei się gniazda
	var chance_to_appear = randi() % 100 + 1
	if chance_to_appear <= 10:
		
		#Utwożenie instancji gniazda
		var nest_instance = nest_scene.instantiate()
		
		#Ustawienie pozycji gniazda
		nest_instance.position.x = cord.x-4
		nest_instance.position.y = cord.y-8
		
		#Ustawienei z_indexu gniazda
		nest_instance.z_index = z
		
		#dodanie gniazda do sceny
		add_child(nest_instance)

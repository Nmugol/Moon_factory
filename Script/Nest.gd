extends Node2D

var nest_scene = preload("res://Scenes/alien_nest.tscn")


func _on_teren_plase_nest(position_x:int, position_y:int, z_Index:int):
	#Szansa na pojawinei się gniazda
	var chance_to_appear:int = randi() % 100 + 1
	if chance_to_appear <= 10:
		#Utwożenie instancji gniazda
		var nest_instance = nest_scene.instantiate()
		
		#Ustawienie pozycji gniazda
		nest_instance.position.x = position_x + GlobaData.nest_offset
		nest_instance.position.y = position_y

		#Ustawienei z_indexu gniazda
		nest_instance.z_index = z_Index
		
		#dodanie gniazda do sceny
		add_child(nest_instance)

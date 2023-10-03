extends Node2D

var nest_scene = preload("res://Scenes/alien_nest.tscn")

func _on_teren_plase_nest(cord:Vector2i,zIndex:int):
	#Szansa na pojawinei się gniazda
	var chance_to_appear:int = randi() % 100 + 1
	if chance_to_appear <= 10:
		#Utwożenie instancji gniazda
		var nest_instance = nest_scene.instantiate()
		
		#Ustawienie pozycji gniazda
		nest_instance.position.x = cord.x + GlobaData.nest_offset
		nest_instance.position.y = cord.y
		
		#Ustawienei z_indexu gniazda
		nest_instance.z_index = zIndex
		
		#dodanie gniazda do sceny
		add_child(nest_instance)

extends Node

#World
var chunk_size:int = 16 # Rozmiar chanku
var world_size:int = 9  # Rozmiar świata, liczba chunków na jednej osi

# Ustawienie rozmiaru mapy i pozycji pierwszego kafelka
var map_size:int = 0
var start_pos:int = 0

# Tabliza na mapę
var map_array = []
var nest_array = []

# Alien
<<<<<<< HEAD
var nest_offset_x:int = 4
var nest_offset_y:int = 8
=======
var nest_offset:int = 16

#Tree
var tree_offset:int = 50 
>>>>>>> feature/add-tree

func _ready():
	map_size = chunk_size * world_size
	start_pos = round(map_size / 2.0) * (-1)

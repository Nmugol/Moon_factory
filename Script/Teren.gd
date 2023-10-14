extends TileMap

# Sygnały
signal Plase_nest(position_x:int, position_y:int, z_Index:int)
signal Plase_tree(position_x:int, position_y:int, z_Index:int)

# Clasy
var teten_tile = load("res://Script/Class/SingleTileClass.gd")

# Zmienne z biblioteki
var tile_x_noise = FastNoiseLite.new()     # Obiekt FastNoiseLite dla pozycji X kafelków
var tile_y_noise = FastNoiseLite.new()     # Obiekt FastNoiseLite dla pozycji Y kafelków
var tile_layer_noise = FastNoiseLite.new() # Obiekt FastNoiseLite dla warstw kafelków

func _ready():
	# Ustawienie szumu dla pozycji X i Y kafelków
	tile_x_noise.seed = randi()
	tile_y_noise.seed = randi()
	tile_layer_noise.seed = randi()
	tile_layer_noise.fractal_octaves = 1

	GenerateTerrain() # Funkcja generująca teren przy uruchomieniu gry
	pass

func GenerateTerrain() -> void:
	# Pętle generujące kafelki
	for pos_x in range(GlobaData.start_pos, GlobaData.start_pos * (-1)):
		for pos_y in range(GlobaData.start_pos, GlobaData.start_pos * (-1)):
			var layer = round(tile_layer_noise.get_noise_2d(pos_x, pos_y) * 3 + 2.5)  # Wygenerowanie wartości dla warstwy
			var tile_x = round(tile_x_noise.get_noise_2d(pos_x, pos_y) * 3 + 2)     # Wygenerowanie wartości dla pozycji X kafelka
			var tile_y = round(tile_y_noise.get_noise_2d(pos_x, pos_y) * 2 + 1)     # Wygenerowanie wartości dla pozycji Y kafelka

			# Utworzenie obiektu SingleTile i ustawienie jego właściwości
			var single_tile = teten_tile.new(pos_x,pos_y,layer,tile_x,tile_y)

			# Zwolnienie pemięci 
			single_tile = null
			
			# Ustawienie kafelka w obiekcie TileMap na odpowiedniej pozycji i warstwie
			set_cell(layer, Vector2(pos_x, pos_y), 0, Vector2(tile_x, tile_y), 0)
			
			#Sprawdzanie czy mamy miejsce na gniazdo
			if EnoughSpace(pos_x, pos_y, layer, 1, [0], [0,1,2]):
				AddObjectToMap(pos_x,pos_y,1)
			
			if EnoughSpace(pos_x, pos_y, layer,1, [1,2], [0,1,2]):
				AddObjectToMap(pos_x,pos_y,2)

	# Zwolnienie pamięci 
	tile_x_noise = null
	tile_y_noise = null
	tile_layer_noise = null

func EnoughSpace(pos_x:int, pos_y:int, layer:int, distance:int, teren:Array, biom:Array) -> bool:
	for i in range(-distance,distance+1):
		for j in range(-distance,distance+1):
			
			#Pomijanie śtodkowaego klfelka
			if i == 0 and j == 0:
				continue
			
			#informacje o oatczającym kaferlku 
			var tilelayer = round(tile_layer_noise.get_noise_2d(pos_x+i,pos_y+j) * 3 + 2.5)
			var tile_x = round(tile_x_noise.get_noise_2d(pos_x+i,pos_y+j) * 3 + 2)
			var tile_y = round(tile_y_noise.get_noise_2d(pos_x, pos_y) * 2 + 1)
			
			if IsInArray(teren,tile_x) and IsInArray(biom, tile_y) and tilelayer == layer:
				return true
	return false
	
func IsInArray(table:Array, value:int) -> bool:
	var found = false
	for e in table:
		if e == value:
			found = true
	return found
	
	
func AddObjectToMap(pos_x:int, pos_y:int, type_of_objecte:int) -> void:
	var object_type = {
		1: "Plase_nest", # Alien_nest
		2: "Plase_tree"  # Tree
		}
		
	var object_posytion = map_to_local(Vector2i(pos_x,pos_y))
	var index = GlobaData.map_size - pos_x
	
	emit_signal( object_type[type_of_objecte], object_posytion.x, object_posytion.y, index)
	pass

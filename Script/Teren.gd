extends TileMap

# Sygnały
<<<<<<< HEAD
signal Plase_nest(cord:Vector2i, zIndex)
=======
signal Plase_nest(cord:Vector2i, zIndex:int)
signal Plase_tree(cord:Vector2i, zIndex:int)
>>>>>>> feature/add-tree

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

func GenerateTerrain():
	# Pętle generujące kafelki
	for pos_x in range(GlobaData.start_pos, GlobaData.start_pos * (-1)):
		for pos_y in range(GlobaData.start_pos, GlobaData.start_pos * (-1)):
			var layer = round(tile_layer_noise.get_noise_2d(pos_x, pos_y) * 3 + 2.5)  # Wygenerowanie wartości dla warstwy
			var tile_x = round(tile_x_noise.get_noise_2d(pos_x, pos_y) * 3 + 2)     # Wygenerowanie wartości dla pozycji X kafelka
			var tile_y = round(tile_y_noise.get_noise_2d(pos_x, pos_y) * 2 + 1)     # Wygenerowanie wartości dla pozycji Y kafelka

			# Utworzenie obiektu SingleTile i ustawienie jego właściwości
			var single_tile = CustomClass.Tile.new()
			single_tile.x = pos_x
			single_tile.y = pos_y
			single_tile.type_x = tile_x
			single_tile.type_y = tile_y
			single_tile.layer = layer

			# Dodanie pojedynczego kafelka do tablicy map_array
			GlobaData.map_array.append(single_tile)

			# Zwolnienie pemięci 
			single_tile = null
			# Ustawienie kafelka w obiekcie TileMap na odpowiedniej pozycji i warstwie
			set_cell(layer, Vector2(pos_x, pos_y), 0, Vector2(tile_x, tile_y), 0)
			
<<<<<<< HEAD
			#Odstęp od krawędzi
			var distans:int = 6
			var border_x:bool = pos_x < GlobaData.start_pos+distans and pos_x < (-1*GlobaData.start_pos)-distans
			var border_y:bool = pos_y < GlobaData.start_pos+distans and pos_y < (-1*GlobaData.start_pos)-distans
			if tile_x != 0 or border_x or border_y:
				continue
			
			#Sprawdzanie czy mamy miejsce na gniazdo
			if EnoughSpace(pos_x,pos_y,layer):
				
				#Nowy obiket Nest
				var single_nest = CustomClass.Nest.new()
				
				#Zamian współżadnych map na globalne
				var cored = map_to_local(Vector2i(pos_x,pos_y))
				
				#Obliczenia z_index dla gniazda
				var index = GlobaData.world_size-pos_x+100
				
				#Wysłanie sygnału ustawiającego gniazdo
				emit_signal("Plase_nest",cored,index)
				
				#Wypełnienie paremetró obiktu Nest
				single_nest.x = cored.x-GlobaData.nest_offset_x
				single_nest.y = cored.y-GlobaData.nest_offset_y
				single_nest.index = index
				
				#Dodanie go do tablizy
				GlobaData.nest_array.append(single_nest)
				
				#Usunięcie obiektu
				single_nest=null
=======
			#Sprawdzanie czy mamy miejsce na gniazdo
			if EnoughSpace(pos_x,pos_y,layer,1,[0]):
				AddNest(pos_x,pos_y)
			
			if EnoughSpace(pos_x,pos_y,layer,1,[1,2]):
				AddTree(pos_x,pos_y)
>>>>>>> feature/add-tree
	
	# Zwolnienie pamięci 
	tile_x_noise = null
	tile_y_noise = null
	tile_layer_noise = null

<<<<<<< HEAD
func EnoughSpace(x,y,l):
	for i in range(-1,2):
		for j in range(-1,2):
=======
func EnoughSpace(pos_x:int,pos_y:int,layer:int,distance:int,teren:Array):
	for i in range(-distance,distance+1):
		for j in range(-distance,distance+1):
>>>>>>> feature/add-tree
			
			#Pomijanie śtodkowaego klfelka
			if i == 0 and j == 0:
				continue
			
			#informacje o oatczającym kaferlku 
			var tilelayer = round(tile_layer_noise.get_noise_2d(pos_x+i,pos_y+j) * 3 + 2.5)
			var tilex = round(tile_x_noise.get_noise_2d(pos_x+i,pos_y+j) * 3 + 2)
			
			if IsInArray(teren,tilex) and tilelayer == layer:
				return true
	return false
	
func IsInArray(table:Array,value:int)->bool:
	var found = false
	for e in table:
		if e == value:
			found = true
	return found
	
func AddNest(pos_x:int,pos_y:int)->void:

	#Zamian współżadnych map na globalne
	var cored = map_to_local(Vector2i(pos_x,pos_y))
	
	#Obliczenia z_index dla gniazda
	var index = GlobaData.world_size - pos_x + 100
	
	#Wysłanie sygnału ustawiającego gniazdo
	emit_signal("Plase_nest",cored,index)

func AddTree(pos_x,pos_y):
	var cord = map_to_local(Vector2i(pos_x,pos_y))

	var index = GlobaData.world_size - pos_x + 100

	emit_signal("Plase_tree",cord,index)

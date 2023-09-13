extends TileMap

#Sygnały
signal Plase_nest(cord:Vector2i, z)

## Inne pliki
@onready var SingleTile = preload("res://Script/Class/Tiles.gd")

## Zmienne dla edytora
@export var chunk_size:int = 16 # Rozmiar chanku
@export var world_size:int = 9  # Rozmiar świata, liczba chunków na jednej osi

## Zmienne z biblioteki
var tile_x_noise = FastNoiseLite.new()     # Obiekt FastNoiseLite dla pozycji X kafelków
var tile_y_noise = FastNoiseLite.new()     # Obiekt FastNoiseLite dla pozycji Y kafelków
var tile_layer_noise = FastNoiseLite.new() # Obiekt FastNoiseLite dla warstw kafelków

## Zmienne plikowe
# Ustawienie rozmiaru mapy i pozycji pierwszego kafelka
var map_size:int = chunk_size * world_size
var start_pos:int = round(map_size / 2.0) * (-1)

# Tabliza na mapę
var map_array = []
var nest_array = []

func _ready():
	## Ustawienie szumu dla pozycji X i Y kafelków
	tile_x_noise.seed = randi()
	tile_y_noise.seed = randi()
	tile_layer_noise.seed = randi()
	tile_layer_noise.fractal_octaves = 1

	GenerateTerrain() # Funkcja generująca teren przy uruchomieniu gry
	pass

func GenerateTerrain():
	# Pętle generujące kafelki
	for pos_x in range(start_pos, start_pos * (-1)):
		for pos_y in range(start_pos, start_pos * (-1)):
			var layer = round(tile_layer_noise.get_noise_2d(pos_x, pos_y) * 3 + 2.5)  # Wygenerowanie wartości dla warstwy
			var tile_x = round(tile_x_noise.get_noise_2d(pos_x, pos_y) * 3 + 2)     # Wygenerowanie wartości dla pozycji X kafelka
			var tile_y = round(tile_y_noise.get_noise_2d(pos_x, pos_y) * 2 + 1)     # Wygenerowanie wartości dla pozycji Y kafelka

			# Utworzenie obiektu SingleTile i ustawienie jego właściwości
			var single_tile = SingleTile.Tile.new()
			single_tile.x = pos_x
			single_tile.y = pos_y
			single_tile.type_x = tile_x
			single_tile.type_y = tile_y
			single_tile.layer = layer

			# Dodanie pojedynczego kafelka do tablicy map_array
			map_array.append(single_tile)

			# Zwolnienie pemięci 
			single_tile = null
			# Ustawienie kafelka w obiekcie TileMap na odpowiedniej pozycji i warstwie
			set_cell(layer, Vector2(pos_x, pos_y), 0, Vector2(tile_x, tile_y), 0)
			
			#Odstęp od krawędzi
			var distans:int = 6
			var border_x:bool = pos_x < start_pos+distans and pos_x < (-1*start_pos)-distans
			var border_y:bool = pos_y < start_pos+distans and pos_y < (-1*start_pos)-distans
			if tile_x != 0 or border_x or border_y:
				continue
			
			#Sprawdzanie czy mamy miejsce na gniazdo
			if EnoughSpace(pos_x,pos_y,layer):
				
				#Nowy obiket Nest
				var single_nest = SingleTile.Nest.new()
				
				#Zamian współżadnych map na globalne
				var cored = map_to_local(Vector2i(pos_x,pos_y))
				
				#Obliczenia z_index dla gniazda
				var index = world_size-pos_x+100
				
				#Wysłanie sygnału ustawiającego gniazdo
				emit_signal("Plase_nest",cored,index)
				
				#Wypełnienie paremetró obiktu Nest
				single_nest.x = cored.x-4
				single_nest.y = cored.y-8
				single_nest.z_index = index
				
				#Dodanie go do tablizy
				nest_array.append(single_nest)
				
				#Usunięcie obiektu
				single_nest=null
	
	# Zwolnienie pamięci 
	tile_x_noise = null
	tile_y_noise = null
	tile_layer_noise = null

func EnoughSpace(x,y,l):
	
	
	for i in range(-1,2):
		for j in range(-1,2):
			
			#Pomijanie śtodkowaego klfelka
			if i == 0 and j == 0:
				continue
			
			#informacje o oatczającym kaferlku 
			var tl = round(tile_layer_noise.get_noise_2d(x+i,y+j) * 3 + 2.5)
			var tx = round(tile_x_noise.get_noise_2d(x+i,y+j) * 3 + 2)
			
			#Jeśli kafelki nie spełniją warunków zabroń sładzenie 
			if !(tx == 0 and tl == l):
				return false
	return true
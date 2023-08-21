extends TileMap

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

func _ready():
	## Ustawienie szumu dla pozycji X i Y kafelków
	tile_x_noise.seed = randi()
	tile_y_noise.seed = randi()

	## Generowanie nowego ziarna dla losowych wartości 
	randomize()

	## Ustawienie szumu dla warstw kafelków
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
			
			#var cored = map_to_local(Vector2i(pos_x,pos_y))

	# Zwolnienie pamięci 
	tile_x_noise = null
	tile_y_noise = null
	tile_layer_noise = null

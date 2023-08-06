extends TileMap

@export var chunk_size:int = 16 # Rozmiar pojedynczego kafelka w pikselach
@export var world_size:int = 9  # Rozmiar świata, liczba chunków na jednej osi

## Ustawienie rozmiaru mapy i pozycji pierwszego kafelka
var map_size:int = chunk_size * world_size
var start_pos:int = round(map_size / 2) * (-1)
	
## Utworzenie tablicy dwuwymiarowej o wymiarach start_pos*(-1) na start_pos*(-1)
var map_array = Empty2DArray(start_pos * (-1), start_pos * (-1))

var tile_x_noise = FastNoiseLite.new()     # Obiekt FastNoiseLite dla pozycji X kafelków
var tile_y_noise = FastNoiseLite.new()     # Obiekt FastNoiseLite dla pozycji Y kafelków
var tile_layer_noise = FastNoiseLite.new() # Obiekt FastNoiseLite dla warstw kafelków

# Klasa reprezentująca pojedynczy kafelek
class SingleTile:
	var x:int
	var y:int
	var layer:int
	var type_x:int
	var type_y:int

func _ready():
	GenerateTerrain() # Funkcja generująca teren przy uruchomieniu gry
	pass
	
func GenerateTerrain():
	## Ustawienie szumu dla pozycji X i Y kafelków
	tile_x_noise.seed = randi()
	tile_y_noise.seed = randi()
	
	## Generowanie nowego ziarna dla losowych wartości 
	randomize()
	
	## Ustawienie szumu dla warstw kafelków
	tile_layer_noise.seed = randi()
	tile_layer_noise.fractal_octaves = 1
	
	# Pętle generujące kafelki
	for pos_x in range(start_pos, start_pos * (-1)):
		for pos_y in range(start_pos, start_pos * (-1)):
			var layer = round(tile_layer_noise.get_noise_2d(pos_x, pos_y) * 2.5 + 2.5)  # Wygenerowanie wartości dla warstwy
			var tile_x = round(tile_x_noise.get_noise_2d(pos_x, pos_y) * 3 + 2)         # Wygenerowanie wartości dla pozycji X kafelka
			var tile_y = round(tile_y_noise.get_noise_2d(pos_x, pos_y) * 2 + 1)         # Wygenerowanie wartości dla pozycji Y kafelka
			
			# Utworzenie obiektu SingleTile i ustawienie jego właściwości
			var single_tile = SingleTile.new()
			single_tile.x = pos_x
			single_tile.y = pos_y
			single_tile.type_x = tile_x
			single_tile.type_y = tile_y
			single_tile.layer = layer
			
			# Dodanie pojedynczego kafelka do tablicy map_array
			map_array[pos_x][pos_y] = single_tile
			
			# Zwolnienie pemięci 
			single_tile = null
			
			# Ustawienie kafelka w obiekcie TileMap na odpowiedniej pozycji i warstwie
			set_cell(layer, Vector2(pos_x, pos_y), 0, Vector2(tile_x, tile_y), 0)
			
	# Zwolnienie pamięci 
	tile_x_noise = null
	tile_y_noise = null
	tile_layer_noise = null
	
func Empty2DArray(n: int, m: int) -> Array:
	var result = []
	for i in range(n):
		var row = []
		for j in range(m):
			row.append(0)
		result.append(row)
	return result

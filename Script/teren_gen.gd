extends TileMap

@export var chunk_size:int = 16 # Rozmiar chanku
@export var world_size:int = 9  # Rozmiar świata, liczba chunków na jednej osi

## Ustawienie rozmiaru mapy i pozycji pierwszego kafelka
var map_size:int = chunk_size * world_size
var start_pos:int = round(map_size / 2.0) * (-1)
	
## Utworzenie tablicy dwuwymiarowej o wymiarach start_pos*(-1) na start_pos*(-1)
var map_array = Empty2DArray(map_size)

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
	## Ustawienie szumu dla pozycji X i Y kafelków
	tile_x_noise.seed = randi()
	tile_y_noise.seed = randi()
	
	## Generowanie nowego ziarna dla losowych wartości 
	randomize()
	
	## Ustawienie szumu dla warstw kafelków
	tile_layer_noise.seed = randi()
	tile_layer_noise.fractal_octaves = 1
	
	GenerateTerrain() # Funkcja generująca teren przy uruchomieniu gry
	GenrateNest()# Funkcja ustawiające niazda opcych
	
	pass

func GenerateTerrain():
	# Pętle generujące kafelki
	for pos_x in range(start_pos, start_pos * (-1)):
		for pos_y in range(start_pos, start_pos * (-1)):
			var layer = round(tile_layer_noise.get_noise_2d(pos_x, pos_y) * 3 + 3)  # Wygenerowanie wartości dla warstwy
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

func GenrateNest():
	var owset = 4
	
	#odczyt mapy
	for i in range(map_array.size()-owset):
		for j in range(map_array.size()-owset):
			
			#pobranie kafelak
			var cell = map_array[i][j]
			
			#sprawdzeniae biomu
			if cell.type_x == 0:
				
				#losowanie szansy na postawienie
				var chance = randi()%100+1
				if chance <= 5:
					
					#zmienna pomocnicza do sprawdzanie czy można położyć gniazdo
					var can_pleas_nest:bool = true
					
					#sprawdzanie czy teren jest odpowieni 
					for k in range(1,owset):
						for l in range(1,owset):
							#jesl min jeden kafelek nie spełna warunków przerywamy pętlę
							if map_array[i+k][j+l].type_x != 0 and cell.layer != map_array[i+k][j+l].layer:
								can_pleas_nest = false
								break
						if can_pleas_nest == false:
							break
					# Usatwiamy kafrelet na odpowieniej pozycji 
					if can_pleas_nest == true:
						set_cell(cell.layer+6,Vector2i(cell.x,cell.y),1,Vector2i(0,0),0)

func Empty2DArray(n: int) -> Array:
	var result = []
	for i in range(n):
		var row = []
		for j in range(n):
			row.append(0)
		result.append(row)
	return result

extends TileMap

@export var chank_size:int = 16
@export var world_size:int = 9

var tile_x_poz = FastNoiseLite.new()
var tile_y_poz = FastNoiseLite.new()
var tile_layer = FastNoiseLite.new()

func _ready():
	tile_x_poz.seed = randi()
	tile_y_poz.seed = randi()
	
	seed(randi())
	
	tile_layer.seed = randi()
	tile_layer.fractal_octaves = 1
	var map_size:int = chank_size*world_size
	var start_poz:int = round(map_size/2)*(-1)
	for poz_x in range(start_poz,map_size):
		for  poz_y in range(start_poz,map_size):
			SetTaile(poz_x,poz_y)
			pass
		pass
	pass
	
func SetTaile(poz_x,poz_y)->void:
	var leyer = round(tile_layer.get_noise_2d(poz_x,poz_y))*2.5+2.5
	var tile_x = round(tile_x_poz.get_noise_2d(poz_x,poz_y))*2+2
	var tile_y = round(tile_y_poz.get_noise_2d(poz_x,poz_y))+1
	set_cell(leyer,Vector2i(poz_x,poz_y),0,Vector2i(tile_x,tile_y),0)
	pass

func SetGround(leyer,poz_x,poz_y)->void:
	if leyer>=0:
		set_cell(leyer,Vector2i(poz_x,poz_y),0,Vector2i(0,0),0)
		SetGround(leyer-1,poz_x,poz_y)
		pass
	pass


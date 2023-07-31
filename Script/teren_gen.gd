extends TileMap

@export var chank_size:int = 16
@export var world_size:int = 9

var tile_x_poz = FastNoiseLite.new()

func _ready():
	tile_x_poz.seed = randi()
	var map_size:int = chank_size*world_size
	var start_poz:int = round(map_size/2)*(-1)
	for poz_x in range(start_poz,map_size):
		for  poz_y in range(start_poz,map_size):
			var x = round(tile_x_poz.get_noise_2d(poz_x,poz_y))
			var tile_x = x+1
			set_cell(0,Vector2i(poz_x,poz_y),0,Vector2i(tile_x,0),0)
			pass
		pass
	pass
	
func  _process(delta):
	pass

extends TileMap

@export var map_size:int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in map_size:
		for j in map_size:
			set_cell(0,Vector2i(i,j),0,Vector2i(0,0),0)
	pass # Replace with function body.


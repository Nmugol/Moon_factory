extends Node

class_name ObjectOnMap

var pos_x:int
var pos_y:int
var z_index:int
var health_points:float

func _init(x:int, y:int, z:int, hp:float) -> void:
	pos_x = x
	pos_y = y
	z_index = z
	health_points = hp

func SetPosX(new_pos_x: int) -> void:
	pos_x = new_pos_x

func SetPosY(new_pos_y: int) -> void:
	pos_y = new_pos_y

func SetZIndex(new_z_index: int) -> void:
	z_index = new_z_index

func SetHelthPoints(new_health_points: float) -> void:
	health_points = new_health_points

func GetHelthPoints() -> float:
	return health_points

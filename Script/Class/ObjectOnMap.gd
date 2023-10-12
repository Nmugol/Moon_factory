extends Node

class_name ObjectOnMap

var pos_x: int
var pos_y: int
var z_index: int
var hp: float

func _init(x=0,y=0,z=1, h=10):
	pos_x = x
	pos_y = y
	z_index = z
	hp = h

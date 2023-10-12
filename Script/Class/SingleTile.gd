extends Node

class_name SingleTile

var pos_x:int
var pos_y:int
var z_index:int
var teren:int
var biom:int

func _init(x:int, y:int, z:int, t:int, b:int):
	pos_x = x
	pos_y = y
	z_index = z
	teren = t
	biom = b

extends Node

var teeth : int = 0
var max_teeth : int = 0
var health : int = 3

func attack():
	health -= 1
	return true

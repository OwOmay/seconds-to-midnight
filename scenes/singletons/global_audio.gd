extends Node

var num_ids := {
	"crumple": 3,
	"drop": 2,
	"flip": 3,
	"stamp": 2
}

func play_random(id: String):
	if num_ids.keys().has(id):
		get_node(id + str((randi() % num_ids[id]) + 1)).play()

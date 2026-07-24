extends Node

var sfx_volume := 1.0
var music_volume := 1.0

var num_ids := {
	"crumple": 3,
	"drop": 2,
	"flip": 3,
	"stamp": 2
}

var last_played := {
	"crumple": -1,
	"drop": -1,
	"flip": -1,
	"stamp": 0
}

func play_random(id: String):
	if num_ids.keys().has(id):
		var variation: int = randi() % num_ids[id]
		while variation == last_played[id]:
			variation = randi() % num_ids[id]
		last_played[id] = variation
		var n: AudioStreamPlayer = get_node(id + str(variation + 1))
		n.volume_linear = sfx_volume
		n.play()

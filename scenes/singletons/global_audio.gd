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

var is_music_normal := true

func play_random(id: String):
	if is_zero_approx(sfx_volume):
		return
	if num_ids.keys().has(id):
		var variation: int = randi() % num_ids[id]
		while variation == last_played[id]:
			variation = randi() % num_ids[id]
		last_played[id] = variation
		var n: AudioStreamPlayer = get_node(id + str(variation + 1))
		n.volume_linear = sfx_volume
		n.play()

func music_normal():
	if is_zero_approx(music_volume):
		return
	
	is_music_normal = true
	
	$clocksong1.play($clocksong2.get_playback_position() + AudioServer.get_time_since_last_mix())
	$clocksong1.volume_linear = 0.0
	var intro_tween := $clocksong1.create_tween()
	intro_tween.tween_property($clocksong1, "volume_linear", music_volume, 1.0)
	
	var outro_tween := $clocksong2.create_tween()
	outro_tween.tween_property($clocksong2, "volume_linear", 0.0, 1.0)

func music_frantic():
	if is_zero_approx(music_volume):
		return
	
	is_music_normal = false
	
	$clocksong2.play($clocksong1.get_playback_position() + AudioServer.get_time_since_last_mix())
	$clocksong2.volume_linear = 0.0
	var intro_tween := $clocksong2.create_tween()
	intro_tween.tween_property($clocksong2, "volume_linear", music_volume, 1.0)
	
	var outro_tween := $clocksong1.create_tween()
	outro_tween.tween_property($clocksong1, "volume_linear", 0.0, 1.0)

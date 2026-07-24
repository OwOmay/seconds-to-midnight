extends Control

func _ready() -> void:
	$VBoxContainer/HBoxContainer/HSlider.value = GlobalAudio.sfx_volume
	$VBoxContainer/HBoxContainer2/HSlider.value = GlobalAudio.music_volume

func _on_sfx_volume_value_changed(value: float) -> void:
	GlobalAudio.sfx_volume = value

func _on_music_volume_value_changed(value: float) -> void:
	GlobalAudio.music_volume = value

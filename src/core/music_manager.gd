extends Node

@export var menu_music: AudioStream
@export var game_music: AudioStream
var music_player: AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)

	if menu_music:
		music_player.stream = menu_music
		music_player.play()

func play_new_track(stream: AudioStream):
	music_player.stream = stream
	music_player.play()

func play_game_music():
	music_player.stream = game_music
	music_player.play()

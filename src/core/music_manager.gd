extends Node

@export var menu_music: AudioStream
@export var zone1_music: AudioStream
@export var zone2_music: AudioStream
@export var volume: float
var music_player: AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)

	SignalBus.play_game_music.connect(_on_play_game_music)

func _on_play_game_music(track: String):
	match track:
		"menu":
			play_new_track(menu_music)
		"zone1":
			play_new_track(zone1_music)
		"zone2":
			play_new_track(zone1_music)
		_:
			push_error("[MusicPlayer] unknown music track", track)

func play_new_track(stream: AudioStream):
	music_player.stream = stream
	music_player.volume_linear = volume
	music_player.play()
	print(volume)

extends Node

@export var default_music: AudioStream
var music_player: AudioStreamPlayer

func _ready():
    music_player = AudioStreamPlayer.new()
    add_child(music_player)
    if default_music:
        music_player.stream = default_music
        music_player.play()

func play_new_track(stream: AudioStream):
    music_player.stream = stream
    music_player.play()

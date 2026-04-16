extends Node

@export var menu_music: AudioStream
@export var zone1_music: AudioStream
@export var zone2_music: AudioStream

const SAVE_PATH := "user://settings.cfg"
const SAVE_DELAY := 1.0

var music_player: AudioStreamPlayer
var volume: float = 0.5
var _save_timer: Timer


func _ready():
	music_player = AudioStreamPlayer.new()
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(music_player)

	_setup_save_timer()
	_load_settings()

	SignalBus.play_game_music.connect(_on_play_game_music)
	SignalBus.music_volume_changed.connect(_on_music_volume_changed)
	print("volume on ready:", volume)


func _setup_save_timer():
	_save_timer = Timer.new()
	_save_timer.wait_time = SAVE_DELAY
	_save_timer.one_shot = true
	_save_timer.timeout.connect(_save_settings)
	add_child(_save_timer)


func play_sfx(stream: AudioStream) -> void:
	if not stream: return

	var sfx_player := AudioStreamPlayer.new()
	add_child(sfx_player)

	sfx_player.stream = stream
	sfx_player.play()
	sfx_player.finished.connect(sfx_player.queue_free)


func _on_play_game_music(track: String):
	match track:
		"menu":
			play_new_track(menu_music)
		"zone1":
			play_new_track(zone1_music)
		"zone2":
			play_new_track(zone2_music)
		_:
			push_error("[MusicPlayer] unknown music track", track)


func _on_music_volume_changed(new_volume: float):
	volume = new_volume
	music_player.volume_linear = clamp(volume, 0.0, 1.0)
	_save_timer.start()
	print("volume on change:", volume)


func play_new_track(stream: AudioStream):
	music_player.stream = stream
	music_player.volume_linear = clamp(volume, 0.0, 1.0)
	music_player.play()
	print(volume)


func _save_settings():
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "music_volume", volume)
	var err := cfg.save(SAVE_PATH)
	if err != OK:
		push_error("[MusicManager] Failed to save settings: ", err)
	else:
		print("[MusicManager] Settings saved.")


func _load_settings():
	var cfg := ConfigFile.new()
	var err := cfg.load(SAVE_PATH)
	if err != OK:
		print("[MusicManager] No settings file found, using defaults.")
		return
	volume = cfg.get_value("audio", "music_volume", volume)
	music_player.volume_linear = clamp(volume, 0.0, 1.0)
	print("[MusicManager] Loaded volume: ", volume)

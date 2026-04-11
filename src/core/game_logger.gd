# GameLogger.gd
class_name GameLogger
extends Logger

var _mutex := Mutex.new()
var _pending: Array[String] = []

func _log_message(message: String, _b: bool) -> void:
	_mutex.lock()
	_pending.append(message)
	_mutex.unlock()

func _log_error(
	function: String, file: String,
	line: int,
	code: String,
	rationale: String,
	_editor_notify: bool,
	error_type: int,
	_script_backtraces: Array[ScriptBacktrace]
) -> void:
	_mutex.lock()
	var message = "function %s file %s line %s code %s rationale %s error_type %s" % [function, file, line, code, rationale, error_type]
	_pending.append(message)
	_mutex.unlock()

func flush() -> void:
	_mutex.lock()
	var entries := _pending.duplicate()
	_pending.clear()
	_mutex.unlock()

	for entry in entries:
		SignalBus.log_entry_added.emit(entry)

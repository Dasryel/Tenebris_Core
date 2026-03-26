## Flyweight cache — reuses a single instance per [b]stateless[/b] [BaseState] type.
##
## Only valid for states with no mutable instance fields.
## States that carry per-entity data must be instantiated with [code].new()[/code] instead.
class_name StateCache

# Untyped dictionary because the key is a GDScript class reference.
static var _cache: Dictionary = {}


## Returns (and lazily creates) the singleton instance for [param state_script].
static func get_state(state_script: GDScript) -> BaseState:
	if not _cache.has(state_script):
		_cache[state_script] = state_script.new()
	return _cache[state_script]

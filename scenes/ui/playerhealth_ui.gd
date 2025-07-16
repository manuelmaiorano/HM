extends ProgressBar


func _ready() -> void:
	Globals.PlayerHealthChanged.connect(func (x): value = x * 100)
	
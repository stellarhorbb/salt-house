# scripts/ui/shop_scene.gd
# Écran de shop entre les zones — stub en attente du catalogue Echoes/Shells.
# Le bouton Leave déclenche le chargement de la prochaine zone.
extends Control


@onready var salt_label: Label    = $SaltLabel
@onready var leave_button: Button = $LeaveButton


func _ready() -> void:
	salt_label.text = str(BankrollManager.salt) + " SALT"
	leave_button.pressed.connect(_on_leave_pressed)
	SignalBus.salt_changed.connect(_on_salt_changed)


func _on_salt_changed(new_amount: int) -> void:
	salt_label.text = str(new_amount) + " SALT"


func _on_leave_pressed() -> void:
	EntityManager.proceed_to_next_zone()

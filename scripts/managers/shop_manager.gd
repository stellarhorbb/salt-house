# scripts/managers/shop_manager.gd
# Autoload "ShopManager" — sole owner of the shop between zones.
# Handles displayed inventory, purchases, and rerolls.
extends Node


var reroll_count: int = 0
var current_stock: Array = []  # Array[EchoResource | ShellResource]


func _ready() -> void:
	SignalBus.zone_completed.connect(_on_zone_completed)
	SignalBus.shop_rerolled.connect(_on_shop_rerolled)
	SignalBus.item_purchased.connect(_on_item_purchased)


func get_reroll_cost() -> int:
	return GameRules.SHOP_REROLL_BASE_COST + reroll_count * GameRules.SHOP_REROLL_INCREMENT


func reroll() -> void:
	if not BankrollManager.can_afford(get_reroll_cost()):
		return
	BankrollManager.remove(get_reroll_cost())
	reroll_count += 1
	_populate_stock()
	SignalBus.shop_rerolled.emit()


func _populate_stock() -> void:
	# ⚠️ TODO — random selection from Echo/Shell catalog
	current_stock.clear()


# ── Signals ────────────────────────────────────────────────────────────────────

func _on_zone_completed() -> void:
	reroll_count = 0
	_populate_stock()


func _on_shop_rerolled() -> void:
	pass


func _on_item_purchased(item) -> void:
	current_stock.erase(item)

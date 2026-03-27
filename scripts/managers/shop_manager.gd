# scripts/managers/shop_manager.gd
# Autoload "ShopManager" — gère le stock entre les zones et les achats.
# Pour l'instant : un seul Moon Pack composé de 2 cartes tirées aléatoirement.
extends Node


const FIRST_QUARTER := preload("res://resources/moon_cards/first_quarter.tres")
const LAST_QUARTER  := preload("res://resources/moon_cards/last_quarter.tres")
const FULL_MOON     := preload("res://resources/moon_cards/full_moon.tres")
const NEW_MOON      := preload("res://resources/moon_cards/new_moon.tres")

var reroll_count: int = 0
# Les 2 Moon Cards actuellement dans le pack
var pack_cards: Array[MoonCardResource] = []


func _ready() -> void:
	SignalBus.zone_completed.connect(_on_zone_completed)


func get_reroll_cost() -> int:
	if reroll_count >= GameRules.SHOP_REROLL_COSTS.size():
		return GameRules.SHOP_REROLL_COSTS[-1]
	return GameRules.SHOP_REROLL_COSTS[reroll_count]


func can_reroll() -> bool:
	return reroll_count < GameRules.SHOP_REROLL_COSTS.size() \
		and GoldShellManager.can_afford(get_reroll_cost())


func reroll() -> void:
	if not can_reroll():
		return
	GoldShellManager.remove(get_reroll_cost())
	reroll_count += 1
	_populate_stock()
	SignalBus.shop_rerolled.emit()


func can_buy_pack() -> bool:
	return GoldShellManager.can_afford(GameRules.SHOP_MOON_PACK_PRICE)


func buy_pack() -> void:
	if not can_buy_pack():
		return
	GoldShellManager.remove(GameRules.SHOP_MOON_PACK_PRICE)


func _populate_stock() -> void:
	var all: Array[MoonCardResource] = [FIRST_QUARTER, LAST_QUARTER, FULL_MOON, NEW_MOON]
	all.shuffle()
	pack_cards = [all[0], all[1]]


# ── Signals ────────────────────────────────────────────────────────────────────

func _on_zone_completed() -> void:
	reroll_count = 0
	_populate_stock()

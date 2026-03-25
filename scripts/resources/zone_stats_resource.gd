# scripts/resources/zone_stats_resource.gd
# Stats for one depth encounter.
class_name ZoneStatsResource
extends Resource


@export var zone_number: int = 1
@export var zone_name: String = ""
@export var salt_pool: int = 200
@export var mutations: int = 0
@export var is_boss: bool = false

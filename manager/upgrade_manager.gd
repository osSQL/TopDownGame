extends Node

@export var experience_manager: ExperienceManager
@export var upgrade_pool: Array[AbilityUpgrade]


var current_upgrades = {}

func _ready():
	experience_manager.level_up.connect(on_level_up)
	
func on_level_up(current_level):
	var choosen_upgrade = upgrade_pool.pick_random() as AbilityUpgrade
	if choosen_upgrade == null:
		return
		
	var has_upgrade = current_upgrades.has(choosen_upgrade.id)
	
	if !has_upgrade:
		current_upgrades[choosen_upgrade.id] = {
			"upgrade": choosen_upgrade,
			"quantity": 1
		}
		
	else:
		current_upgrades[choosen_upgrade.id]["quantity"] += 1
	
	print(current_upgrades)

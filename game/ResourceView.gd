extends Control

onready var game = find_parent("Game")

func update_resources():
	$DayLabel.text = "Day: %d" % game.day
	$Panel/HBoxContainer/PowerLabel.text = "Power: %d (%+d)" % [game.power, game.power_flow]
	$Panel/HBoxContainer/ClimateLabel.text = "Climate: %d (%+d)" % [game.climate, game.climate_flow]
	$Panel/HBoxContainer/FoodLabel.text = "Food: %d (%+d)" % [game.food, game.food_flow]
	$Panel/HBoxContainer/WaterLabel.text = "Water: %d (%+d)" % [game.water, game.water_flow]
	$Panel/HBoxContainer/MineralsLabel.text = "Minerals: %d (%+d)" % [game.minerals, game.minerals_flow]
	$Panel/HBoxContainer/MetalLabel.text = "Metal: %d (%+d)" % [game.metal, game.metal_flow]

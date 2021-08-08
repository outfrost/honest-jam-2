extends Control

func update_resources(
	power,
	power_flow,
	climate,
	climate_flow,
	food,
	food_flow,
	water,
	water_flow,
	minerals,
	minerals_flow,
	metal,
	metal_flow
):
	$Panel/HBoxContainer/PowerLabel.text = "Power: %d (%+d)" % [power, power_flow]
	$Panel/HBoxContainer/ClimateLabel.text = "Climate: %d (%+d)" % [climate, climate_flow]
	$Panel/HBoxContainer/FoodLabel.text = "Food: %d (%+d)" % [food, food_flow]
	$Panel/HBoxContainer/WaterLabel.text = "Water: %d (%+d)" % [water, water_flow]
	$Panel/HBoxContainer/MineralsLabel.text = "Minerals: %d (%+d)" % [minerals, minerals_flow]
	$Panel/HBoxContainer/MetalLabel.text = "Metal: %d (%+d)" % [metal, metal_flow]

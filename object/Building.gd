extends Spatial

export var power_flow: int = 0
export var water_flow: int = 0
export var climate_flow: int = 0
export var food_flow: int = 0
export var minerals_flow: int = 0
export var metal_flow: int = 0

export(Tile.Type) var build_on = Tile.Type.BUILD
export var requires_neighbour: bool = false
export(Tile.Type) var neighbour = Tile.Type.BLANK

export var cost: int = 0

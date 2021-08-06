extends Spatial

var tilemap = {}

func _ready() -> void:
	var tiles = $Tiles.get_children()
	for _tile in tiles:
		var tile: Tile = _tile # lol

		# calculate tilemap coordinates
		var x = int(round(tile.global_transform.origin.x * 0.5))
		var z = int(round(tile.global_transform.origin.z * 0.5))

		if x in tilemap && z in tilemap[x]:
			push_error("Duplicate tile (%d, %d)" % [x, z])
			continue

		if !(x in tilemap):
			# create row
			tilemap[x] = {}

		tilemap[x][z] = tile

		# link with neighbouring tiles
		if z - 1 in tilemap[x]:
			tile.link[Tile.Dir.NORTH] = tilemap[x][z - 1]
			tilemap[x][z - 1].link[Tile.Dir.SOUTH] = tile
		if x + 1 in tilemap && z in tilemap[x + 1]:
			tile.link[Tile.Dir.EAST] = tilemap[x + 1][z]
			tilemap[x + 1][z].link[Tile.Dir.WEST] = tile
		if z + 1 in tilemap[x]:
			tile.link[Tile.Dir.SOUTH] = tilemap[x][z + 1]
			tilemap[x][z + 1].link[Tile.Dir.NORTH] = tile
		if x - 1 in tilemap && z in tilemap[x - 1]:
			tile.link[Tile.Dir.WEST] = tilemap[x - 1][z]
			tilemap[x - 1][z].link[Tile.Dir.EAST] = tile

#	for x in tilemap:
#		for z in tilemap[x]:
#			var links: String = ""
#			for k in (tilemap[x][z] as Tile).link:
#				if (tilemap[x][z] as Tile).link[k]:
#					links += Tile.dir_str(k) + ", "
#			print_debug("(%d, %d) [ %s ]" % [x, z, links])

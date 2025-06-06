/datum/craft_recipe/floor
	category = "Floors"
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_STEEL),
	)
	flags = CRAFT_BATCH
	time = 1 //Crafting individual tiles is fast
	related_stats = list(STAT_MEC)

/datum/craft_recipe/floor/underplating
	name = "underplating"
	result = /obj/effect/flooring_type_spawner
	time = WORKTIME_SLOW
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	steps = list(
		list(CRAFT_MATERIAL, 15, MATERIAL_STEEL)
	)
	related_stats = list(STAT_MEC)

/datum/craft_recipe/floor/catwalk
	name = "catwalk"
	result = /obj/structure/catwalk
	time = WORKTIME_FAST
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	steps = list(
		list(CRAFT_MATERIAL, 8, MATERIAL_STEEL)
	)
	related_stats = list(STAT_MEC)

/datum/craft_recipe/floor/wood
	name = "wood floor tile"
	result = /obj/item/stack/tile/wood
	icon_state = "woodworking"
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_WOOD)
	)

/datum/craft_recipe/floor/ashwood
	name = "ash wood floor tile"
	result = /obj/item/stack/tile/wood/ashen
	icon_state = "woodworking"
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_WOOD)
	)

/datum/craft_recipe/floor/redashen
	name = "red ash wood floor tile"
	result = /obj/item/stack/tile/wood/ashen/red
	icon_state = "woodworking"
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_WOOD)
	)

/datum/craft_recipe/floor/dullashen
	name = "dull ash wood floor tile"
	result = /obj/item/stack/tile/wood/ashen/dull
	icon_state = "woodworking"
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_WOOD)
	)

/datum/craft_recipe/floor/rustic
	name = "rustic wood floor tile"
	result = /obj/item/stack/tile/wood/old
	icon_state = "woodworking"
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_WOOD)
	)

/datum/craft_recipe/floor/veridicalrustic
	name = "veridical rustic wood floor tile"
	result = /obj/item/stack/tile/wood/old/veridical
	icon_state = "woodworking"
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_WOOD)
	)

/datum/craft_recipe/floor/cafe
	name = "cafe floor tile"
	result = /obj/item/stack/tile/floor/cafe
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_PLASTIC)
	)

/datum/craft_recipe/floor/techmaint
	name = "maintenance floor tile"
	result = /obj/item/stack/tile/floor/techmaint
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_STEEL)
	)

/datum/craft_recipe/floor/techmaint_perforated
	name = "perforated maintenance floor tile"
	result = /obj/item/stack/tile/floor/techmaint/perforated
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_STEEL)
	)

/datum/craft_recipe/floor/techmaint_panels
	name = "panels maintenance floor tile"
	result = /obj/item/stack/tile/floor/techmaint/panels
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_STEEL)
	)

/datum/craft_recipe/floor/techmaint_cargo
	name = "cargo maintenance floor tile"
	result = /obj/item/stack/tile/floor/techmaint/cargo
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_STEEL)
	)

/datum/craft_recipe/floor/steel
	name = "regular steel floor tile"
	result = /obj/item/stack/tile/floor/steel

/datum/craft_recipe/floor/steel/panels
	name = "steel panel tile"
	result = /obj/item/stack/tile/floor/steel/panels

/datum/craft_recipe/floor/steel/techfloor
	name = "steel tech-floor tile"
	result = /obj/item/stack/tile/floor/steel/techfloor

/datum/craft_recipe/floor/steel/techfloor_grid
	name = "steel tech-floor tile with vents"
	result = /obj/item/stack/tile/floor/steel/techfloor_grid

/datum/craft_recipe/floor/steel/brown_perforated
	name = "steel brown perforated tile"
	result = /obj/item/stack/tile/floor/steel/brown_perforated

/datum/craft_recipe/floor/steel/gray_perforated
	name = "steel gray perforated tile"
	result = /obj/item/stack/tile/floor/steel/gray_perforated

/datum/craft_recipe/floor/steel/cargo
	name = "steel cargo tile"
	result = /obj/item/stack/tile/floor/steel/cargo

/datum/craft_recipe/floor/steel/brown_platform
	name = "steel brown platform tile"
	result = /obj/item/stack/tile/floor/steel/brown_platform

/datum/craft_recipe/floor/steel/gray_platform
	name = "steel gray platform tile"
	result = /obj/item/stack/tile/floor/steel/gray_platform

/datum/craft_recipe/floor/steel/danger
	name = "steel danger tile"
	result = /obj/item/stack/tile/floor/steel/danger

/datum/craft_recipe/floor/steel/golden
	name = "steel golden tile"
	result = /obj/item/stack/tile/floor/steel/golden

/datum/craft_recipe/floor/steel/bluecorner
	name = "steel blue corner tile"
	result = /obj/item/stack/tile/floor/steel/bluecorner

/datum/craft_recipe/floor/steel/orangecorner
	name = "steel orange corner tile"
	result = /obj/item/stack/tile/floor/steel/orangecorner

/datum/craft_recipe/floor/steel/cyancorner
	name = "steel cyan corner tile"
	result = /obj/item/stack/tile/floor/steel/cyancorner

/datum/craft_recipe/floor/steel/violetcorener
	name = "steel violet corner tile"
	result = /obj/item/stack/tile/floor/steel/violetcorener

/datum/craft_recipe/floor/steel/monofloor
	name = "steel mono-floor tile"
	result = /obj/item/stack/tile/floor/steel/monofloor

/datum/craft_recipe/floor/steel/bar_flat
	name = "steel bar flat tile"
	result = /obj/item/stack/tile/floor/steel/bar_flat

/datum/craft_recipe/floor/steel/bar_dance
	name = "steel bar dance tile"
	result = /obj/item/stack/tile/floor/steel/bar_dance

/datum/craft_recipe/floor/steel/bar_light
	name = "steel bar light tile"
	result = /obj/item/stack/tile/floor/steel/bar_light


/datum/craft_recipe/floor/white
	name = "regular white floor tile"
	result = /obj/item/stack/tile/floor/white
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_PLASTIC)
	)

/datum/craft_recipe/floor/white/panels
	name = "white panel tile"
	result = /obj/item/stack/tile/floor/white/panels

/datum/craft_recipe/floor/white/techfloor
	name = "white tech-floor tile"
	result = /obj/item/stack/tile/floor/white/techfloor

/datum/craft_recipe/floor/white/techfloor_grid
	name = "white tech-floor tile with vents"
	result = /obj/item/stack/tile/floor/white/techfloor_grid

/datum/craft_recipe/floor/white/brown_perforated
	name = "white brown perforated tile"
	result = /obj/item/stack/tile/floor/white/brown_perforated

/datum/craft_recipe/floor/white/gray_perforated
	name = "white gray perforated tile"
	result = /obj/item/stack/tile/floor/white/gray_perforated

/datum/craft_recipe/floor/white/cargo
	name = "white cargo tile"
	result = /obj/item/stack/tile/floor/white/cargo

/datum/craft_recipe/floor/white/brown_platform
	name = "white brown platform tile"
	result = /obj/item/stack/tile/floor/white/brown_platform

/datum/craft_recipe/floor/white/gray_platform
	name = "white gray platform tile"
	result = /obj/item/stack/tile/floor/white/gray_platform

/datum/craft_recipe/floor/white/danger
	name = "white danger tile"
	result = /obj/item/stack/tile/floor/white/danger

/datum/craft_recipe/floor/white/golden
	name = "white golden tile"
	result = /obj/item/stack/tile/floor/white/golden

/datum/craft_recipe/floor/white/bluecorner
	name = "white blue corner tile"
	result = /obj/item/stack/tile/floor/white/bluecorner

/datum/craft_recipe/floor/white/orangecorner
	name = "white orange corner tile"
	result = /obj/item/stack/tile/floor/white/orangecorner

/datum/craft_recipe/floor/white/cyancorner
	name = "white cyan corner tile"
	result = /obj/item/stack/tile/floor/white/cyancorner

/datum/craft_recipe/floor/white/violetcorener
	name = "white violet corner tile"
	result = /obj/item/stack/tile/floor/white/violetcorener

/datum/craft_recipe/floor/white/monofloor
	name = "white mono-floor tile"
	result = /obj/item/stack/tile/floor/white/monofloor

/datum/craft_recipe/floor/dark
	name = "regular dark floor tile"
	result = /obj/item/stack/tile/floor/dark

/datum/craft_recipe/floor/dark/panels
	name = "dark panel tile"
	result = /obj/item/stack/tile/floor/dark/panels

/datum/craft_recipe/floor/dark/techfloor
	name = "dark tech-floor tile"
	result = /obj/item/stack/tile/floor/dark/techfloor

/datum/craft_recipe/floor/dark/techfloor_grid
	name = "dark tech-floor tile with vents"
	result = /obj/item/stack/tile/floor/dark/techfloor_grid

/datum/craft_recipe/floor/dark/brown_perforated
	name = "dark brown perforated tile"
	result = /obj/item/stack/tile/floor/dark/brown_perforated

/datum/craft_recipe/floor/dark/gray_perforated
	name = "dark gray perforated tile"
	result = /obj/item/stack/tile/floor/dark/gray_perforated

/datum/craft_recipe/floor/dark/cargo
	name = "dark cargo tile"
	result = /obj/item/stack/tile/floor/dark/cargo

/datum/craft_recipe/floor/dark/brown_platform
	name = "dark brown platform tile"
	result = /obj/item/stack/tile/floor/dark/brown_platform

/datum/craft_recipe/floor/dark/gray_platform
	name = "dark gray platform tile"
	result = /obj/item/stack/tile/floor/dark/gray_platform

/datum/craft_recipe/floor/dark/danger
	name = "dark danger tile"
	result = /obj/item/stack/tile/floor/dark/danger

/datum/craft_recipe/floor/dark/golden
	name = "dark golden tile"
	result = /obj/item/stack/tile/floor/dark/golden

/datum/craft_recipe/floor/dark/bluecorner
	name = "dark blue corner tile"
	result = /obj/item/stack/tile/floor/dark/bluecorner

/datum/craft_recipe/floor/dark/orangecorner
	name = "dark orange corner tile"
	result = /obj/item/stack/tile/floor/dark/orangecorner

/datum/craft_recipe/floor/dark/cyancorner
	name = "dark cyan corner tile"
	result = /obj/item/stack/tile/floor/dark/cyancorner

/datum/craft_recipe/floor/dark/violetcorener
	name = "dark violet corner tile"
	result = /obj/item/stack/tile/floor/dark/violetcorener

/datum/craft_recipe/floor/dark/monofloor
	name = "dark mono-floor tile"
	result = /obj/item/stack/tile/floor/dark/monofloor

/datum/craft_recipe/floor/lighttile
	name = "light tile"
	icon_state = "gun"
	result = /obj/machinery/floor_light
	steps = list(
		list(CRAFT_MATERIAL, 3, MATERIAL_GLASS, "time" = 30),
		list(CRAFT_MATERIAL, 2, MATERIAL_STEEL, "time" = 10),
		list(QUALITY_SCREW_DRIVING, 10, 80),
		list(/obj/item/stack/cable_coil, 5, "time" = 20),
		list(QUALITY_PULSING, 30, 80)
	)

// Maintenance floor tiles

/datum/craft_recipe/floor/maint
	name = "concrete slabs"
	steps = list(
		list(/obj/item/stack/cement_bag, 1, "time" = 1),
	)
	result = /obj/item/stack/tile/concrete_small_fixed

/datum/craft_recipe/floor/maint/concrete_bricks
	name = "concrete bricks"
	result = /obj/item/stack/tile/concrete_bricks_fixed

/datum/craft_recipe/floor/maint/bricks
	name = "bricks"
	result = /obj/item/stack/tile/bricks_fixed

/datum/craft_recipe/floor/maint/ornate
	name = "painted slates"
	result = /obj/item/stack/tile/ornate_fixed

/datum/craft_recipe/floor/maint/sierra
	name = "ornate slates"
	result = /obj/item/stack/tile/sierra_fixed

/datum/craft_recipe/floor/maint/ceramic
	name = "ceramic slates"
	result = /obj/item/stack/tile/ceramic_fixed

/datum/craft_recipe/floor/maint/grey_slates_long
	name = "grey long slates"
	result = /obj/item/stack/tile/grey_slates_long_fixed

/datum/craft_recipe/floor/maint/blue_slates_long
	name = "blue long slates"
	result = /obj/item/stack/tile/blue_slates_long_fixed

/datum/craft_recipe/floor/maint/grey_slates
	name = "grey slates"
	result = /obj/item/stack/tile/grey_slates_fixed

/datum/craft_recipe/floor/maint/blue_slates
	name = "blue slates"
	result = /obj/item/stack/tile/blue_slates_fixed

/datum/craft_recipe/floor/maint/navy_slates
	name = "navy slates"
	result = /obj/item/stack/tile/navy_slates_fixed

/datum/craft_recipe/floor/maint/fancy_slates
	name = "disk slates"
	result = /obj/item/stack/tile/fancy_slates_fixed

/datum/craft_recipe/floor/maint/navy_large_slates
	name = "navy large slates"
	result = /obj/item/stack/tile/navy_large_slates_fixed

/datum/craft_recipe/floor/maint/black_large_slates
	name = "black large slates"
	result = /obj/item/stack/tile/black_large_slates_fixed

/datum/craft_recipe/floor/maint/green_large_slates
	name = "green large slates"
	result = /obj/item/stack/tile/green_large_slates_fixed

/datum/craft_recipe/floor/maint/white_large_slates
	name = "white large slates"
	result = /obj/item/stack/tile/white_large_slates_fixed

/datum/craft_recipe/floor/maint/checker_large_slates
	name = "white and black large slates"
	result = /obj/item/stack/tile/checker_large_fixed

/datum/craft_recipe/floor/maint/cafe_large_slates
	name = "white and red large slates"
	result = /obj/item/stack/tile/cafe_large_fixed

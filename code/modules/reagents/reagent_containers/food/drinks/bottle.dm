///////////////////////////////////////////////Alcohol bottles! -Agouri //////////////////////////
//Functionally identical to regular drinks. The only difference is that the default bottle size is 100. - Darem
//Bottles now weaken and break when smashed on people's heads. - Giacom
//Many thanks to Eris and CeUvi, WalterJe to make most the bottle/can sprites

/obj/item/reagent_containers/drinks/bottle
	amount_per_transfer_from_this = 10
	volume = 100
	description_info = "Thrown bottles don't break when you throw them while being on help intent."
	item_state = "broken_beer" //Generic held-item sprite until unique ones are made.
	force = WEAPON_FORCE_WEAK
	throwforce = WEAPON_FORCE_WEAK
	var/smash_duration = 5 //Directly relates to the 'weaken' duration. Lowered by armor (i.e. helmets)
	var/isGlass = 1 //Whether the 'bottle' is made of glass or not so that milk cartons dont shatter when someone gets hit by it

	var/obj/item/reagent_containers/glass/rag/rag
	var/rag_underlay = "rag"
	var/icon_state_full
	var/icon_state_empty
	var/bottle_thrower_intent

/obj/item/reagent_containers/drinks/bottle/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/drinks/bottle/Initialize()
	icon_state_full = "[icon_state]"
	if (icon_state_empty == null)
		icon_state_empty = "[icon_state]_empty"
	. = ..()
	if(isGlass)
		unacidable = TRUE


/obj/item/reagent_containers/drinks/bottle/Destroy()
	if(rag)
		rag.forceMove(src.loc)
	rag = null
	return ..()

/obj/item/reagent_containers/drinks/bottle/throw_at(atom/target, range, speed, thrower)
	var/mob/H = thrower
	if(istype(H))
		bottle_thrower_intent = H.a_intent
	..()
	bottle_thrower_intent = null

//when thrown on impact, bottles smash and spill their contents
/obj/item/reagent_containers/drinks/bottle/throw_impact(atom/hit_atom, speed)
	..()

	if(bottle_thrower_intent != I_HELP)
		if(reagents && reagents.total_volume)
			hit_atom.visible_message(SPAN_NOTICE("The contents of \the [src] splash all over [hit_atom]!"))
			reagents.splash(hit_atom, reagents.total_volume)
		src.smash(loc, hit_atom)

/obj/item/reagent_containers/drinks/bottle/proc/smash_check(distance)
	if(!isGlass || !smash_duration)
		return 0
	else
		return TRUE

/obj/item/reagent_containers/drinks/bottle/proc/smash(newloc, atom/against)
	if(ismob(loc))
		var/mob/M = loc
		M.drop_from_inventory(src)

	//Creates a shattering noise and replaces the bottle with a broken_bottle
	var/obj/item/tool/broken_bottle/B = new /obj/item/tool/broken_bottle(newloc)
	if(prob(33))
		new/obj/item/material/shard(newloc) // Create a glass shard at the target's location!
	B.icon_state = src.icon_state

	var/icon/I = new('icons/obj/drinks.dmi', src.icon_state)
	I.Blend(B.broken_outline, ICON_OVERLAY, rand(5), 1)
	I.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0))
	B.icon = I

	if(rag && rag.on_fire && isliving(against))
		rag.forceMove(loc)
		var/mob/living/L = against
		L.IgniteMob()

	playsound(src,'sound/effects/GLASS_Rattle_Many_Fragments_01_stereo.ogg',100,1)
	src.transfer_fingerprints_to(B)

	qdel(src)
	return B

/obj/item/reagent_containers/drinks/bottle/attackby(obj/item/W, mob/user)
	if(!rag && istype(W, /obj/item/reagent_containers/glass/rag))
		insert_rag(W, user)
		return
	if(rag && istype(W, /obj/item/flame))
		rag.attackby(W, user)
		return
	..()

/obj/item/reagent_containers/drinks/bottle/attack_self(mob/user)
	if(rag)
		remove_rag(user)
	else
		..()

/obj/item/reagent_containers/drinks/bottle/proc/insert_rag(obj/item/reagent_containers/glass/rag/R, mob/user)
	if(!isGlass || rag) return
	if(user.unEquip(R))
		to_chat(user, SPAN_NOTICE("You stuff [R] into [src]."))
		rag = R
		rag.forceMove(src)
		reagent_flags &= ~OPENCONTAINER
		verbs -= /obj/item/reagent_containers/drinks/proc/gulp_whole
		update_icon()

/obj/item/reagent_containers/drinks/bottle/proc/remove_rag(mob/user)
	if(!rag) return
	user.put_in_hands(rag)
	rag = null
	var/was_open_container = initial(reagent_flags) & OPENCONTAINER
	if(was_open_container)
		reagent_flags |= OPENCONTAINER
		verbs += /obj/item/reagent_containers/drinks/proc/gulp_whole
	update_icon()

/obj/item/reagent_containers/drinks/bottle/open(mob/user)
	if(rag) return
	..()

/obj/item/reagent_containers/drinks/bottle/update_icon()
	underlays.Cut()
	if(rag)
		var/underlay_image = image(icon='icons/obj/drinks.dmi', icon_state=rag.on_fire? "[rag_underlay]_lit" : rag_underlay)
		underlays += underlay_image
		set_light(2)
	else
		set_light(0)
		if(reagents && reagents.total_volume)
			icon_state = icon_state_full
		else
			icon_state = icon_state_empty

/obj/item/reagent_containers/drinks/bottle/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	..()

	if(user.a_intent != I_HURT)
		return
	if(!smash_check(1))
		return //won't always break on the first hit

	// You are going to knock someone out for longer if they are not wearing a helmet.
	var/weaken_duration = smash_duration + min(0, force - target.getarmor(hit_zone, ARMOR_MELEE) + 10)

	var/mob/living/carbon/human/H = target
	if(istype(H) && H.headcheck(hit_zone))
		var/obj/item/organ/affecting = H.get_organ(hit_zone) //headcheck should ensure that affecting is not null
		user.visible_message(SPAN_DANGER("[user] smashes [src] into [H]'s [affecting.name]!"))
		if(weaken_duration)
			target.apply_effect(min(weaken_duration, 5), WEAKEN, armor_value = target.getarmor(hit_zone, ARMOR_MELEE)) // Never weaken more than a flash!
	else
		user.visible_message(SPAN_DANGER("\The [user] smashes [src] into [target]!"))

	//The reagents in the bottle splash all over the target, thanks for the idea Nodrak
	if(reagents && reagents.total_volume)
		user.visible_message(SPAN_NOTICE("The contents of \the [src] splash all over [target]!"))
		reagents.splash(target, reagents.total_volume)

	//Finally, smash the bottle. This kills (qdel) the bottle.
	var/obj/item/tool/broken_bottle/B = smash(target.loc, target)
	user.put_in_active_hand(B)

//// Precreated bottles ////

/obj/item/reagent_containers/drinks/bottle/gin
	name = "Griffeater Gin"
	desc = "A bottle of high quality gin."
	icon_state = "ginbottle"
	center_of_mass = list("x"=16, "y"=4)
	preloaded_reagents = list("gin" = 100)

/obj/item/reagent_containers/drinks/bottle/whiskey
	name = "Uncle Git's Special Reserve Whiskey"
	desc = "A premium single-malt whiskey, gently matured."
	icon_state = "whiskeybottle"
	center_of_mass = list("x"=16, "y"=3)
	preloaded_reagents = list("whiskey" = 100)

/obj/item/reagent_containers/drinks/bottle/vodka
	name = "Tunguska Triple Distilled Vodka"
	desc = "A brand of vodka known for being cheap and mass produced."
	icon_state = "vodkabottle"
	center_of_mass = list("x"=17, "y"=3)
	preloaded_reagents = list("vodka" = 100)

/obj/item/reagent_containers/drinks/bottle/tequilla
	name = "Caccavo Guaranteed Quality Tequilla"
	desc = "Made from premium petroleum distillates, pure thalidomide and other fine quality ingredients!"
	icon_state = "tequillabottle"
	center_of_mass = list("x"=16, "y"=3)
	preloaded_reagents = list("tequilla" = 100)

/obj/item/reagent_containers/drinks/bottle/bottleofnothing
	name = "Bottle of Nothing"
	desc = "A bottle filled with nothing"
	icon_state = "bottleofnothing"
	center_of_mass = list("x"=17, "y"=5)
	preloaded_reagents = list("nothing" = 100)

/obj/item/reagent_containers/drinks/bottle/patron
	name = "Wrapp Artiste Patron Tequilla"
	desc = "Silver laced tequilla, served in space night clubs across the galaxy."
	icon_state = "patronbottle"
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("patron" = 100)

/obj/item/reagent_containers/drinks/bottle/rum
	name = "Captain Pete's Cuban Spiced Rum"
	desc = "A brand of rum beloved by pirates and bandits."
	icon_state = "rumbottle"
	center_of_mass = list("x"=16, "y"=8)
	preloaded_reagents = list("rum" = 100)

/obj/item/reagent_containers/drinks/bottle/rombuty
	name = "Captain Flint's Secret Rum"
	desc = "A premium brand of rum."
	icon_state = "rombuty"
	item_state = "rombuty"
	center_of_mass = list("x"=16, "y"=8)
	preloaded_reagents = list("rum" = 100)

/obj/item/reagent_containers/drinks/bottle/vermouth
	name = "Goldeneye Vermouth"
	desc = "Sweet, sweet dryness."
	icon_state = "vermouthbottle"
	center_of_mass = list("x"=17, "y"=3)
	preloaded_reagents = list("vermouth" = 100)

/obj/item/reagent_containers/drinks/bottle/kahlua
	name = "Robert Robust's Coffee Kahlua"
	desc = "A brand of coffee-flavoured liqueur."
	icon_state = "kahluabottle"
	center_of_mass = list("x"=17, "y"=3)
	preloaded_reagents = list("kahlua" = 100)

/obj/item/reagent_containers/drinks/bottle/goldschlager
	name = "John Prince's Goldschlager"
	desc = "A generic brand of goldschlager."
	icon_state = "goldschlagerbottle"
	center_of_mass = list("x"=15, "y"=3)
	preloaded_reagents = list("goldschlager" = 100)

/obj/item/reagent_containers/drinks/bottle/cognac
	name = "Chateau De Baton Premium Cognac"
	desc = "A strong alchoholic drink, made after numerous distillations and years of maturing."
	icon_state = "cognacbottle"
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("cognac" = 100)

/obj/item/reagent_containers/drinks/bottle/wine
	name = "Doublebeard Bearded Special Wine"
	desc = "A bottle of well aged wine."
	icon_state = "winebottle"
	center_of_mass = list("x"=16, "y"=4)
	preloaded_reagents = list("wine" = 100)

/obj/item/reagent_containers/drinks/bottle/ntcahors
	name = "Absolutism Cahors Wine"
	desc = "Ritual drink that cleanses the soul and body."
	icon_state = "ntcahors"
	center_of_mass = list("x"=16, "y"=4)
	preloaded_reagents = list("ntcahors" = 100)

/obj/item/reagent_containers/drinks/bottle/absinthe
	name = "Jailbreaker Absinthe"
	desc = "A brand of Absinthe."
	icon_state = "absinthebottle"
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("absinthe" = 100)

/obj/item/reagent_containers/drinks/bottle/melonliquor
	name = "Emeraldine Melon Liquor"
	desc = "A bottle of 46 proof Emeraldine Melon Liquor. Sweet and light."
	icon_state = "alco-green"
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("melonliquor" = 100)
	icon_state_empty = "alco-empty"

/obj/item/reagent_containers/drinks/bottle/bluecuracao
	name = "Miss Blue Curacao"
	desc = "A fruity, exceptionally azure drink."
	icon_state = "alco-blue"
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("bluecuracao" = 100)
	icon_state_empty = "alco-empty"

/obj/item/reagent_containers/drinks/bottle/redcandywine
	name = "Mister Red Candy Liquor"
	desc = "Made from astored sweets, candies and even flowers."
	icon_state = "alco-red"
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("redcandyliquor" = 100)
	icon_state_empty = "alco-empty"

/obj/item/reagent_containers/drinks/bottle/nanatsunoumi
	name = "Nanatsunoumi"
	desc = "A harsh salty alcohol."
	icon_state = "alco-white"
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("nanatsunoumi" = 100)
	icon_state_empty = "alco-empty"

/obj/item/reagent_containers/drinks/bottle/grenadine
	name = "Briar Rose Grenadine Syrup"
	desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."
	icon_state = "grenadinebottle"
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("grenadine" = 100)

/obj/item/reagent_containers/drinks/bottle/cola
	name = "\improper Space Cola"
	desc = "A can of Space Cola branded cola"
	icon_state = "colabottle"
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("cola" = 100)

/obj/item/reagent_containers/drinks/bottle/space_up
	name = "\improper Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up_bottle"
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("space_up" = 100)

/obj/item/reagent_containers/drinks/bottle/space_mountain_wind
	name = "\improper Space Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind_bottle"
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("spacemountainwind" = 100)

/obj/item/reagent_containers/drinks/bottle/pwine
	name = "Warlock's Velvet"
	desc = "What a delightful packaging for a surely high quality wine! The vintage must be amazing!"
	icon_state = "pwinebottle"
	center_of_mass = list("x"=16, "y"=4)
	preloaded_reagents = list("pwine" = 100)

/obj/item/reagent_containers/drinks/bottle/fernet
	name = "Fernet Bronca"
	desc = "A bottle of pure Fernet Bronca."
	icon_state = "fernetbottle"
	center_of_mass = list("x"=16, "y"=4)
	preloaded_reagents = list("fernet" = 100)

/obj/item/reagent_containers/drinks/bottle/neulandschnapps
	name = "Neuland Himbeergeist"
	desc = "A kriosan-approved spirits covered in Kriosan text, wax stamp on the bottle with the crest of a obscure and minor Castellan Lord. Time to shout 'Prost!' Ja?"
	icon_state = "neulandschnapps"
	icon_state_empty = "neulandschnapps"
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("schnapps" = 100)

/obj/item/reagent_containers/drinks/bottle/cider
	name = "Antimony Cider"
	desc = "A bottle of low strangth Sir Linden apple cider, has engravings and Kriosan scrips on the lable with a crest on the quark."
	icon_state = "ciderbottle"
	center_of_mass = list("x"=16, "y"=4)
	preloaded_reagents = list("cider" = 100)

//////////////////////////JUICES AND STUFF ///////////////////////

/obj/item/reagent_containers/drinks/bottle/orangejuice
	name = "Orange Juice"
	desc = "Full of vitamins."
	icon_state = "orangejuice"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=7)
	isGlass = 0
	preloaded_reagents = list("orangejuice" = 100)

/obj/item/reagent_containers/drinks/bottle/cream
	name = "Milk Cream"
	desc = "Cream made from milk."
	icon_state = "cream"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=8)
	isGlass = 0
	preloaded_reagents = list("cream" = 100)

/obj/item/reagent_containers/drinks/bottle/tomatojuice
	name = "Tomato Juice"
	desc = "A carton of tomato juice."
	icon_state = "tomatojuice"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=8)
	isGlass = 0
	preloaded_reagents = list("tomatojuice" = 100)

/obj/item/reagent_containers/drinks/bottle/limejuice
	name = "Lime Juice"
	desc = "A carton of lime juice."
	icon_state = "limejuice"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=8)
	isGlass = 0
	preloaded_reagents = list("limejuice" = 100)

/obj/item/reagent_containers/drinks/bottle/pineapplejuice
	name = "Pineapple Juice"
	desc = "A carton of pineapple juice."
	icon_state = "pineapplejuice"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=7)
	isGlass = 0
	preloaded_reagents = list("pineapplejuice" = 100)

/obj/item/reagent_containers/drinks/bottle/applejuice
	name = "Apple Juice"
	desc = "A carton of Sir Linden apple juice, has fancy engraving on the cardboard and a crest on the cap."
	icon_state = "applejuice"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=7)
	isGlass = 0
	preloaded_reagents = list("applejuice" = 100)

//Small bottles
/obj/item/reagent_containers/drinks/bottle/small
	volume = 50
	smash_duration = 1
	flags = 0 //starts closed
	rag_underlay = "rag_small"

/obj/item/reagent_containers/drinks/bottle/small/beer
	name = "space beer"
	desc = "Contains only water, malt and hops."
	icon_state = "beer"
	center_of_mass = list("x"=16, "y"=12)
	preloaded_reagents = list("beer" = 30)

/obj/item/reagent_containers/drinks/bottle/small/beer_two
	name = "Mickey Finn's Special Brew"
	desc = "A bottle of what looks like a beer but is a mix of sleeping agents, malt and hops."
	icon_state = "beer"
	center_of_mass = list("x"=16, "y"=12)
	preloaded_reagents = list("beer2" = 30)

/obj/item/reagent_containers/drinks/bottle/small/ale
	name = "\improper Magm-Ale"
	desc = "A small bottle of ale."
	icon_state = "alebottle"
	item_state = "beer"
	center_of_mass = list("x"=16, "y"=10)
	preloaded_reagents = list("ale" = 30)

/obj/item/reagent_containers/drinks/bottle/small/kvass
	name = "Magpie Kvass"
	desc = "A traditional drink of kvass."
	icon_state = "Kvass_Bottle"
	isGlass = 0
	center_of_mass = list("x"=16, "y"=12)
	preloaded_reagents = list("Kvass" = 30)

/obj/item/reagent_containers/drinks/bottle/small/applejuice
	name = "\improper Sir Linden Apple Juice"
	desc = "A small carton of apple juice with a bendy straw on the side, made to look fancy with small engravings on the cardboard and a crest on the cap."
	icon_state = "applejuice_cart"
	isGlass = 0
	center_of_mass = list("x"=16, "y"=12)
	preloaded_reagents = list("applejuice" = 30)

//glassess bottle
/obj/item/reagent_containers/drinks/bottle/small/brewing_bottle
	name = "Flash Bottle"
	desc = "A quickly printed bottle using a non-recycleable glass."
	icon_state = "brew_bottle"
	matter = null
	isGlass = FALSE
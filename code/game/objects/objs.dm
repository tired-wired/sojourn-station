/obj
	//Used to store information about the contents of the object.
	var/list/matter
	var/list/matter_reagents
	var/w_class // Size of the object.
	var/unacidable = 0 //universal "unacidabliness" var, here so you can use it in any obj.
	animate_movement = 2
	var/throwforce = 1
	var/sharp = 0		// whether this object cuts
	var/edge = 0		// whether this object is more likely to dismember
	var/in_use = 0 // If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!
	var/damtype = BRUTE
	var/armor_divisor = 1
	var/corporation = null
	var/heat = 0
	//soj edit
	var/clickdelay_offset = 0
	var/food_quality = 1 //Added here do to some food calling for items that are not snack types

/obj/proc/is_hot()
	return heat

/obj/get_fall_damage()
	return w_class * 2

/obj/examine(mob/user, distance=-1, infix, suffix)
	..(user, distance, infix, suffix)
	return distance == -1 || (get_dist(src, user) <= distance)


/obj/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/Topic(href, href_list, var/datum/nano_topic_state/state = GLOB.default_state)
	if(..())
		return 1

	// In the far future no checks are made in an overriding Topic() beyond if(..()) return
	// Instead any such checks are made in CanUseTopic()
	if(CanUseTopic(usr, state, href_list) == STATUS_INTERACTIVE)
		CouldUseTopic(usr)
		return OnTopic(usr, href_list, state)

	CouldNotUseTopic(usr)
	return 1

/obj/proc/OnTopic(mob/user, href_list, datum/nano_topic_state/state)
	return TOPIC_NOACTION

/obj/CanUseTopic(mob/user, datum/nano_topic_state/state)
	if(user.CanUseObjTopic(src))
		return ..()
	return STATUS_CLOSE

/mob/living/silicon/CanUseObjTopic(var/obj/O)
	var/id = src.GetIdCard()
	return O.check_access(id)

/mob/proc/CanUseObjTopic()
	return 1

/obj/proc/CouldUseTopic(var/mob/user)
	user.AddTopicPrint(src)

/mob/proc/AddTopicPrint(var/obj/target)
	target.add_hiddenprint(src)

/mob/living/AddTopicPrint(var/obj/target)
	if(Adjacent(target))
		target.add_fingerprint(src)
	else
		target.add_hiddenprint(src)

/mob/living/silicon/ai/AddTopicPrint(var/obj/target)
	target.add_hiddenprint(src)

/obj/proc/CouldNotUseTopic(var/mob/user)
	// Nada

/obj/item/proc/is_used_on(obj/O, mob/user)

/obj/Process()
	STOP_PROCESSING(SSobj, src)
	return 0

/obj/assume_air(datum/gas_mixture/giver)
	if(loc)
		return loc.assume_air(giver)
	else
		return null

/obj/remove_air(amount)
	if(loc)
		return loc.remove_air(amount)
	else
		return null

/obj/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

/obj/proc/updateUsrDialog()
	if(in_use)
		var/is_in_use = 0
		var/list/nearby = viewers(1, src)
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				is_in_use = 1
				src.attack_hand(M)
		if (isAI(usr) || isrobot(usr))
			if (!(usr in nearby))
				if (usr.client && usr.machine==src) // && M.machine == src is omitted because if we triggered this by using the dialog, it doesn't matter if our machine changed in between triggering it and this - the dialog is probably still supposed to refresh.
					is_in_use = 1
					src.attack_ai(usr)

		// check for TK users

		if (ishuman(usr))
			if(istype(usr.l_hand, /obj/item/tk_grab) || istype(usr.r_hand, /obj/item/tk_grab/))
				if(!(usr in nearby))
					if(usr.client && usr.machine==src)
						is_in_use = 1
						src.attack_hand(usr)
		in_use = is_in_use

/obj/proc/updateDialog()
	// Check that people are actually using the machine. If not, don't update anymore.
	if(in_use)
		var/list/nearby = viewers(1, src)
		var/is_in_use = 0
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				is_in_use = 1
				src.interact(M)
		var/ai_in_use = AutoUpdateAI(src)

		if(!ai_in_use && !is_in_use)
			in_use = 0

/obj/attack_ghost(mob/user)
	ui_interact(user)
	nano_ui_interact(user)
	..()

/mob/proc/unset_machine()
	src.machine = null

/mob/proc/set_machine(var/O)
	if(src.machine)
		unset_machine()
	src.machine = O
	if(istype(O, /obj) || istype(O, /mob))
		O:in_use = 1 // At this point, O is either a mob or an object, both of which have the in_use var, so it should be safe to do this. -R4d6

/obj/item/proc/updateSelfDialog()
	var/mob/M = src.loc
	if(istype(M) && M.client && M.machine == src)
		src.attack_self(M)

/obj/proc/hide(var/hide)
	invisibility = hide ? INVISIBILITY_MAXIMUM : initial(invisibility)

/obj/proc/hides_under_flooring()
	return level == BELOW_PLATING_LEVEL

/obj/proc/hear_talk(mob/M as mob, text, verb, datum/language/speaking, speech_volume)
	if(talking_atom)
		talking_atom.catchMessage(text, M)
/*
	var/mob/mo = locate(/mob) in src
	if(mo)
		var/rendered = "<span class='game say'><span class='name'>[M.name]: </span> <span class='message'>[text]</span></span>"
		mo.show_message(rendered, 2)
		*/
	return

/obj/proc/see_emote(mob/M as mob, text, var/emote_type)
	return

/obj/proc/show_message(msg, type, alt, alt_type)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)
	return

/obj/proc/add_hearing()
	GLOB.hearing_objects |= src

/obj/proc/remove_hearing()
	GLOB.hearing_objects.Remove(src)

/obj/proc/eject_item(var/obj/item/I, var/mob/living/M)
	if(!I || !M.IsAdvancedToolUser())
		return FALSE
	M.put_in_hands(I)
	playsound(src.loc, 'sound/weapons/guns/interact/pistol_magin.ogg', 75, 1)
	M.visible_message(
		"[M] remove [I] from [src].",
		SPAN_NOTICE("You remove [I] from [src].")
	)
	return TRUE

/obj/proc/replace_item(obj/item/I_old, obj/item/I_new, mob/living/user)
	if(!I_old || !I_new || !istype(user) || user.stat || !user.Adjacent(I_new) || !user.Adjacent(I_old) || !user.unEquip(I_new))
		return FALSE
	I_new.forceMove(src)
	user.put_in_hands(I_old)
	playsound(src.loc, 'sound/weapons/guns/interact/pistol_magout.ogg', 75, 1)
	spawn(2)
		playsound(src.loc, 'sound/weapons/guns/interact/pistol_magin.ogg', 75, 1)
	user.visible_message(
		"[user] replaces [I_old] with [I_new] in [src].",
		SPAN_NOTICE("You replace [I_old] with [I_new] in [src]."))
	return TRUE

/obj/proc/insert_item(var/obj/item/I, var/mob/living/M)
	if(!I || !M.unEquip(I))
		return FALSE
	I.forceMove(src)
	playsound(src.loc, 'sound/weapons/guns/interact/pistol_magout.ogg', 75, 1)
	to_chat(M, SPAN_NOTICE("You insert [I] into [src]."))
	return TRUE


//Returns the list of matter in this object
//You can override it to customise exactly what is returned.
/obj/proc/get_matter()
	return matter ? matter : list()

//Drops the materials in matter list on into target location
//Use for deconstrction
// Dropper is whoever is handling these materials if any , causes them to leave fingerprints on the sheets.
/obj/proc/drop_materials(target_loc, mob/living/dropper)
	var/list/materials = get_matter()

	for(var/mat_name in materials)
		var/material/material = get_material_by_name(mat_name)
		if(!material)
			continue

		material.place_material(target_loc, materials[mat_name], dropper)

//To be called from things that spill objects on the floor.
//Makes an object move around randomly for a couple of tiles
/obj/proc/tumble(var/dist = 2)
	set waitfor = FALSE
	if (dist >= 1)
		dist += rand(0,1)
		for(var/i = 1, i <= dist, i++)
			if(src)
				step(src, pick(NORTH,SOUTH,EAST,WEST))
				sleep(rand(2,4))


//Intended for gun projectiles, but defined at this level for various things that aren't of projectile type
/obj/proc/multiply_projectile_damage(newmult)
	throwforce = initial(throwforce) * newmult

//Same for AP
/obj/proc/add_projectile_penetration(newmult)
	armor_divisor = initial(armor_divisor) + newmult

/obj/proc/wound_mult_adder(newmult)

/obj/proc/multiply_pierce_penetration(newmult)

/obj/proc/multiply_projectile_step_delay(newmult)

/obj/proc/multiply_projectile_agony(newmult)

/obj/proc/add_fire_stacks(newmult)

//Proj for thrown items
/obj/proc/post_thrown_hit(mob)
	return
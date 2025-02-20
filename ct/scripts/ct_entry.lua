

function onInit()
	super.onInit();
	onLinkChanged(); -- call the overload.
end

function onLinkChanged()
	-- If a cohort NPC, then set up the links
	local sClass, sRecord = link.getValue();
	if FriendZone.isCohort(sRecord) then
		if sClass == "npc" then
			linkNPCFields();
		end
		name.setLine(false);
	end

	super.onLinkChanged();
end

function link4ENPCFields()
	local nodeChar = link.getTargetDatabaseNode();
	if nodeChar then
		name.setLink(nodeChar.createChild("name", "string"), true);
		senses.setLink(nodeChar.createChild("senses", "string"), true);

		-- NOTE: Not being familiar with 4E play, you might have to adjust these
		--		 slightly.   I tested and it seems to work, but some of the linked
		--		 items might be unnecessary.
		
		-- I don't think you can link main HP to the NPC sheet since it's not a numeric field.
		-- This line throws an error when you drag and drop an NPC onto the CT.
		-- hptotal.setLink(nodeChar.createChild("hp", "number"));

		-- NOTE: hptemp and wounds don't exist on the NPC sheet, but they will get 
		--		created there and linked to the cT values.   If you delete the NPC 
		--		from the CT and then re-add it later, the NPC will still have the prior values.  
		--		Might be helpful, but these 2 lines could be deleted if desired.
		hptemp.setLink(nodeChar.createChild("hptemp", "number"));
		wounds.setLink(nodeChar.createChild("wounds", "number"));
		
		alignment.setLink(nodeChar.createChild("alignment", "string"));
		type.addSource(DB.getPath(nodeChar, "type"));
		
		init.setLink(nodeChar.createChild("init", "number"), true);
		ac.setLink(nodeChar.createChild("ac", "number"), true);
		speed.setLink(nodeChar.createChild("speed", "string"), true);
	end
end

function linkPFRPGNPCFields()
	local nodeChar = link.getTargetDatabaseNode();
	if nodeChar then
		name.setLink(nodeChar.createChild("name", "string"), true);
		senses.setLink(nodeChar.createChild("senses", "string"), true);

		hp.setLink(nodeChar.createChild("hp", "number"));
		
		-- These don't exist on an NPC sheet.  Should they be added?
		
		-- hptemp.setLink(nodeChar.createChild("hp.temporary", "number"));
		-- nonlethal.setLink(nodeChar.createChild("hp.nonlethal", "number"));
		-- wounds.setLink(nodeChar.createChild("hp.wounds", "number"));

		if DataCommon.isPFRPG() then
			type.addSource(DB.getPath(nodeChar, "alignment"), true);
		else
			alignment.setLink(nodeChar.createChild("alignment", "string"));
		end
		type.addSource(DB.getPath(nodeChar, "type"));
				
		fortitudesave.setLink(nodeChar.createChild("fortitudesave", "number"), true);
		reflexsave.setLink(nodeChar.createChild("reflexsave", "number"), true);
		willsave.setLink(nodeChar.createChild("willsave", "number"), true);
		
		init.setLink(nodeChar.createChild("init", "number"), true);
	end
end

function linkPFRPG2NPCFields()
	local nodeChar = link.getTargetDatabaseNode();
	if nodeChar then
		name.setLink(nodeChar.createChild("name", "string"), true);		
		init.setLink(nodeChar.createChild("init", "number"), true);		
		senses.setLink(nodeChar.createChild("senses", "string"), true);
		hp.setLink(nodeChar.createChild("hp", "number"));

		-- These don't exist on a normal NPC sheet, but we will save them
		hptemp.setLink(nodeChar.createChild("hp_temp", "number"));
		current.setLink(nodeChar.createChild("hp_current", "number"));
		wounds.setLink(nodeChar.createChild("hp_wounds", "number"));		

		ac_final.setLink(nodeChar.createChild("ac", "number"), true);		
		fortitudesave.setLink(nodeChar.createChild("fortitudesave", "number"), true);
		reflexsave.setLink(nodeChar.createChild("reflexsave", "number"), true);
		willsave.setLink(nodeChar.createChild("willsave", "number"), true);
	end
end

function link2ENPCFields()
	-- See linkNPCFields() in cta/scripts/cta_entry.lua for the 2E handling
	print("2E NPC linking not handled here!   We should not be here.");
end

function linkOSE2NPCFields()
	local nodeChar = link.getTargetDatabaseNode();
	if nodeChar then
		name.setLink(nodeChar.createChild("name", "string"), true);
		initresult.setLink(nodeChar.createChild("initresult", "number"), false);
		senses.setLink(nodeChar.createChild("senses", "string"), true);
		armor_class.setLink(nodeChar.createChild("ac_current", "number"), true);
		thaco.setLink(nodeChar.createChild("thaco", "number"), true);
		dsave_score.setLink(nodeChar.createChild("dsave_score", "number"), true);	
		wsave_score.setLink(nodeChar.createChild("wsave_score", "number"), true);
		psave_score.setLink(nodeChar.createChild("psave_score", "number"), true);	
		bsave_score.setLink(nodeChar.createChild("bsave_score", "number"), true);		
		ssave_score.setLink(nodeChar.createChild("ssave_score", "number"), true);
		poison.setLink(nodeChar.createChild("poison", "number"), true);
		hp_current.setLink(nodeChar.createChild("hp_current", "number"), false);	
		wounds.setLink(nodeChar.createChild("wounds", "number"), false);	
		temp_hp.setLink(nodeChar.createChild("temp_hp", "number"), false);	
		maxhp_combat.setLink(nodeChar.createChild("maxhp_combat", "number"), false);
		Level_current.setLink(nodeChar.createChild("Level_new", "number"), false);								
	end	
end

function linkNPCFields()
	if User.getRulesetName() == "4E" then
		link4ENPCFields();
	elseif User.getRulesetName() == "2E" then
		link2ENPCFields();
	elseif User.getRulesetName() == "OSE2" then
		linkOSE2NPCFields();
	elseif User.getRulesetName() == "PFRPG2" then
		linkPFRPG2NPCFields();
	else
		linkPFRPGNPCFields();
	end
end
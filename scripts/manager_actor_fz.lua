-- 
-- Please see the license.txt file included with this distribution for 
-- attribution and copyright information.
--

local getActorRecordTypeFromPathOriginal;
local getTypeAndNodeOriginal;
local getSaveOriginal;
local getDefenseValueOriginal;

function onInit()
	getActorRecordTypeFromPathOriginal = ActorManager.getActorRecordTypeFromPath;
	ActorManager.getActorRecordTypeFromPath = getActorRecordTypeFromPath;

	getTypeAndNodeOriginal = ActorManager.getTypeAndNode;
	ActorManager.getTypeAndNode = getTypeAndNode;

	getSaveOriginal = ActorManager5E.getSave;
	ActorManager5E.getSave = getSave;

	getDefenseValueOriginal = ActorManager5E.getDefenseValue;
	ActorManager5E.getDefenseValue = getDefenseValue;
end

function getActorRecordTypeFromPath(sActorNodePath)
	local result = getActorRecordTypeFromPathOriginal(sActorNodePath);
	if result == "charsheet" then
		if sActorNodePath:match("%.cohorts%.") then
			result = "npc";
		elseif sActorNodePath:match("%.units%.") then
			result = "unit";
		end
	end
	return result;
end

function getTypeAndNode(v)
	local rActor = ActorManager.resolveActor(v);
	if not rActor then 
		return nil, nil; 
	end

	if not ActorManager.isPC(rActor) and FriendZone.isCohort(rActor) then
		local nodeCreature = ActorManager.getCreatureNode(rActor);
		if nodeCreature and nodeCreature.isOwner() then 
			return "npc", nodeCreature;
		end
	end

	return getTypeAndNodeOriginal(rActor);
end


function getSave(rActor, sSave)
	local sNodeType, nodeActor = ActorManager.getTypeAndNode(rActor);
	if not nodeActor then
		return 0, false, false, "";
	end

	local nMod, bADV, bDIS, sAddText = getSaveOriginal(rActor, sSave);
	if sNodeType ~= "pc" and FriendZone.isCohort(rActor) then
		local sSaves = DB.getValue(nodeActor, "savingthrows", "");
		if sSaves:lower():match(sSave:sub(1,3):lower() .. "[^,]+%+ ?pb") then
			local nodeCommander = FriendZone.getCommanderNode(rActor);
			local nProfBonus = DB.getValue(nodeCommander, "profbonus", 0);
			nMod = nMod + nProfBonus;
		end
	end

	return nMod, bADV, bDIS, sAddText;
end

function getDefenseValue(rAttacker, rDefender, rRoll)
	local nDefenseVal, nAtkEffectsBonus, nDefEffectsBonus, bADV, bDIS = getDefenseValueOriginal(rAttacker, rDefender, rRoll);

	if FriendZone.isCohort(rDefender) then
		local sAcText = DB.getValue(ActorManager.getCreatureNode(rDefender), "actext", "");
		if sAcText:gmatch("+ ?PB") then
			local nodeCommander = FriendZone.getCommanderNode(rDefender);
			local nProfBonus = DB.getValue(nodeCommander, "profbonus", 0);
			if nProfbonus == 0 then
				local sCR = DB.getValue(nodeCommander, "cr");
				if StringManager.isNumber(sCR) then
					nProfBonus = math.max(2, math.floor((tonumber(sCR) - 1) / 4) + 2);
				end
			end
			nDefenseVal = nDefenseVal + nProfBonus;
		end
	end

	return nDefenseVal, nAtkEffectsBonus, nDefEffectsBonus, bADV, bDIS;
end
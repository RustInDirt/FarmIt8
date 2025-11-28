--[[
## Title: FarmIt
## Notes: Custom loot tracker. By CHiLLZ [v0.6]
## SavedVariablesPerCharacter: FI_Config
##
## Author: CHiLLZ <chillz@xmission.com>
## License: Copyright 2006-2007, Chillz Media. All rights reserved.
]]--

-- SETTINGS --
local FI_Title = "FarmIt"
local FI_Version = "v0.6";
local FI_Debug = false;

local FI_Defaults = {
	["Options"] = {
		["FI_Slot1"] = false,
		["FI_Slot2"] = false,
		["FI_Slot3"] = false,
		["FI_Slot4"]=false,
["FI_Slot5"]=false,
["FI_Slot6"]=false,
["FI_Slot7"]=false,
["FI_Slot8"]=false,
	},
}

-- FUNCTIONS --
function FI_OnLoad()
	FI_Mod:RegisterForDrag("LeftButton");
	FI:RegisterEvent("VARIABLES_LOADED");
	
	FI:RegisterEvent("UNIT_INVENTORY_CHANGED");
	FI:RegisterEvent("BAG_UPDATE");
end

function FI_OnShow()
	
end

function FI_OnEvent()
	if (event == "VARIABLES_LOADED") then
		FI_Settings();
	end
	
	if (event=="UNIT_INVENTORY_CHANGED" or event=="BAG_UPDATE") then
		FI_UpdateCount();
	end
end

function FI_Settings()
	if (not FI_Config) then
		FI_Config = FI_Defaults;
		DEFAULT_CHAT_FRAME:AddMessage( "FarmIt "..FI_Version.." initialized!  By CHiLLZ" );
	else
		for s = 1,8 do
			FI_SetSlot("FI_Slot"..s);
		end
		DEFAULT_CHAT_FRAME:AddMessage( "FarmIt "..FI_Version.." loaded.  By CHiLLZ" );
	end
end

function FI_Click(slot, button)
    if CursorHasItem() then
        local itemLink=nil
        for b=0,4 do
            local n=GetContainerNumSlots(b)
            if n then
                for s=1,n do
                    local tex,cnt,locked=GetContainerItemInfo(b,s)
                    if locked then
                        local link=GetContainerItemLink(b,s)
                        if link then itemLink=link end
                    end
                end
            end
        end
        ClearCursor()
        if itemLink then
            local _,_,id=string.find(itemLink,"item:(%d+)")
            if id then
                FI_Config["Options"][slot]=tonumber(id)
                FI_SetSlot(slot)
            end
        end
    elseif button=="RightButton" then
        FI_ClearSlot(slot)
    end
end

function FI_SetSlot( slot )
	local itemID = FI_Config["Options"][slot];
	
	if (itemID) then
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(itemID);
		local itemCount = FI_Count(itemID);
		
		getglobal(slot.."_Icon"):SetTexture(itemTexture);
		getglobal(slot.."_Count"):SetText(itemCount);
		getglobal(slot.."_Item"):SetText(itemName);
		
		if (FI_Debug) then 
			DEFAULT_CHAT_FRAME:AddMessage( "Farmit:  "..slot.." set to "..itemLink );
		end
	end
end

function FI_ClearSlot( slot )
	FI_Config["Options"][slot] = false;
	getglobal(slot.."_Icon"):SetTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot");
	getglobal(slot.."_Count"):SetText("0");
	getglobal(slot.."_Item"):SetText("");
end

function FI_Reset()
	PlaySound("igCharacterInfoClose");
	FI:ClearAllPoints();
	FI:SetPoint("LEFT", "UIParent", "LEFT", 0, 0);
	
	for s = 1,8 do
		FI_ClearSlot("FI_Slot"..s);
	end
	
	DEFAULT_CHAT_FRAME:AddMessage( "FarmIt: Mod has been reset." );
end

function FI_Count( itemID )
	local itemTotal = 0;
	local searchString = "item:"..itemID..":";
	
	for bag = 0,4 do
		local slots = GetContainerNumSlots(bag);
		if (slots) then
			for slot = 1,slots do
				local itemLink = GetContainerItemLink(bag, slot);
				if (itemLink) then
					if ( string.find(itemLink, searchString) ) then
						local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bag,slot);
						itemTotal = itemTotal + itemCount;
						
						if (FI_Debug) then 
							DEFAULT_CHAT_FRAME:AddMessage("FarmIt: "..itemLink.." found at "..bag..","..slot);
						end
					end
				end
			end
		end
	end
	
	return itemTotal;
end

function FI_UpdateCount()
	for s = 1,8 do
		local slot = "FI_Slot"..s;
		local itemID = FI_Config["Options"][slot];
		
		if (itemID) then
			local itemCount = FI_Count(itemID);
			getglobal(slot.."_Count"):SetText(itemCount);
		end
	end
end

function FI_Stacks( limit, amount )
	local num,stacks;
	
	if (amount > limit) then
		num = amount / limit;
		stacks = format("%.1f", num);
	else
		stacks = 1;
	end
	
	return stacks;
end

-- FARMING STATS FUNCTIONS --
function FI_Track( itemID )



end

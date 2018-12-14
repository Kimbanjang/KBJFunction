--------------------------------------------------------------------------------------------------------
-- 이동속도 표시 by 아로s
-- http://www.inven.co.kr/board/powerbbs.php?come_idx=17&l=30068
--------------------------------------------------------------------------------------------------------
PAPERDOLL_STATCATEGORIES[1].stats[7] = { stat = "MOVESPEED" };
hooksecurefunc("PaperDollFrame_SetMovementSpeed", function(statFrame, unit)
	statFrame:Show()
end)

hooksecurefunc("MovementSpeed_OnEnter", function(statFrame, unit)
    statFrame.UpdateTooltip = nil
end)

--------------------------------------------------------------------------------------------------------
-- FixOrderHallMap 1.0.3 by Ketho
-- https://mods.curse.com/addons/wow/265656-fixorderhallmap
--------------------------------------------------------------------------------------------------------
local kbjFuncFindNeedFixMap = {
	[23] = function() return select(4, GetMapInfo()) and 1007 end, -- Paladin, Sanctum of Light; Eastern Plaguelands
	[1040] = function() return 1007 end, -- Priest, Netherlight Temple; Azeroth
	[1044] = function() return 1007 end, -- Monk, Temple of Five Dawns; none
	[1048] = function() return 1007 end, -- Druid, Emerald Dreamway; none
	[1052] = function() return GetCurrentMapDungeonLevel() > 1 and 1007 end, -- Demon Hunter, Fel Hammer; Mardum
	[1088] = function() return GetCurrentMapDungeonLevel() == 3 and 1033 end, -- Nighthold -> Suramar
}

local kbjFuncfixMap = WorldMapZoomOutButton_OnClick
function WorldMapZoomOutButton_OnClick()
	local id = kbjFuncFindNeedFixMap[GetCurrentMapAreaID()]
	local out = id and id()
	if out then
		SetMapByID(out)
	else
		kbjFuncfixMap()
	end
end

--------------------------------------------------------------------------------------------------------
-- 2_Dealer 212.261 by 신_선 (modify : Kimbanjang)
-- http://wow.inven.co.kr/dataninfo/addonpds/detail.php?idx=7410
--------------------------------------------------------------------------------------------------------
-- config
local gg = false	-- 길드 수리비 사용 한다( true ), 안한다( false )
-- /config

local kbjFuncDealer = CreateFrame('Frame', nil, MerchantFrame)
local kbjFuncDealer_onEvent = function(self, event)
	if (event == 'MERCHANT_SHOW') then
		for bag = 0, 4 do	-- 잡템 판매
			for slot = 0, GetContainerNumSlots(bag) do
				local S = GetContainerItemLink(bag, slot)
				if S and string.find(S, "ff9d9d9d") then
					UseContainerItem(bag, slot)
				end
			end
		end

		if CanMerchantRepair() then	-- 자동 수리
			local co = GetRepairAllCost()
			if (not co or co == 0) then	return
			elseif gg and CanGuildBankRepair() then
				local _, _, gI = GetGuildInfo("player")
				self:RegisterEvent('UI_ERROR_MESSAGE')

				if	(gI~=0 and GetGuildBankWithdrawMoney()<co) or GetGuildBankMoney()==0
				or	(GetGuildBankMoney()<co and GetGuildBankMoney()>0) then
					RepairAllItems()
					print("|cFFFFCC00 수리비 : ", GetMoneyString(co).."  |c0000CC00(길드 수리비 부족)" )
				else
					RepairAllItems(1)
					print("|cFFFFCC00 수리비 |c0000CC00(길드) |cFFFFCC00: ", GetMoneyString(co))
				end
				self:UnregisterEvent('UI_ERROR_MESSAGE')
			elseif  GetMoney() < co then
				print("|cFFFFCC00 수리비 부족")
			else
				RepairAllItems()
				print("|cFFFFCC00 수리비 : ", GetMoneyString(co))
			end
		end
	end
end
kbjFuncDealer:SetScript('OnEvent', kbjFuncDealer_onEvent)
kbjFuncDealer:RegisterEvent('MERCHANT_SHOW')

--------------------------------------------------------------------------------------------------------
-- Uganda Bags 1.31 by 우간다짱 (modify : Kimbanjang)
-- http://wow.inven.co.kr/dataninfo/addonpds/detail.php?idx=5545
--------------------------------------------------------------------------------------------------------
local kbjFuncMoveBags = function()
	-- config
	local xOffset = -40
	local yOffset = 4
	-- /config

	local Bagframe
	local screenHeight = GetScreenHeight()
	local bagFrameHeight = screenHeight - yOffset
	local column = 0

	for index, frameName in ipairs(ContainerFrame1.bags) do
		Bagframe = getglobal(frameName)
		Bagframe:SetClampedToScreen(true)

			if ( index == 1 ) then
				Bagframe:SetPoint('BOTTOMRIGHT', Bagframe:GetParent(), 'BOTTOMRIGHT', xOffset, yOffset)
			elseif ( bagFrameHeight < Bagframe:GetHeight() ) then
				column = column + 1
				bagFrameHeight = screenHeight - yOffset
				Bagframe:SetPoint('BOTTOMRIGHT', Bagframe:GetParent(), 'BOTTOMRIGHT', -(column * CONTAINER_WIDTH) + xOffset, yOffset)
			else
				Bagframe:SetPoint('BOTTOMRIGHT', ContainerFrame1.bags[index-1], 'TOPRIGHT', 0, CONTAINER_SPACING)
			end

		bagFrameHeight = bagFrameHeight - Bagframe:GetHeight() - VISIBLE_CONTAINER_SPACING
	end
end
hooksecurefunc("UpdateContainerFrameAnchors", kbjFuncMoveBags)

--------------------------------------------------------------------------------------------------------
-- 데미지 폰트 변경
--------------------------------------------------------------------------------------------------------
DAMAGE_TEXT_FONT = "Fonts\\FRIZQT__.ttf"

--------------------------------------------------------------------------------------------------------
-- /console reloadui
--------------------------------------------------------------------------------------------------------
SlashCmdList.RELOAD = ReloadUI
SLASH_RELOAD1 = "/rl"
SLASH_RELOAD2 = "/기"

--------------------------------------------------------------------------------------------------------
-- /전투 준비
--------------------------------------------------------------------------------------------------------
SlashCmdList.RDYCHK = function() DoReadyCheck() end
SLASH_RDYCHK1 = "/ww"
SLASH_RDYCHK2 = "/ㅈㅈ"

--------------------------------------------------------------------------------------------------------
-- 생명석/물약 매크로 이미지 스왑 -- Ancient Healing Potion/Healthstone
--------------------------------------------------------------------------------------------------------
local kbjFuncHealPotMacroIcon = CreateFrame('Frame')
kbjFuncHealPotMacroIcon:SetScript('OnEvent', function(self, event, ...)
	SetMacroItem("!HP",GetItemCount("생명석") == 0 and "해안 치유 물약" or "생명석")
end)
kbjFuncHealPotMacroIcon:RegisterEvent('BAG_UPDATE')
kbjFuncHealPotMacroIcon:RegisterEvent('PLAYER_LOGIN')

--------------------------------------------------------------------------------------------------------
-- Move ZoneAbilityFrame
--------------------------------------------------------------------------------------------------------
ZoneAbilityFrame:SetParent(UIParent)
ZoneAbilityFrame:ClearAllPoints()
ZoneAbilityFrame:SetScale(0.9)
ZoneAbilityFrame:SetPoint("BOTTOM", 0, 200)
ZoneAbilityFrame.ignoreFramePositionManager = true

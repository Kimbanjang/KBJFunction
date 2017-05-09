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
	local xOffset = -7
	local yOffset = 45
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
-- SlashIn 1.0.6 by ZombiePope (modify : Kimbanjang)
-- http://www.wowinterface.com/downloads/info18054-SlashInin.html
-- /in [time] [Func] 타임 스케줄러
--------------------------------------------------------------------------------------------------------
local addonName, SlashIn = ...
LibStub("AceTimer-3.0"):Embed(SlashIn)

local print = print
local tonumber = tonumber
local MacroEditBox = MacroEditBox
local MacroEditBox_OnEvent = MacroEditBox:GetScript('OnEvent')

local function OnCallback(command)
	MacroEditBox_OnEvent(MacroEditBox, 'EXECUTE_CHAT_LINE', command)
end

SLASH_SLASHIN_IN1 = "/in"
SLASH_SLASHIN_IN2 = "/slashin"
function SlashCmdList.SLASHIN_IN(msg)
	local secs, command = msg:match("^([^%s]+)%s+(.*)$")
	secs = tonumber(secs)
	if (not secs) or (#command == 0) then
		local prefix = "|cff33ff99"..addonName.."|r:"
		print(prefix, "usage:\n /in <seconds> <command>")
		print(prefix, "example:\n /in 1.5 /say hi")
	else
		SlashIn:ScheduleTimer(OnCallback, secs, command)
	end
end

--------------------------------------------------------------------------------------------------------
-- MacroTalk 2.2.2 by Djidam (modify : Kimbanjang)
-- http://www.wowinterface.com/downloads/info6853-MacroTalk.html
-- /opt [blizz condition] [Func] 2중 슬래쉬 명령어
--------------------------------------------------------------------------------------------------------
local kbjFuncDoCommand = function(text)
	local command = text:match("^(/%S+)")
	
	if command and IsSecureCmd(command) then
		print("You cannot using : ", command)
		return
	end
	
	local origText = ChatFrame1EditBox:GetText()
	ChatFrame1EditBox:SetText(text)
	ChatEdit_SendText(ChatFrame1EditBox)
	ChatFrame1EditBox:SetText(origText)
end

SlashCmdList.OPTION_SLASH = function(message)
	message = SecureCmdOptionParse(message)
	if message then
		kbjFuncDoCommand(message)
	end
end
SLASH_OPTION_SLASH1 = "/opt"

--------------------------------------------------------------------------------------------------------
-- 데미지 폰트 변경
--------------------------------------------------------------------------------------------------------
DAMAGE_TEXT_FONT = "Interface\\AddOns\\KBJcombatUI\\Media\\fontStd.ttf"

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
kbjFuncHealPotMacroIcon:SetScript('OnEvent', function(self,event,...)
SetMacroItem("!HP",GetItemCount("생명석") == 0 and "고대 치유 물약" or "생명석")
end)
kbjFuncHealPotMacroIcon:RegisterEvent('BAG_UPDATE')
kbjFuncHealPotMacroIcon:RegisterEvent('PLAYER_LOGIN')

--------------------------------------------------------------------------------------------------------
-- 전장 지도 크기조정 및 테두리/버튼 숨기기
--------------------------------------------------------------------------------------------------------
local kbjFuncBattleMap = CreateFrame('Frame')
kbjFuncBattleMap:SetScript('OnEvent', function()
	if not BattlefieldMinimap then
		LoadAddOn('Blizzard_BattlefieldMinimap')
	end
	BattlefieldMinimap:SetScale(1.29)
	BattlefieldMinimapCorner:SetTexture(nil)
	BattlefieldMinimapBackground:SetTexture(nil)
	BattlefieldMinimapCloseButton:Hide()
	BattlefieldMinimap:Show()
end)
kbjFuncBattleMap:RegisterEvent('PLAYER_ENTERING_WORLD')

--[[----------------------------------------------------------------------------------------------------
-- 영클라, 한글 채팅 명령어
--------------------------------------------------------------------------------------------------------
SLASH_fixKRcommandGUILD1 = "/ㅎ"
function SlashCmdList.fixKRcommandGUILD(msg)
	SendChatMessage(msg, "GUILD")
end
SLASH_fixKRcommandINSTANCE1 = "/ㅑ"
function SlashCmdList.fixKRcommandINSTANCE(msg)
	SendChatMessage(msg, "INSTANCE_CHAT")
end
SLASH_fixKRcommandRAID1 = "/ㄱ"
function SlashCmdList.fixKRcommandRAID(msg)
	SendChatMessage(msg, "RAID")
end
SLASH_fixKRcommandPARTY1 = "/ㅔ"
function SlashCmdList.fixKRcommandPARTY(msg)
	SendChatMessage(msg, "PARTY")
end
SLASH_fixKRcommandSAY1 = "/ㄴ"
function SlashCmdList.fixKRcommandSAY(msg)
	SendChatMessage(msg, "SAY")
end
]]

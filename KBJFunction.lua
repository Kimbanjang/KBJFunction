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
kbjFuncHealPotMacroIcon:RegisterEvent('PLAYER_LOGIN')
kbjFuncHealPotMacroIcon:RegisterEvent('BAG_UPDATE')

--------------------------------------------------------------------------------------------------------
-- Move ZoneAbilityFrame
--------------------------------------------------------------------------------------------------------
ZoneAbilityFrame:SetParent(UIParent)
ZoneAbilityFrame:ClearAllPoints()
ZoneAbilityFrame:SetScale(0.9)
ZoneAbilityFrame:SetPoint("BOTTOM", 0, 200)
ZoneAbilityFrame.ignoreFramePositionManager = true

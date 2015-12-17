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
-- 핫키 택스트 간략화
--------------------------------------------------------------------------------------------------------
local function updatehotkey(self, actionButtonType)
	local hotkey = _G[self:GetName() .. 'HotKey']
        local text = hotkey:GetText()      
        text = string.gsub(text, 's%-', 's')
        text = string.gsub(text, 'a%-', 'a')
        text = string.gsub(text, 'c%-', 'c')
        text = string.gsub(text, 'Mouse Wheel Up', 'MU')
        text = string.gsub(text, 'Mouse Wheel Down', 'MD')
        text = string.gsub(text, 'Mouse Button 3', 'M3')
	text = string.gsub(text, 'Mouse Button 4', 'M4')
	text = string.gsub(text, 'Mouse Button 5', 'M5')
        text = string.gsub(text, 'Capslock', 'CL')
       
        if hotkey:GetText() == RANGE_INDICATOR then
		hotkey:SetText('')
        else
		hotkey:SetText(text)
        end
end 
hooksecurefunc("ActionButton_UpdateHotkeys", updatehotkey)

--------------------------------------------------------------------------------------------------------
-- 생명석/명인물약 매크로 이미지 스왑
--------------------------------------------------------------------------------------------------------
local healPotMacroIcon = CreateFrame("Frame")
healPotMacroIcon:SetScript("OnEvent",function(self,event,...)
SetMacroItem("HP",GetItemCount("Healthstone")==0 and "Healing Tonic" or "Healthstone")
end)

healPotMacroIcon:RegisterEvent("BAG_UPDATE")
healPotMacroIcon:RegisterEvent("PLAYER_LOGIN")

--------------------------------------------------------------------------------------------------------
-- 전장 지도 크기조정 및 테두리/버튼 숨기기
--------------------------------------------------------------------------------------------------------
local battleMap = CreateFrame("Frame")
battleMap:SetScript("OnEvent",function()
	if not BattlefieldMinimap then
		LoadAddOn("Blizzard_BattlefieldMinimap")
	end
	BattlefieldMinimap:SetScale(1.29)	
	BattlefieldMinimapCorner:SetTexture(nil)
	BattlefieldMinimapBackground:SetTexture(nil)
	BattlefieldMinimapCloseButton:Hide()
	BattlefieldMinimap:Show()
end)

battleMap:RegisterEvent("PLAYER_ENTERING_WORLD")

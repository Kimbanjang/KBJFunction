local function _CheckLongName(keyName)
    --keyName = string.gsub(keyName,"Mouse Button (%d)","M%1")
    --keyName = string.gsub(keyName,"Mouse Wheel Up","MU")
    --keyName = string.gsub(keyName,"Mouse Wheel Down","MD")
    --keyName = string.gsub(keyName,"Middle Mouse","Mm")
    keyName = string.gsub(keyName,"(%d)번 마우스 버튼","M%1")
    keyName = string.gsub(keyName,"마우스 휠 위로","MU")
    keyName = string.gsub(keyName,"마우스 휠 아래로","MD")
    keyName = string.gsub(keyName,"마우스 가운데 버튼","Mm")
    keyName = string.gsub(keyName,"Capslock","CL")
    keyName = string.gsub(keyName,"^s%-","s")
    keyName = string.gsub(keyName,"^a%-","a")
    keyName = string.gsub(keyName,"^c%-","c")
    keyName = string.gsub(keyName,"위 화살표","u");
    keyName = string.gsub(keyName,"아래 화살표","d");
    keyName = string.gsub(keyName,"오른쪽 화살표","r");
    keyName = string.gsub(keyName,"왼쪽 화살표","l");

    return keyName
end

function _UpdateHotkeys(name, type, hide)
    for i = 1, 12 do
        local f =  getglobal(name..i);
        if not f then break end;
        local hotkey = getglobal(f:GetName().."HotKey");
        local key = GetBindingKey(type..i) 
        local text = GetBindingText(key, "KEY_", 1);
        text = _CheckLongName(text);
        hotkey.isApply = 1;
        if ( text == "" ) then
            hotkey:Hide();
        else
            hotkey:SetText(text);
            hotkey:Show();
        end
        --getglobal(f:GetName().."Name"):Show();
    end
end

function onEvent(self, event, arg1)
  if event == "PLAYER_ENTERING_WORLD" or "UPDATE_BINDINGS" then
    _UpdateHotkeys("ActionButton", "ACTIONBUTTON", 1);
    _UpdateHotkeys("MultiBarBottomLeftButton", "MULTIACTIONBAR1BUTTON", 1);
    _UpdateHotkeys("MultiBarBottomRightButton", "MULTIACTIONBAR2BUTTON", 1);
    _UpdateHotkeys("MultiBarRightButton", "MULTIACTIONBAR3BUTTON", 1);
    _UpdateHotkeys("MultiBarLeftButton", "MULTIACTIONBAR4BUTTON", 1);
    _UpdateHotkeys("BonusActionButton", "ACTIONBUTTON", 1);
    _UpdateHotkeys("ExtraBarButton", "EXTRABARBUTTON", 1);
    _UpdateHotkeys("VehicleMenuBarActionButton", "ACTIONBUTTON", 1);
    return;
  end
end 

frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("UPDATE_BINDINGS")
frame:SetScript("OnEvent", onEvent)

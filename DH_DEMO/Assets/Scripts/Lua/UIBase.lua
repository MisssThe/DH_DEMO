-- UI基类，封装基本功能，后续UI继承此类并拓展
require("framework.SharedTools")
Global.UIBase = {}
Global.UIBase.status = {"OPEN","CLOSE","HIDE"}
Global.UIBase.status = CreateEnum(Global.UIBase.status)

----------------------------功能实现----------------------------
function Global.UIBase:New()
end

function Global.UIBase:GetID()
end

function Global.UIBase:Open()
end

function Global.UIBase:Resume()
end

function Global.UIBase:Hide()
end

function Global.UIBase:Close()
end

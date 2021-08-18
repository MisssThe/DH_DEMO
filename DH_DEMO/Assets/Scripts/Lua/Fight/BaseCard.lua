-- -- require("framework.SharedTools")
require("Assets/Scripts/Lua/EventSystem.lua")
require("Assets/Scripts/Lua/Fight/FightSystem.lua")

local BaseCard = {}
BaseCard.card_move = {}
BaseCard.card_move.old_pos = nil
BaseCard.card_move.move_speed = 0.6
BaseCard.card_move.parent = nil
BaseCard.card_move.index = nil
BaseCard.card_move.init_pos = nil
BaseCard.card_move.material = nil
BaseCard.card_move.percent = 0
BaseCard.card_move.flag = false
function Global.Awake()
    BaseCard.card_move.parent = cs_self.transform.parent
    BaseCard.card_move.material = cs_self.gameObject:GetComponent(typeof(UI.Image)).material
end
function Global.OnBeginDrag(data)
    -- 开始拖拽时将卡牌移出grid并记录位置和父物体
    BaseCard.card_move.old_pos = data.position
    BaseCard.card_move.index = cs_self.transform:GetSiblingIndex()
    BaseCard.card_move.init_pos = cs_self.transform.position
    cs_self.transform:SetParent(UE.GameObject.FindGameObjectsWithTag("Canvas")[0].transform)
end
function Global.OnDrag(data)
    local move = (data.position - BaseCard.card_move.old_pos) * BaseCard.card_move.move_speed
    cs_self.transform.position = cs_self.transform.position + UE.Vector3(0,move.y,0)
    BaseCard.card_move.old_pos = data.position
    BaseCard.card_move.percent = BaseCard.card_move.percent + move.y * 0.1
    if (BaseCard.card_move.percent > 20) then
        BaseCard.card_move.flag = true
    end
    BaseCard.card_move.material:SetFloat("_Percent",BaseCard.card_move.percent)
end

function Global.OnEndDrag(data)
    if (BaseCard.card_move.flag) and FightSystem.Round.is_self then
        -- 卡牌被使用销毁卡牌
        UE.Object.Destroy(cs_self.gameObject)
        BaseCard.card_move.flag = EventSystem.Send("SendCard",cs_self.name,true)
        
        if BaseCard.card_move.flag ~= true then
            OnEndDrag(nil)
        end
    else
        -- 停止拖动时卡牌归为
        cs_self.transform:SetParent(BaseCard.card_move.parent)
        cs_self.transform:SetSiblingIndex(BaseCard.card_move.index)
        BaseCard.card_move.material:SetFloat("_Percent",0)
        BaseCard.card_move.percent = 0
    end
end
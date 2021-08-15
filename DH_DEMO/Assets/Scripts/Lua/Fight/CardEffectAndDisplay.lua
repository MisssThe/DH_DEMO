-- 包含所有卡牌的效果
----------------------------攻击牌----------------------------
-- 普通攻击
local NormalAttack = {}

function NormalAttack:Effect()

end
function NormalAttack:Display()

end
EventSystem.Add("NormalAttackEffect",false,NormalAttack.Effect)
EventSystem.Add("NormalAttackDisplay",false,NormalAttack.Display)

-- 粉碎
local Smash = {}
function Smash:Effect()

end
function Smash:Display()
    
end

----------------------------咒术牌----------------------------





----------------------------Buff牌----------------------------
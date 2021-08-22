print("开始加载音频")
-- 播放特殊的声音
Global.EffectVoice = {}
EffectVoice.source = cs_self.gameObject:GetComponent(typeof(UE.AudioSource))
EffectVoice.source.loop = false
-- 播放战斗开始声音
EffectVoice.FightStartClip = AudioLoad:GetClip("FightStart")
function EffectVoice.PlayFightStart()
    if EffectVoice.source ~= nil then
        EffectVoice.source.clip = EffectVoice.FightStartClip
        EffectVoice.source:Play()
    end
end
EventSystem.Add("PlayFightStart",false,EffectVoice.PlayFightStart)
-- 播放战斗结束胜利声音
EffectVoice.FightEndSuccessClip = AudioLoad:GetClip("FightEndSuccess")
function EffectVoice.PlayFightEndSuccess()
    if EffectVoice.source ~= nil then
        EffectVoice.source.clip = EffectVoice.FightEndSuccessClip
        EffectVoice.source:Play()
    end
end
EventSystem.Add("PlayFightEndSuccess",false,EffectVoice.PlayFightEndSuccess)
-- 播放战斗结束失败声音
EffectVoice.FightEndFailedClip = AudioLoad:GetClip("FightEndFailed")
function EffectVoice.PlayFightEndFailed()
    if EffectVoice.source ~= nil then
        EffectVoice.source.clip = EffectVoice.FightEndFailedClip
        print("切换音乐")
        EffectVoice.source:Play()
    end
end
EventSystem.Add("PlayFightEndFailed",false,EffectVoice.PlayFightEndFailed)
-- 播放回合切换声音
EffectVoice.FightTurnRoundClip = AudioLoad:GetClip("FightTurnRound")
function EffectVoice.PlayFightTurnRound()
    if EffectVoice.source ~= nil then
        EffectVoice.source.clip = EffectVoice.FightTurnRoundClip
        EffectVoice.source:Play()
    end
end
EventSystem.Add("PlayFightTurnRound",false,EffectVoice.PlayFightTurnRound)

-- 播放出牌声音
EffectVoice.SendCardClip = AudioLoad:GetClip("SendCard")
function EffectVoice.PlaySendCard()
    if EffectVoice.source ~= nil then
        EffectVoice.source.clip = EffectVoice.SendCardClip
        EffectVoice.source:Play()
    end
end
EventSystem.Add("PlaySendCard",false,EffectVoice.PlaySendCard)

-- 播放购买失败音效
EffectVoice.BuyFailedClip = AudioLoad:GetClip("BuyFailed")
function EffectVoice.PlayBuyFailed()
    if EffectVoice.source ~= nil then
        EffectVoice.source.clip = EffectVoice.BuyFailedClip
        EffectVoice.source:Play()
    end
end
EventSystem.Add("PlayBuyFailed",false,EffectVoice.PlayBuyFailed)

-- 播放购买成功音效
EffectVoice.BuySuccessClip = AudioLoad:GetClip("BuySuccess")
function EffectVoice.PlaBuySuccess()
    if EffectVoice.source ~= nil then
        EffectVoice.source.clip = EffectVoice.BuySuccessClip
        EffectVoice.source:Play()
    end
end
EventSystem.Add("PlayBuySuccess",false,EffectVoice.PlayBuySuccess)

-- 播放攻击卡牌声音
EffectVoice.AttackCardClip = AudioLoad:GetClip("AttackCard")
function EffectVoice.PlayAttackCard()
    if EffectVoice.source ~= nil then
        EffectVoice.source.clip = EffectVoice.AttackCardClip
        EffectVoice.source:Play()
    end
end
EventSystem.Add("PlayAttackCard",false,EffectVoice.PlayAttackCard)
-- 播放辅助卡牌声音
EffectVoice.AssitCardClip = AudioLoad:GetClip("AssitCard")
function EffectVoice.PlayAssitCard()
    if EffectVoice.source ~= nil then
        EffectVoice.source.clip = EffectVoice.AssitCardClip
        EffectVoice.source:Play()
    end
end
EventSystem.Add("PlayAssitCard",false,EffectVoice.PlayAssitCard)
-- 播放咒术卡牌声音
EffectVoice.ConjurCardClip = AudioLoad:GetClip("ConjurCard")
function EffectVoice.PlayConjurCard()
    if EffectVoice.source ~= nil then
        EffectVoice.source.clip = EffectVoice.ConjurCardClip
        EffectVoice.source:Play()
    end
end
EventSystem.Add("PlayConjurCard",false,EffectVoice.PlayConjurCard)

print("音频更新完成")
print(EventSystem.IsExit())
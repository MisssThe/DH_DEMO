-- 播放特殊的声音
Global.EffectVoice = {}
EffectVoice.source = cs_self.gameObject:GetComponent(typeof(UE.AudioSource))
EffectVoice.source.loop = false
-- 播放战斗开始声音
EffectVoice.FightStartClip = AudioLoad.GetClip("FightStart")
function EffectVoice.PlayFightStart()
    if EffectVoice.source ~= nil then
        EffectVoice.source.clip = EffectVoice.FightStartClip
        EffectVoice.source.Play()
    end
end
EventSystem.Add("PlayFightStart",EffectVoice.PlayFightStart)
-- 播放战斗结束胜利声音
EffectVoice.FightEndSuccessClip = AudioLoad.GetClip("FightEndSuccess")
function EffectVoice.PlayFightEndSuccess()
    if EffectVoice.source ~= nil then
        EffectVoice.source.clip = EffectVoice.FightEndSuccessClip
        EffectVoice.source.Play()
    end
end
EventSystem.Add("PlayFightEndSuccess",EffectVoice.PlayFightEndSuccess)
-- 播放战斗结束失败声音
EffectVoice.FightEndFailedClip = AudioLoad.GetClip("FightEndFailed")
function EffectVoice.PlayFightEndFailed()
    if EffectVoice.source ~= nil then
        EffectVoice.source.clip = EffectVoice.FightEndFailedClip
        EffectVoice.source.Play()
    end
end
EventSystem.Add("PlayFightEndFailed",EffectVoice.PlayFightEndFailed)
-- 播放回合切换声音
EffectVoice.FightTurnRoundClip = AudioLoad.GetClip("FightTurnRound")
function EffectVoice.PlayFightTurnRound()
    if EffectVoice.source ~= nil then
        EffectVoice.source.clip = EffectVoice.FightTurnRoundClip
        EffectVoice.source.Play()
    end
end
EventSystem.Add("PlayFightTurnRound",EffectVoice.PlayFightTurnRound)

-- 播放出牌声音
EffectVoice.SendCardClip = AudioLoad.GetClip("SendCard")
function EffectVoice.PlaySendCard()
    if EffectVoice.source ~= nil then
        EffectVoice.source.clip = EffectVoice.SendCardClip
        EffectVoice.source.Play()
    end
end
EventSystem.Add("PlaySendCard",EffectVoice.PlaySendCard)
-- 播放卡牌特殊声音
EffectVoice.CardClip = AudioLoad.GetClip("CardClip")
function EffectVoice.PlayFightStart()
    if EffectVoice.source ~= nil then
        EffectVoice.source.clip = EffectVoice.FightStartClip
        EffectVoice.source.Play()
    end
end
EventSystem.Add("PlayFightStart",EffectVoice.PlayFightStart)
-- Lua 测试代码

testTextT = {}

function Awake()
    testTextT = testText:GetComponent(typeof(UE.UI.Text))
end

function Update()
    testTextT.color = UE.Color(
        UE.Mathf.Sin(UE.Time.time) / 2 + 0.5,
        UE.Mathf.Sin(UE.Time.time) / 2 + 0.4,
        0, 1)
end
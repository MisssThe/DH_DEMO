require("Assets/Scripts/Lua/UI/UIView.lua")
require("Assets/Scripts/Lua/EventSystem.lua")

----------------------------------逻辑层----------------------------------
Global.ChatModel = {}
ChatModel.flag = true
ChatModel.new_msg = ""
ChatModel.max_msg = 15
ChatModel.msg_index = 0
ChatModel.msg_num = 0
-- 初始化逻辑模块
function ChatModel.InitMsg()
    ChatModel.flag = true
    -- 可以用stringbuilder代替提高效率！！！！！！！！！！！！！！！！！！
    ChatModel.new_msg = ""
    ChatModel.msg_index = 0
    ChatModel.msg_num = 0
end
-- 发送信息
function ChatModel.SendMsg(msg,sender_name)
    if sender_name ~= nil and msg ~= nil and msg ~= "" then
        ChatModel.msg_num = ChatModel.msg_num + 1
        ChatModel.new_msg = ChatModel.new_msg .. sender_name .. ":" .. msg .. "\n"
        ChatModel.msg_index = ChatModel.msg_index + 1
        ChatModel.flag = true
        print("send msg success")
    end
end
EventSystem.Add("SendChatMsg",false,ChatModel.SendMsg)
-- 获取更新的信息
function ChatModel.GetNewMsg()
    local temp_str = ChatModel.new_msg
    ChatModel.new_msg = ""
    ChatModel.flag = false
    return temp_str
end
----------------------------------显示层----------------------------------
Global.chat_input_obj = nil
Global.chat_panel_obj = nil
Global.chat_scroll_obj = nil
Global.chat_button_obj = nil
Global.chat_talk1_obj = nil
Global.chat_talk2_obj = nil
local input_view = nil
local panel_view = nil
local scroll_view = nil
local button_view = nil
local talk1_view = nil
local talk2_view = nil
local chat_input_text = nil
local chat_scroll = nil
local chat_talk = {}
local chat_width = 450

local function EventFunc1()
    -- 发送消息
    -- 获取input下text并添加到model中
    if FightSystem.player_info.self_name ~= nil then
        local msg = chat_input_text.text
        -- ChatModel.SendMsg(msg,FightSystem.player_info.self_name)
        ChatModel.SendMsg(msg,FightSystem.player_info.self_name)
        chat_input_text.text = ""
        CS.NetWork.SendTalk(FightSystem.player_info.self_name,FightSystem.player_info.rivial_name,msg)
        -- CS.NetWork.SendTalk("Sean","222",msg)
    end
end

function Global.Awake()
    input_view  =UIView:New(chat_input_obj)
    scroll_view= UIView:New(chat_scroll_obj)
    panel_view = UIView:New(chat_panel_obj)
    button_view = UIView:New(chat_button_obj)
    talk1_view = UIView:New(chat_talk1_obj)
    talk2_view = UIView:New(chat_talk2_obj)
    -- 初始化逻辑层
    ChatModel.InitMsg()
    chat_talk[0] = chat_talk1_obj.gameObject:GetComponent(typeof(UI.Text))
    chat_talk[1] = chat_talk2_obj.gameObject:GetComponent(typeof(UI.Text))
    -- chat_display_text = chat_panel_obj.gameObject:GetComponent(typeof(UI.Text))
    chat_input_text = chat_input_obj.gameObject:GetComponent(typeof(UI.InputField))
    chat_button_obj.gameObject:GetComponent(typeof(UI.Button)).onClick:AddListener(EventFunc1)
    chat_scroll = chat_scroll_obj.gameObject:GetComponent(typeof(UI.Scrollbar))
end
local talk_flag = 0
local function CacuPos(x)
    x = x + 30
    if x > 450 then
        -- 换板子
        talk_flag = (talk_flag + 1) % 2
        chat_talk[talk_flag].text = ""
        x = -420
    end
    return x
end

function Global.Update()
    if ChatModel.flag == true then
        local msg = ChatModel.GetNewMsg()
        -- 更新聊天内容
        local local_pos = chat_talk1_obj.gameObject.transform.localPosition
        chat_talk1_obj.gameObject.transform.localPosition = UE.Vector3(local_pos.x,CacuPos(local_pos.y),local_pos.z)
        local_pos = chat_talk2_obj.gameObject.transform.localPosition
        chat_talk2_obj.gameObject.transform.localPosition = UE.Vector3(local_pos.x,CacuPos(local_pos.y),local_pos.z)
        chat_talk[talk_flag].text = chat_talk[talk_flag].text .. msg
        -- if ChatModel.msg_num < ChatModel.max_msg then
        --     chat_talk1.text = chat_talk1.text .. msg
        -- else
        --     chat_talk2.text = chat_talk2.text .. msg
        --     chat_talk1_obj.gameObject.transform.localPosition = chat_talk1_obj.gameObject.transform.localPosition + UE.Vector3(0,30,0)
        --     chat_talk2_obj.gameObject.transform.localPosition = chat_talk2_obj.gameObject.transform.localPosition + UE.Vector3(0,30,0)     
        -- end
        -- 根据聊天内容改变滑块大小
        local size = 1 / ChatModel.msg_num
        chat_scroll.size = size
        print("size" .. size)
        -- 滑动滑块改变内容
    end
end
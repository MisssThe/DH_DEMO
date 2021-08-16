require("Assets/Scripts/Lua/UI/UIView.lua")
require("Assets/Scripts/Lua/EventSystem.lua")

----------------------------------逻辑层----------------------------------
Global.ChatModel = {}
ChatModel.flag = true
ChatModel.new_msg = ""
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
    ChatModel.msg_num = ChatModel.msg_num + 1
    ChatModel.new_msg = ChatModel.new_msg .. msg .. "\n"
    ChatModel.msg_index = ChatModel.msg_index + 1
    ChatModel.flag = true
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
local input_view = nil
local panel_view = nil
local scroll_view = nil
local button_view = nil
local chat_display_text = nil
local chat_input_text = nil

local function EventFunc1()
    -- 发送消息
    -- 获取input下text并添加到model中
    local msg = chat_input_text.text
    ChatModel.SendMsg(msg,FightSystem.player_info.self_name)
    chat_input_text.text = ""
    -- CS.NetWork.SendTalk(FightSystem.player_info.self_name,FightSystem.player_info.rivial_name,msg)
        CS.NetWork.SendTalk("111","222",msg)
end

function Global.Awake()
    input_view  =UIView:New(chat_input_obj)
    scroll_view= UIView:New(chat_scroll_obj)
    panel_view = UIView:New(chat_panel_obj)
    button_view = UIView:New(chat_button_obj)
    -- 初始化逻辑层
    ChatModel.InitMsg()
    chat_display_text = chat_panel_obj.gameObject:GetComponent(typeof(UI.Text))
    chat_input_text = chat_input_obj.gameObject:GetComponent(typeof(UI.InputField))
    chat_button_obj.gameObject:GetComponent(typeof(UI.Button)).onClick:AddListener(EventFunc1)
end

function Global.Update()
    if ChatModel.flag == true then
        local msg = ChatModel.GetNewMsg()
        -- 更新聊天内容
        chat_display_text.text = chat_display_text.text .. msg
        -- 根据聊天内容改变滑块大小
        -- ChatModel.msg_num
        -- 滑动滑块改变内容
    end
end
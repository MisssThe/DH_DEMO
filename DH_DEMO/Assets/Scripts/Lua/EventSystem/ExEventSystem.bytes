-- 事件系统 xd 20210812

local EventSystem = {}

-- 判断是否为空表
-- @params t: 表
-- @return: 判断结果
local function TableEmpty(t)
    if type(t) ~= "table" then
        return true
    end

    for _, _ in pairs(t) do
        return false
    end
    return true
end

-- 事件类型-回调表
-- 记录事件类型及所对应的回调
-- 其结构为:
-- EventSystem.fuc = {
--     eventTypeA = {
--         async = {
--             __dirDelegate = {无主的回调函数...},
--             instNameA = A实例的回调,
--             instNameB = B实例的回调, ...
--         },
--         sync = {
--             __dirDelegate = {无主的回调函数...},
--             instNameA = A实例的回调,
--             instNameB = B实例的回调, ...
--         },
--     }
--     eventTypeB = {...}, ...
-- }
EventSystem.fuc = {}
-- 事件实例表
-- 记录注册有事件的实例
-- 其结构为:
-- EventSystem.inst = {
--     instNameA = { eventTypeA = true, eventTypeB = false, ... }
--     -- 这里的true和false表示是否异步, 若该实例注销了事件 eventTypeA, 设置其为 nil 即可
-- }
EventSystem.inst = {}

-- 事件类
EventSystem.Event = {
    InstName = "",          -- 实例名称(全局唯一)
    EventIndex = "",        -- 事件类型
    IsAsync = false,        -- 是否异步(这里的异步用协程来实现)
    Delegate = nil          -- 回调函数
}

-- 新建事件
-- @params eventType: 事件类型
-- @params delegate: 回调函数
-- @params instName: 实例名称(全局唯一), 不能有空格或其它特殊字符, 建议使用 gameobject.name + gameObject.GetHashCode()
-- @params isAsync: 是否异步(若为异步函数, 其第一个参数一定是其对应的协程句柄)
-- instName可以为空
function EventSystem.Event:New(eventType, delegate, instName, isAsync)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    if isAsync ~= nil then
        if type(isAsync) ~= "boolean" then
            self.IsAsync = false
        end
        self.IsAsync = isAsync
    else
        self.IsAsync = false
    end
    if instName ~= nil and type(instName) == "string" then
        self.InstName = instName
    else
        instName = ""
    end
    if eventType ~= nil and type(eventType) == "string" then
        self.EventIndex = eventType
    else
        LogUtils.error("EESLog: 试图创建非法事件!")
        return nil
    end
    if delegate ~= nil and type(delegate) == "function" then
        self.Delegate = delegate
    else
        LogUtils.error("EESLog: 试图创建非法事件!")
        return nil
    end

    return o
end

-- 注册信息
-- @params event: 事件(类型为 EventSystem.Event, 建议通过 EventSystem.Event:New(...) 实例化)
-- @params instName: 实例名称(全局唯一), 建议使用 gameobject.name + gameObject.GetHashCode()
-- @params eventType: 事件类型
-- @params delegate: 回调函数
-- 备注: instName不要以下划线开头!!, instName不能有空格
-- @return: 若成功注册则返回 true
function EventSystem.Add(event)
    if type(event) ~= "table" then
        LogUtils.error("EESLog: 注册了不合规范的 event")
    end

    -- 检查类型
    if type(event.InstName) ~= "string" then
        LogUtils.error("EESLog: 注册了不合规范的 event")
        return false
    end
    if type(event.EventIndex) ~= "string" then
        LogUtils.error("EESLog: 注册了不合规范的 event")
        return false
    end
    if type(event.Delegate) ~= "function" then
        LogUtils.error("EESLog: 注册了不合规范的 event")
        return false
    end
    if type(event.IsAsync) ~= "boolean" then
        LogUtils.error("EESLog: 注册了不合规范的 event")
        return false
    end

    -- 注册事件
    if event.EventIndex ~= nil then
        if event.InstName ~= nil or event.InstName ~= ""  then
            -- 有目标实例的事件
            -- 加入实例到实例表中
            if EventSystem.inst[event.InstName] == nil then
                EventSystem.inst[event.InstName] = {}
            end
            (EventSystem.inst[event.InstName])[event.EventIndex] = not event.IsAsync

            -- 加入到事件类型-回调表中
            if EventSystem.fuc[event.EventIndex] == nil then
                EventSystem.fuc[event.EventIndex] = {}
            end
            if not event.IsAsync then
                if EventSystem.fuc[event.EventIndex].sync == nil then
                    EventSystem.fuc[event.EventIndex].sync = {}
                end
                EventSystem.fuc[event.EventIndex].sync[event.InstName] = event.Delegate
            else
                if EventSystem.fuc[event.EventIndex].async == nil then
                    EventSystem.fuc[event.EventIndex].async = {}
                end
                EventSystem.fuc[event.EventIndex].async[event.InstName] = event.Delegate
            end
        else
            -- 没有目标实例的事件
            if not event.IsAsync then
                if EventSystem.fuc[event.EventIndex].sync == nil then
                    EventSystem.fuc[event.EventIndex].sync = {__dirDelegate = {}}
                elseif EventSystem.fuc[event.EventIndex].sync.__dirDelegate == nil then
                    EventSystem.fuc[event.EventIndex].sync.__dirDelegate = {}
                end
                    table.insert(EventSystem.fuc[event.EventIndex].sync.__dirDelegate, event.Delegate)
            else
                if EventSystem.fuc[event.EventIndex].async == nil then
                    EventSystem.fuc[event.EventIndex].async = {__dirDelegate = {}}
                elseif EventSystem.fuc[event.EventIndex].async.__dirDelegate == nil then
                    EventSystem.fuc[event.EventIndex].async.__dirDelegate = {}
                end
                    table.insert(EventSystem.fuc[event.EventIndex].async.__dirDelegate, event.Delegate)
            end
        end

    else
        LogUtils.error("EESLog: 注册了不合规范的 event")
    end
    return true
end

-- 新建并注册事件
-- @params eventType: 事件类型
-- @params delegate: 回调函数
-- @params instName: 实例名称(全局唯一), 不能有空格或其它特殊字符, 建议使用 gameobject.name + gameObject.GetHashCode()
-- @params isAsync: 是否异步(若为异步函数, 其第一个参数一定是其对应的协程句柄)
-- instName可以为空
function EventSystem.AddNew(eventType, delegate, instName, isAsync)
    return EventSystem.Add(EventSystem.Event:New(eventType, delegate, instName, isAsync))
end

-- 新建并注册以哈希值为实例名的事件
-- @params eventType: 事件类型
-- @params delegate: 回调函数
-- @params inst: 注册事件的实例本身
-- @params isAsync: 是否异步(若为异步函数, 其第一个参数一定是其对应的协程句柄)
-- inst 不可以为空, 并且 inst 一定要是 CSharp 类型
function EventSystem.AddNew_withHashCode(eventType, delegate, inst, isAsync)
    if inst == nil then
        LogUtils.error("EESLog: AddNew_withHashCode: 空值无法获取哈希值")
        return
    elseif (type(inst) ~= "table" and type(inst) ~= "userdata") or inst.GetHashCode == nil then
        LogUtils.error("EESLog: AddNew_withHashCode: 该实例无法获取哈希值")
        return false
    end
    return EventSystem.Add(EventSystem.Event:New(eventType, delegate, "_"..tostring(inst:GetHashCode()), isAsync))
end

-- 移除事件类型
-- @params eventType: 事件类型
function EventSystem.DeleteType(eventType)
    -- LogUtils.info("EESLog: 尝试移除事件: "..eventType)
    if EventSystem.fuc[eventType] == nil then
        -- LogUtils.info("EESLog: 该事件: "..eventType.." 并不存在")
        return
    end

    if EventSystem.fuc[eventType].sync ~= nil then
        for key, _ in pairs(EventSystem.fuc[eventType].sync) do
            if EventSystem.inst[key] ~= nil then
                (EventSystem.inst[key])[eventType] = nil
            end
        end
    elseif EventSystem.fuc[eventType].async ~= nil then
        for key, _ in pairs(EventSystem.fuc[eventType].async) do
            if EventSystem.inst[key] ~= nil then
                (EventSystem.inst[key])[eventType] = nil
            end
        end
    end

    EventSystem.fuc[eventType] = nil
end

-- 移除某事件类型注册下的实例
-- @params eventType: 事件类型
-- @params instName: 实例名称
function EventSystem.DeleteInstInType(eventType, instName)
    -- LogUtils.info("EESLog: 尝试移除实例: "..instName.." 注册的事件: "..eventType)
    if EventSystem.fuc[eventType] == nil then
        -- LogUtils.info("EESLog: 该事件: "..eventType.." 并不存在")
        return
    end

    -- 移除异步和同步中记录的实例
    local syncIsEmpty = false
    if EventSystem.fuc[eventType].sync ~= nil then
        EventSystem.fuc[eventType].sync[instName] = nil
        if TableEmpty(EventSystem.fuc[eventType].sync) then
            EventSystem.fuc[eventType].sync = nil
            syncIsEmpty = true
        end
    else
        syncIsEmpty = true
    end
    if EventSystem.fuc[eventType].async ~= nil then
        EventSystem.fuc[eventType].async[instName] = nil
        if TableEmpty(EventSystem.fuc[eventType].async) then
            EventSystem.fuc[eventType].async = nil
            if syncIsEmpty then
                EventSystem.fuc[eventType] = nil
            end
        end
    else
        if syncIsEmpty then
            EventSystem.fuc[eventType] = nil
        end
    end
    -- 移除该实例在实例表中所记录的事件
    if EventSystem.inst[instName] ~= nil then
        (EventSystem.inst[instName])[eventType] = nil

        if TableEmpty(EventSystem.inst[instName]) then
            EventSystem.inst[instName] = nil
        end
    end
end

-- 移除该实例注册的所有信息
-- @params instName: 实例名称
function EventSystem.DeleteInst(instName)
    -- LogUtils.info("EESLog: 尝试移除实例: "..instName)
    if EventSystem.inst[instName] == nil then
        -- LogUtils.info("EESLog: 该实例: "..instName.." 并未注册")
        return
    end

    -- 移除所有该实例的事件
    for key,_ in pairs(EventSystem.inst[instName]) do
        EventSystem.DeleteInstInType(key, instName)
    end

    EventSystem.inst[instName] = nil
end

-- 移除该实例注册的所有信息
-- @params inst: 实例(CSharp实例)
function EventSystem.DeleteInst_withHashCode(inst)
    if inst == nil then
        -- LogUtils.warning("EESLog: DeleteInst_withHashCode: 空值无法获取哈希值")
        return
    elseif (type(inst) ~= "table" and type(inst) ~= "userdata") or inst.GetHashCode == nil then
        -- LogUtils.warning("EESLog: DeleteInst_withHashCode: 该实例无法获取哈希值")
        return
    end

    EventSystem.DeleteInst("_"..tostring(inst.GetHashCode()))
end

-- 移除该哈希值所对应的实例注册的所有信息
-- @params hashCode: 要删除的哈希值
function EventSystem.DeleteHashCode(hashCode)
    if hashCode == nil then
        -- LogUtils.warning("EESLog: DeleteHashCode: 空的哈希值不对应任何实例")
        return
    elseif type(hashCode) ~= "string" then
        -- LogUtils.warning("EESLog: DeleteHashCode: 该哈希值不是 string 类型, 请将其转换为 string 类型")
        return
    end

    EventSystem.DeleteInst("_"..hashCode)
end

-- 触发事件
-- @params eventType: 事件类型(string)
-- @params instName: 目标实例(string)，没有实例时(事件会被广播)请填""
-- @return: (bool or thread[])事件是否成功找到了目标, 若该事件是异步事件，则返回协程句柄列表, 否则返回 Bool 值
function EventSystem.Send(eventType, instName, ...)
    -- 检查类型
    if type(eventType) ~= "string" or type(instName) ~= "string" then
        LogUtils.error("EESLog: 妄图发送错误的事件格式 -- eventType: "..tostring(eventType).." instName: "..tostring(instName))
        return false
    end
    LogUtils.info("EESLog: 尝试发送事件: "..eventType.." 到: "..instName)

    if EventSystem.fuc[eventType] ~= nil then
        -- 若未指定发送的对象
        if instName == "" then
            local success = false;
            if EventSystem.fuc[eventType].sync ~= nil then
                -- 运行无目的的事件
                if EventSystem.fuc[eventType].sync.__dirDelegate ~= nil then
                    for _, value in pairs(EventSystem.fuc[eventType].sync.__dirDelegate) do
                        if type(value) == "function" then
                            value(...)
                        end
                    end
                end
                -- 给所有目的发送该事件
                for _, value in pairs(EventSystem.fuc[eventType].sync) do
                    if type(value) == "function" then
                        value(...)
                    end
                end
                success = true
            else
                success = false;
            end
            if EventSystem.fuc[eventType] == nil then
                return true
            end
            if EventSystem.fuc[eventType].async ~= nil then
                local handles = {}
                -- 运行无目的的事件
                if EventSystem.fuc[eventType].async.__dirDelegate ~= nil then
                    for _, value in pairs(EventSystem.fuc[eventType].async.__dirDelegate) do
                        if type(value) == "function" then
                            local handle = coroutine.create(value)
                            coroutine.resume(handle, handle, ...)
                            table.insert(handles, handle)
                        end
                    end
                end
                -- 给所有目的发送该事件
                for _, value in pairs(EventSystem.fuc[eventType].async) do
                    if type(value) == "function" then
                        local handle = coroutine.create(value)
                        coroutine.resume(handle, handle, ...)
                        table.insert(handles, handle)
                    end
                end
                return handles
            else
                if not success then
                    LogUtils.info("EESLog: 发送事件: "..eventType.." 到: "..instName.." 失败 - 原因: 没有任何实例注册了该事件")
                    return false
                end
            end
            return true
        end

        -- 若指定了发送的对象
        if EventSystem.fuc[eventType].sync ~= nil and EventSystem.fuc[eventType].sync[instName] ~= nil then
            if type(EventSystem.fuc[eventType].sync[instName]) == "function" then
                EventSystem.fuc[eventType].sync[instName](...)
            else
                LogUtils.error("EESLog: 发送事件: "..eventType.." 到: "..instName.." 失败 - 原因: 注册信息不可调用")
                return false
            end
        elseif EventSystem.fuc[eventType].async ~= nil and EventSystem.fuc[eventType].async[instName] ~= nil then
            if type(EventSystem.fuc[eventType].async[instName]) == "function" then
                local handle = coroutine.create(EventSystem.fuc[eventType].async[instName])
                coroutine.resume(handle, handle, ...)
                return {handle}
            else
                LogUtils.error("EESLog: 发送事件: "..eventType.." 到: "..instName.." 失败 - 原因: 注册信息不可调用")
                return false
            end
        else
            LogUtils.info("EESLog: 发送事件: "..eventType.." 到: "..instName.." 失败 - 原因: 该目标没有注册该事件")
            return false
        end
    else
        LogUtils.info("EESLog: 发送事件: "..eventType.." 到: "..instName.." 失败 - 原因: 没有任何实例注册了该事件")
        return false
    end

    return true
end

-- 触发以哈希值为实例名的事件
-- @params eventType: 事件类型
-- @params inst: 注册事件的实例本身
-- inst 不可以为空, 并且 inst 一定要是 CSharp 类型
function EventSystem.Send_withHashCode(eventType, inst, ...)
    if inst == nil then
        LogUtils.warning("EESLog: Send_withHashCode: 空值无法获取哈希值")
        return false
    elseif (type(inst) ~= "table" and type(inst) ~= "userdata") or inst.GetHashCode == nil then
        LogUtils.warning("EESLog: Send_withHashCode: 该实例无法获取哈希值")
        return false
    end
    return EventSystem.Send(eventType, "_"..tostring(inst:GetHashCode()), ...)
end

return EventSystem
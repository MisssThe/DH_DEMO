local EventSystem = {}

-- 事件 类型-回调 表
EventSystem.fuc = {}
-- 事件实例表
EventSystem.inst = {}

-- 事件类
EventSystem.Event = {
    InstName = "",          -- 实例名称(全局唯一)
    EventIndex = "",        -- 事件类型
    IsAsync = false,        -- 是否异步
    Delegate = nil          -- 回调函数
}

-- 新建事件
-- @params instName: 实例名称(全局唯一), 建议使用 gameobject.name + gameObject.GetHashCode()
-- @params isAsync: 是否异步
-- @params eventType: 事件类型
-- @params delegate: 回调函数
-- instName可以为空
function EventSystem.Event:New(o, instName, isAsync, eventType, delegate)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    if isAsync ~= nil then
        self.IsAsync = isAsync
    end
    if instName ~= nil then
        self.InstName = instName
    end
    if eventType ~= nil then
        self.EventIndex = eventType
    else
        print("试图创建非法事件!")
        return nil
    end
    if delegate ~= nil then
        self.Delegate = delegate
    else
        print("试图创建非法事件!")
        return nil
    end

    return o
end

-- 注册信息
-- @params event: 事件
-- @params instName: 实例名称(全局唯一), 建议使用 gameobject.name + gameObject.GetHashCode()
-- @params eventType: 事件类型
-- @params delegate: 回调函数
-- 备注: instName不要以下划线开头!!
-- @return: 若成功注册则返回 true
function EventSystem.Add(event)
    if type(event) ~= "table" then
        print("注册了不合规范的 event")
    end

    -- 注册事件
    if event.EventIndex ~= nil then
        if event.InstName ~= nil or event.InstName ~= ""  then
            -- 检查类型
            if type(event.InstName) ~= "string" then
                print("注册了不合规范的 event")
                return false
            end
            if type(event.EventIndex) ~= "string" then
                print("注册了不合规范的 event")
                return false
            end

            -- 加入实例到实例表中
            if EventSystem.inst[event.InstName] == nil then
                EventSystem.inst[event.InstName] = {}
            end
            table.insert(EventSystem.inst[event.InstName], event.EventIndex)

            -- 加入到事件类型-回调表中
            if ~event.IsAsync then
                if event.Delegate ~= nil then
                    if EventSystem.fuc[event.EventIndex].sync == nil then
                        EventSystem.fuc[event.EventIndex].sync = {}
                    end
                    EventSystem.fuc[event.EventIndex].sync[event.InstName] = event.Delegate
                else
                    print("注册了不合规范的 event")
                    return false
                end
            else
                if event.Delegate ~= nil then
                    if EventSystem.fuc[event.EventIndex].async == nil then
                        EventSystem.fuc[event.EventIndex].async = {}
                    end
                    EventSystem.fuc[event.EventIndex].async[event.InstName] = event.Delegate
                else
                    print("注册了不合规范的 event")
                    return false
                end
            end
        else
            if ~event.IsAsync then
                if EventSystem.fuc[event.EventIndex].sync == nil then
                    EventSystem.fuc[event.EventIndex].sync = {__dirDelegate = {}}
                end
                    table.insert(EventSystem.fuc[event.EventIndex].__dirDelegate, event.Delegate)
            else
                if EventSystem.fuc[event.EventIndex].async == nil then
                    EventSystem.fuc[event.EventIndex].async = {__dirDelegate = {}}
                end
                    table.insert(EventSystem.fuc[event.EventIndex].async.__dirDelegate, event.Delegate)
            end
        end
        
    else
        print("注册了不合规范的 event")
    end
    return true
end

-- 移除事件类型
-- @params eventType: 事件类型
function EventSystem.DeleteType(eventType)
    EventSystem.fuc[eventType] = nil
end

-- 移除某事件类型注册下的实例
-- @params eventType: 事件类型
-- @params instName: 实例名称
function EventSystem.DeleteInstInType(eventType, instName)
    if EventSystem.fuc[eventType] == nil then
        return
    end
    
    -- 移除异步和同步中记录的实例
    EventSystem.fuc[eventType].sync[instName] = nil
    EventSystem.fuc[eventType].async[instName] = nil
end

-- 移除该实例注册的所有信息
-- @params instName: 实例名称
function EventSystem.DeleteInst(instName)
    if EventSystem.inst[instName] == nil then
        return
    end

    -- 移除所有该实例的事件
    for _,v in ipairs(EventSystem.inst[instName]) do
        EventSystem.DeleteInstInType(v, instName)
    end
    
    EventSystem.inst[instName] = nil
end

-- 触发事件
-- @params eventType: 事件类型
-- @params instName: 目标实例，没有实例时(事件会被广播)请填""
-- @return: 事件是否成功找到了目标
function EventSystem.Send(eventType, instName,...)
    -- 检查类型
    if type(eventType) ~= "string" or type(instName) ~= "string" then
        print("妄图发送错误的事件格式")
        return false
    end

    if EventSystem.fuc[eventType] ~= nil then
        -- 若未指定发送的对象
        if instName == "" then
            local success = false;
            if EventSystem.fuc[eventType].sync ~= nil then
                for _, value in ipairs(EventSystem.fuc[eventType].sync) do
                    if type(value) == "function" then
                        value(...)
                    elseif type(value) == "table" then
                        for _, value in ipairs(value) do
                            if type(value) == "function" then
                                value(...)
                            end
                        end
                    end
                end
                success = true
            else
                success = false;
            end
            if EventSystem.fuc[eventType].async ~= nil then
                for _, value in ipairs(EventSystem.fuc[eventType].async) do
                    print("run event!" .. eventType)
                    if type(value) == "function" then
                        local controler = coroutine.create(value)
                        coroutine.resume(controler,...)
                    elseif type(value) == "table" then
                        for _, value in ipairs(value) do
                            if type(value) == "function" then
                                local controler = coroutine.create(value)
                                coroutine.resume(controler,...)
                            end
                        end
                    end
                end
            else
                if ~success then
                    return false
                end
            end
            return true
        end

        -- 若指定了发送的对象
        if EventSystem.fuc[eventType].sync[instName] ~= nil then
            if type(EventSystem.fuc[eventType].sync[instName]) == "function" then
                EventSystem.fuc[eventType].sync[instName](...)
            elseif type(EventSystem.fuc[eventType].sync[instName]) == "table" then
                for _, value in ipairs(EventSystem.fuc[eventType].sync[instName]) do
                    if type(value) == "function" then
                        value(...)
                    end
                end
            end
        elseif EventSystem.fuc[eventType].async[instName] ~= nil then
            if type(EventSystem.fuc[eventType].async[instName]) == "function" then
                local controler = coroutine.create(EventSystem.fuc[eventType].async[instName])
                coroutine.resume(controler,...)
            elseif type(EventSystem.fuc[eventType].async[instName]) == "table" then
                for _, value in ipairs(EventSystem.fuc[eventType].async[instName]) do
                    if type(value) == "function" then
                        local controler = coroutine.create(value)
                        coroutine.resume(controler,...)
                    end
                end
            end
        else
            return false
        end
    else
        return false
    end

    return true
end

return EventSystem
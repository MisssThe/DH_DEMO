require("framework.SharedTools")

Global.EventSystem = {}
EventSystem.fuc = {}

function EventSystem.Add(event,is_asyn,delegate)
    if delegate ~= nil then
        EventSystem.fuc[event] = {is_asyn,delegate}
    end
end

function EventSystem.Delete(event)
    EventSystem.fuc[event] = nil
end

function EventSystem.Send(event,...)
    if EventSystem.fuc[event] ~= nil then
        if(EventSystem.fuc[event][1] == false) then
            EventSystem.fuc[event][2](...)
        else
            local controler = coroutine.create(EventSystem.fuc[event][2])
            coroutine.resume(controler,...)
        end
    else
        print("cant find event...")
    end
end
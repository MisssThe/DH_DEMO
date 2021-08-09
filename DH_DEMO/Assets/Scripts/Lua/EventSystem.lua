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
    if(EventSystem.fuc[event][1] == false) then
        print("run event!")
        print(...)
        print("sss")
        EventSystem.fuc[event][2](...)
    else
        local controler = coroutine.create(EventSystem.fuc[event][2])
        coroutine.resume(controler,...)
    end
end
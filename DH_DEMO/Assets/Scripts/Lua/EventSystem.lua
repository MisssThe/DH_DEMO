EventSystem = {}
EventSystem.fuc = {}

function EventSystem.Add(event,is_asyn,delegate)
    EventSystem.fuc[event] = {is_asyn,delegate}
end

function EventSystem.Delete(event)
    EventSystem.fuc[event] = nil
end

function EventSystem.Send(event,...)
    if(EventSystem.fuc[event][1] == false) then
        EventSystem.fuc[event][2](...)
    else
        local controler = coroutine.create(EventSystem.fuc[event][2])
        coroutine.resume(controler,...)
        --CS.UnityEngine.Monobehaviour:StartCoroutine()
    end
    
end
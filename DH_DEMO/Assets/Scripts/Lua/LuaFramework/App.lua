local App = {}
function App.init()
    require("app.Global")

    --为了任意场景都能够跑，这里的init直接在lua虚拟机创建的时候初始化
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    LogUtils.info("Lua 初始化成功")
    App.startGame()
end

--第一次进入游戏
function App.startGame()
    LogUtils.info("首次进入游戏")
end

--游戏运行时快速重启
function App.restartGame()
    LogUtils.info("刷新游戏")
    App.clearAll()
    --下面是重启游戏逻辑
end

--保持lua库模块不要动，快速重启其他的Lua脚本
function App.restartLua( )
    --不需要卸载的模块
    local whitelist = {
        ["string"] = true,
        ["io"] = true,
        ["pb"] = true,
        ["os"] = true,
        ["debug"] = true,
        ["table"] = true,
        ["math"] = true,
        ["package"] = true,
        ["coroutine"] = true,
        ["pack"] = true,
    }
    App.clearModules(whitelist)
    App.init()
end

function App.clearAll()
    App.clearResourceCache()
    --不需要卸载的模块
    local whitelist = {
        ["string"] = true,
        ["io"] = true,
        ["pb"] = true,
        ["os"] = true,
        ["debug"] = true,
        ["table"] = true,
        ["math"] = true,
        ["package"] = true,
        ["coroutine"] = true,
        ["pack"] = true,
    }
    App.clearModules(whitelist)
end

function App.clearModules(whitelist)
    local __g = _G
    setmetatable(__g, {})
    --卸载已加载的Lua模块
    for p, _ in pairs(package.loaded) do
        if not whitelist[p] then
            package.loaded[p] = nil
        end
    end
end

--业务需求，清理所有资源缓存
function App.clearResourceCache()
    --资源回收
end


return App

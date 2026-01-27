local StarterGui = game:GetService("StarterGui")
local function sendNotification(title, text, duration)
    pcall(function()
        if StarterGui:GetCore("SendNotification") then
            StarterGui:SetCore("SendNotification", {
                Title = title or "Zy pro ",
                Text = text or "正在載入模組...",
                Duration = duration or 4
            })
        end
    end)
end
local function safeLoad(url, name)
    spawn(function()
        pcall(function()
            local source = game:HttpGet(url)
            if source and #source > 0 then
                loadstring(source)()
            else
                warn("無法取得腳本內容: " .. tostring(name))
            end
        end)
    end)
end

sendNotification("zy pro已啟動")

local url1 = "https://obj.wearedevs.net/2/scripts/Owl%20Hub.lua"
local url2 = "https://zynuke.lol/esp.lua"

safeLoad(url1, "Owl Hub")
safeLoad(url2, "ZyNuke ESP")

wait(1)
sendNotification("載入完成")

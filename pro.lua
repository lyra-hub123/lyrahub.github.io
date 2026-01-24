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

-- ====== 執行流程 ======
sendNotification("zy pro已啟動", "正在載入 Owl Hub 與 ZyNuke...", 3)

-- 清理 URL 中多餘空格（你提供的 URL 末尾有空格）
local url1 = "https://obj.wearedevs.net/2/scripts/Owl%20Hub.lua"
local url2 = "https://zynuke.lol/esp.lua"

-- 同時啟動兩個腳本（非阻塞）
safeLoad(url1, "Owl Hub")
safeLoad(url2, "ZyNuke ESP")

-- 可選：加入成功提示（1秒後）
wait(1)
sendNotification("載入完成", "Owl Hub 與 ZyNuke 已執行！", 3)

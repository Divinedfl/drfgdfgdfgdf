

-- \ To check if the script was already loaded \ -
if getgenv().Loaded then
    return;
end

getgenv().Loaded = true

-- \ Loading Wait \ --
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

-- \ Library \ --
local repo = "https://raw.githubusercontent.com/deividcomsono/LinoriaLib/refs/heads/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/MS-ESP/refs/heads/main/source.lua"))()


-- \ Really clear purpose, unloads the script, in a RS connection Library:Unload() is run whenever this variable is set to false
getgenv().ForceUnload = function()
    getgenv().Loaded = false
end

-- \ Variables \ --
local PlayerVariables = {
    Player = game.Players.LocalPlayer,
    Character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait(),
    HumanoidRootPart = game.Players.LocalPlayer.Character.PrimaryPart,
    Humanoid = game.Players.LocalPlayer.Character.Humanoid,
    Collision = game.Players.LocalPlayer.Character:WaitForChild("Collision"),
    Weld = game.Players.LocalPlayer.Character.Collision:FindFirstChildWhichIsA("ManualWeld"),
    DefaultC0 = game.Players.LocalPlayer.Character.Collision:FindFirstChildWhichIsA("ManualWeld").C0,
    CollisionClone = game.Players.LocalPlayer.Character:WaitForChild("Collision"):Clone(),
    CollisionProperties = game.Players.LocalPlayer.Character.Collision.CustomPhysicalProperties,
    RootProperties = game.Players.LocalPlayer.Character.PrimaryPart.CustomPhysicalProperties
}


PlayerVariables.CollisionClone.Parent = PlayerVariables.Collision.Parent
PlayerVariables.CollisionClone.Name = "CollisionFake"

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EntityModules: Folder = ReplicatedStorage.ClientModules.EntityModules
local Glitch: ModuleScript = EntityModules.Glitch
local Void: ModuleScript = EntityModules.Void
local Random: Random =  Random.new()
local charactertable = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
local Shade: ModuleScript = EntityModules.Shade
local gameData: Folder = ReplicatedStorage.GameData
local Floor: StringValue = gameData.Floor.Value
local Disposal = {}
local StoredValues = {}
local Groupboxes = {}
local ToExclude = {
    "FigureHotelChase",
    "Elevator1",
    "MinesFinale"
}
local IsFloor = {
    HardMode = Floor.Value == "Fools",
    Hotel = Floor.Value == "Hotel",
    Mines = Floor.Value == "Mines",
    Retro = Floor.Value == "Retro",
    Backdoor = Floor.Value == "Backdoor",
    Rooms = Floor.Value == "Rooms"
}
local CurrentRoom = tostring(PlayerVariables.Player:GetAttribute("CurrentRoom"))

-- \ Self-explanatory \ --
if workspace.CurrentRooms[CurrentRoom] == nil then
    CurrentRoom = gameData.LatestRoom.Value
end
local NextRoom = tostring(PlayerVariables.Player:GetAttribute("CurrentRoom") + 1)
local Objectives = {
    ["LiveHintBook"] = {ESPName = "Book"},
    ["LiveBreakerPolePickup"] = {ESPName = "Breaker"},
    ["FuseObtain"] = {ESPName = "Fuse"},
    ["MinesAnchor"] = {ESPName = "Anchor"},
    ["WaterPump"] = {ESPName = "Valve"},
    ["MinesGateButton"] = {ESPName = "Gate Button"},
    ["MinesGenerator"] = {ESPName = "Generator"},
    ["KeyObtain"] = {ESPName = "Key"},
    ["TimerLever"] = {ESPName = "Time Lever"},
    ["LeverForGate"] = {ESPName = "Gate Lever"},
    ["ElectricalKeyObtain"] = {ESPName = "Electrical Key"}
}
local BodyProperties = {"HeadColor3", "LeftLegColor3", "LeftArmColor3", "RightLegColor3", "RightArmColor3", "TorsoColor3"}
local uis = game:GetService("UserInputService")
local RemotesFolder: Folder = game:GetService("ReplicatedStorage"):FindFirstChild("RemotesFolder") or ReplicatedStorage:FindFirstChild("EntityInfo");
local PxPromptService = game:GetService("ProximityPromptService")
local Entity: Folder = game.ReplicatedStorage.Entities
local hooks = {}
local Connections = {}
local screechModel: Model = Entity:WaitForChild("Screech")
local timothyModel: Model = Entity:WaitForChild("Spider")
local modules: Folder = game:GetService("Players").LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules
local A90: ModuleScript = modules.A90
local moduleScripts = {
    MainGame = PlayerVariables.Player.PlayerGui.MainUI.Initiator.Main_Game
}
local screechModule: ModuleScript = moduleScripts.MainGame.RemoteListener.Modules.Screech
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local IsBypass = false
local NotifyTable = {
    ["Rush"] = {Notification = "Rush has spawned."},
    ["Ambush"] = {Notification = "Ambush has spawned."},
    ["Jeff The Killer"] = {Notification = "Jeff The Killer has spawned."},
    ["Eyes"] = {Notification = "Eyes has spawned."},
    ["A-60"] = {Notification = "A-60 has spawned."},
    ["A-120"] = { Notification = "A-120 has spawned."},
    ["Blitz"] = {Notification = "Blitz has spawned"},
    ["Lookman"] = {Notification = "Lookman has spawned."}
}
local camera: Camera = workspace.Camera 
local currentcam: Camera = workspace.CurrentCamera
local worldToViewportPoint = camera.worldToViewportPoint
local BodyColors: BodyColors = PlayerVariables.Character["Body Colors"]

local ESPTable = {
    Entity = {},
    SideEntity = {},
    Door = {},
    Item = {},
    Player = {},
    Gold = {},
    Chest = {},
    HidingSpot = {},
    Objective = {}
}

local ESPFunctions = {}

local IsEntity = {
    Names = {
        "Snare",
        "RushMoving",
        "AmbushMoving",
        "FigureRagdoll",
        "FigureRig",
        "BananaPeel",
        "SeekMoving",
        "Eyes",
        "JeffTheKiller",
        "Egg",
        "GiggleCeiling",
        "BackdoorLookman",
        "BackdoorRush",
        "GrumbleRig"
    }
}
local ShortNameTable = {
    "Moving",
    "Obtain",
    "Rig",
    "Ragdoll",
    "Ceiling",
    "Setup",
    "Live",
    "Hint",
    "Pole",
    "New",
    "ForGate",
    "Backdoor",
    "Peel"
}
local ShortNameExclusions = {
    ["JeffTheKiller"] = {Shortened = "Jeff"},
    ["GloomPile"] = {Shortened = "Gloom Eggs"}
}
local FloorHidingSpot = {
    ["Hotel"] = "Wardrobe",
    ["Retro"] = "Wardrobe",
    ["Fools"] = "Wardrobe",
    ["Rooms"] = "Locker",
    ["Mines"] = "Locker"
}
local notificationSound = Instance.new("Sound")

notificationSound.SoundId = "rbxassetid://4590657391"
notificationSound.Parent = game:GetService("SoundService")
notificationSound.Looped = false
notificationSound.Volume = 2
notificationSound.Name = "DV"

Disposal.Light = Instance.new("SpotLight", PlayerVariables.Character.Head) do
    Disposal.Light.Range = 60
    Disposal.Light.Angle = 180
    Disposal.Light.Enabled = false
    Disposal.Light.Name = "DVHub"
    Disposal.Light.Brightness = 0
end
-- \ Functions \ --
function getpadlockcode()
    local PlayerGUI = PlayerVariables.Player
    local Paper = workspace.CurrentRooms:FindFirstChild("50") and (workspace.CurrentRooms:FindFirstChild("50"):FindFirstChild("LibraryHintPaper", true) or workspace.CurrentRooms:FindFirstChild("50"):FindFirstChild("LibraryHintPaperHard", true)) or nil

    if not Paper then
        return
    end

    local Stored = {}
    local Code = ""
    local Count = 0

    for _, v in pairs(Paper.UI:GetChildren()) do
        if v:IsA("ImageLabel") and tonumber(v.Name) then
            Stored[tonumber(v.Name)] = v.ImageRectOffset
        end
    end

    for _, v in pairs(Stored) do
        for index, value in pairs(PlayerGUI.PermUI.Hints:GetChildren()) do
            if value.Name == "Icon" and value:IsA("ImageLabel") and value:FindFirstChild("TextLabel") then
                if v == value.ImageRectOffset then
                    Code = Code .. value.TextLabel.Text
                end
            end
        end
    end
    return Code
end

function ESPFunctions.ESP(Properties: table)
    assert(typeof(Properties) == "table", "ESP function argument was not a table.")

    if not Properties.TextSize then
        Properties.TextSize = 25
    end

    local ESPSave = ESPLibrary.ESP.Highlight({
        Name = Properties.Text,
        Model = Properties.Object,

        FillColor = Properties.Color,
        OutlineColor = Properties.Color,
        TextColor = Properties.Color,
        TextSize = Properties.TextSize,

        OnDestroy = Properties.OnDestroy
    })

    table.insert(ESPTable[Properties.Type], ESPSave)

    return ESPSave
end



function MakeRandomString()
    return charactertable[Random:NextInteger(1, #charactertable)]
end

function RandomString()
    local ret = ""

    for i = 1, 8 do
        local randomletter = MakeRandomString()

        if Random:NextNumber() > 0.5 then
            randomletter = randomletter:upper(randomletter)
        end
        ret = ret .. randomletter
    end
    return ret
end

function isItem(inst)
    if inst:IsA("Model") and (inst:GetAttribute("Pickup") or inst:GetAttribute("PropType")) then 
        return true
    else
        return false
    end
end




getgenv().isnetworkowner = isnetworkowner or function(Part)
   return Part.ReceiveAge == 0
end

function SpeedBypass()
    if IsBypass or not PlayerVariables.CollisionClone then
        return;
    end

    IsBypass = true

    task.spawn(function()
        while Toggles.sbypass.Value and PlayerVariables.CollisionClone and not Library.Unloaded do
            if PlayerVariables.HumanoidRootPart.Anchored then
                PlayerVariables.CollisionClone.Massless = true
                repeat task.wait() until not PlayerVariables.HumanoidRootPart.Anchored
                task.wait(0.15)
            else
                PlayerVariables.CollisionClone.Massless = not PlayerVariables.CollisionClone.Massless
            end
            task.wait(0.24)
        end

        IsBypass = false
        if PlayerVariables.CollisionClone then
            PlayerVariables.CollisionClone.Massless = true
        end
    end)
end




function SetTouch(obj: Instance, CanTouch: boolean)
    if typeof(obj) ~= "Instance" or obj == nil or typeof(CanTouch) ~= "boolean" or CanTouch == nil then
        return;
    end

    if obj:IsA("BasePart") then
        obj.CanTouch = CanTouch;
        return
    end

    for _, v in pairs(obj:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanTouch = CanTouch;
        end
    end
end


function deleteTriggerEventCollision(room)
    if not PlayerVariables.Character or not PlayerVariables.HumanoidRootPart then
        return
    end

    for _, v in pairs(room:GetChildren()) do
        if v.Name == "TriggerEventCollision" then
            for index, child in pairs(v:GetChildren()) do
                if firetouchinterest then

                    task.delay(0.5, function()
                        PlayerVariables.HumanoidRootPart.Anchored = false
                    end)

                    task.delay(2, function()
                        if child:IsDescendantOf(workspace) then
                            Library:Notify("Failed to delete Seek.")
                        end
                    end)
                    Library:Notify("Deleting Seek...")
                    PlayerVariables.HumanoidRootPart.Anchored = true
                    task.spawn(function()
                        repeat
                            firetouchinterest(child, PlayerVariables.HumanoidRootPart, 1)
                            task.wait()
                            firetouchinterest(child, PlayerVariables.HumanoidRootPart, 0)
                            task.wait()
                        until not Toggles.NoSeekFE.Value or not child:IsDescendantOf(workspace)

                        if not child:IsDescendantOf(workspace) then
                            Library:Notify("Seek has been deleted.")
                        else
                            Library:Notify("Failed to delete Seek.")
                        end
                    end)
                end
            end
        end
    end
end


function ShortName(v)
    local Ret = v.Name

    for _, element in pairs(ShortNameTable) do
       Ret = Ret:gsub(element, "")
    end

    if table.find(ShortNameExclusions, v.Name) then
        Ret = ShortNameExclusions[v.Name].Shortened
    end

    if v.Name == "RushMoving" and v.PrimaryPart.Name ~= "RushNew" and IsFloor.HardMode then
        Ret = v.PrimaryPart.Name
    end

    return Ret
end


-- \ UI Code \ --
local Window = Library:CreateWindow({
    Title = "Divine Hub | " .. PlayerVariables.Player.DisplayName .. " | " .. identifyexecutor(),
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.5,
    ShowCustomCursor = false
})





local Tabs = {
   
    Main = Window:AddTab("Local Player"),
    Cheats = Window:AddTab("Cheats"),
    Fun = Window:AddTab("Fun"),
    Visuals = Window:AddTab("Visual"),
    Configs = Window:AddTab("Configs"),
}


Groupboxes.Automation = Tabs.Main:AddLeftGroupbox("Automation")
Groupboxes.Movement = Tabs.Main:AddLeftGroupbox("Movement")

workspace.CurrentRooms.DescendantAdded:Connect(function(d)
    task.wait(.101)
    if d and (d:IsA("Model") or d:IsA("Folder")) and d.Name == "AnimSaves" then d:Destroy(); end
end)

Groupboxes.Automation:AddToggle("noewait", {
    Text = "Instant Interact",
    Default = false,
    Tooltip = "Skips wait-time for interacting.",
})
Groupboxes.Automation:AddDivider()
Groupboxes.Automation:AddToggle("autopl", {
    Text = "Auto Padlock Code",
    Default = false,
    Visible = IsFloor.Hotel or IsFloor.HardMode
})
Groupboxes.Automation:AddToggle("AutoBreakerBox", {
    Text = "Auto Breaker Box",
    Default = false
})
Groupboxes.Movement:AddSlider("Walkspeed", {
    Text = "Walkspeed",
    Default = PlayerVariables.Humanoid.WalkSpeed,
    Min = 0,
    Max = 75,
    Rounding = 0, 
    Compact = true
})
Groupboxes.Movement:AddToggle("sbypass", {
    Text = "Speed Bypass",
    Default = false,
})
Groupboxes.Movement:AddToggle("noslide", {
    Text = "No Sliding",
    Default = false,
})
Groupboxes.Movement:AddToggle("nclip", {
    Text = "Noclip",
    Default = false,
}):AddKeyPicker("noclipKey", {
    Text = "Noclip",
    Default = "N",
    SyncToggleState = true,
    Mode = "Toggle",
    NoUI = false
})

Groupboxes.Movement:AddToggle("jump", {
    Text = "Jump",
    Default = false,
})

Groupboxes.Miscellaneous = Tabs.Main:AddLeftGroupbox("Miscellaneous")
local reviveButton = Groupboxes.Miscellaneous:AddButton({
    Text = "Revive",
    Func = function()
        RemotesFolder:WaitForChild("Revive"):FireServer()
    end,  
    DoubleClick = false,
    Tooltip = "Uses a revive or pops up the prompt to buy one.",

})
local restartButton = Groupboxes.Miscellaneous:AddButton({
    Text = "Restart",
    Func = function()
        RemotesFolder:WaitForChild("PlayAgain"):FireServer()
    end,
    DoubleClick = false,
    Tooltip = "Goes into a new game.",
})
local lobbyButton = Groupboxes.Miscellaneous:AddButton({
    Text = "Lobby",
    Func = function()
        RemotesFolder:WaitForChild("Lobby"):FireServer()
    end,
    DoubleClick = false,
    Tooltip = "Teleports you to the lobby",
})

Groupboxes.Notifying = Tabs.Main:AddRightGroupbox("Notifying")
Groupboxes.Notifying:AddToggle("entitynotif", {
    Text = "Entity Notifications",
    Default = false,
})
Groupboxes.Notifying:AddToggle("NotificationSound", {
    Text = "Notification Sound",
    Default = false
})
Groupboxes.Notifying:AddToggle("plcode", {
    Text = "Padlock Code",
    Default = false,
    Visible = IsFloor.Hotel or IsFloor.HardMode
})
Groupboxes.Notifying:AddToggle("plrleave", {
    Text = "Player Leaving",
    Default = false,
})



Groupboxes.SelfMain = Tabs.Main:AddRightGroupbox("Self")
Groupboxes.SelfMain:AddToggle("lightToggle", {
    Text = "Light",
    Default = false,
})
Groupboxes.SelfMain:AddSlider("lightSlider", {
    Text = "Light Brightness",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = true
})
Groupboxes.SelfMain:AddDivider()
Groupboxes.SelfMain:AddToggle("hidingExiting", {
    Text = "Hiding Exiting Fix",
    Default = false,
})






Groupboxes.Removal = Tabs.Cheats:AddLeftGroupbox("Removal")
Groupboxes.Removal:AddToggle("RemoveScreech", {
    Text = "No Screech",
    Default = false,
    Visible = not IsFloor.Retro and not IsFloor.Backdoor and not IsFloor.Rooms
})
Groupboxes.Removal:AddToggle("GiggleHitboxRemoval", {
    Text = "Anti-Giggle",
    Default = false,
    Visible = IsFloor.Mines
})
Groupboxes.Removal:AddToggle("AntiGloomEgg", {
    Text = "Anti Gloom Egg",
    Default = false,
    Visible = IsFloor.Mines
})
Groupboxes.Removal:AddToggle("DisableCameraShake", {
    Text = "No Camera Shake",
    Default = false,
    Visible = identifyexecutor() ~= "Solara"
})
Groupboxes.Removal:AddToggle("NoTimothyJumpscare", {
    Text = "No Timothy Jumpscare",
    Default = false,
})
Groupboxes.Removal:AddToggle("A90Disabled", {
    Text = "No A90",
    Default = false,
})

Groupboxes.Removal:AddDivider()

Groupboxes.Removal:AddToggle("NoCutscenes", {
    Text = "No Cutscenes",
    Default = false,
})

Groupboxes.Removal:AddDivider()

Groupboxes.Removal:AddToggle("NoSeekFE", {
    Text = "FE No Seek Trigger",
    Default = false,
    Visible = not IsFloor.Backdoor or not IsFloor.Retro
})

Groupboxes.Removal:AddDivider();

Groupboxes.Removal:AddToggle("NoGlitchFX", {
    Text = "No Glitch Jumpscare",
    Default = false
})

Groupboxes.Removal:AddToggle("NoVoidJumpscare", {
    Text = "No Void Effect",
    Default = false
})


Groupboxes.Trolling = Tabs.Cheats:AddRightGroupbox("Trolling")
Groupboxes.Trolling:AddToggle("SpamOtherTools", {
    Text = "Spam Others Tools",
    Default = false,
}):AddKeyPicker("SpamOtherToolsKeybind", {
    Default = "V",

    Mode = "Hold",

    Text = "Spam Others Tools",
    NoUI = false
})

Groupboxes.Trolling:AddToggle("StunToggle", {
    Text = "Stun",
    Default = false
}):AddKeyPicker("StunKeybind", {
    Default = "L",
    SyncToggleState = true,

    Mode = "Toggle",

    Text = "Stun",
    NoUI = false,
})
Groupboxes.Trolling:AddDivider()


local breakFigure = Groupboxes.Trolling:AddButton({
    Text = "Break/Delete Figure",
    Func = function()
        if workspace.CurrentRooms:FindFirstChild("50") then        
            for i, v in pairs(workspace.CurrentRooms["50"]:GetChildren()) do
                if v.Name == "FigureSetup" then
                    local fig = v:FindFirstChild("FigureRig") or v:FindFirstChild("FigureRagdoll")

                    if fig then
                        for j, t in pairs(fig:GetDescendants()) do
                            if t:IsA("BasePart") then
                                t.CanTouch = false
                                t.CanCollide = false
                            end

                            if t:IsA("Attachment") then
                                t.WorldCFrame = PlayerVariables.HumanoidRootPart.CFrame
                            end
                        end

                        fig.PrimaryPart.CFrame = CFrame.new(0, 10000, 0)
                    end
                end
            end
        end
    end,
    DoubleClick = false,
})

Groupboxes.Trolling:AddDivider()

Groupboxes.Trolling:AddDropdown("BodyRotationDropdown", {
    Values = { "Normal", "Upside Down", "Left", "Right", "Up"},
    Default = 1,

    Text = "Body Position",
})
Groupboxes.SelfCheats = Tabs.Cheats:AddRightGroupbox("Self")
Groupboxes.SelfCheats:AddToggle("RemoveSnareHitbox", {
    Text = "Anti-Snare",
    Default = false,
    Visible = IsFloor.Hotel or IsFloor.HardMode
})
Groupboxes.SelfCheats:AddToggle("NoDupeTouch", {
    Text = "Anti-Dupe",
    Default = false,
})
Groupboxes.SelfCheats:AddToggle("nobanana", {
    Text = "Anti-Bananas",
    Default = false,
    Visible = IsFloor.HardMode
})
Groupboxes.SelfCheats:AddToggle("noeyes", {
    Text = not IsFloor.Backdoor and "Anti-Eyes" or "Anti-Lookman",
    Default = false,
})
Groupboxes.SelfCheats:AddToggle("nohalt", {
    Text = "Anti-Halt",
    Default = false,
    Visible = not IsFloor.Backdoor or not IsFloor.Retro
})
Groupboxes.SelfCheats:AddToggle("noObstaclesToggle", {
    Text = "Anti Obstacles",
    Default = false
})
Groupboxes.SelfCheats:AddDivider()

Groupboxes.SelfCheats:AddSlider("doorReach", {
    Text = "Door Reach",
    Default = 12,
    Min = 12,
    Max = 28,
    Rounding = 0,
    Compact = true
})

Groupboxes.SelfCheats:AddDivider()

Groupboxes.SelfCheats:AddToggle("PromptClip", {
    Text = "Prompt Clip", 
    Default = false
})

Groupboxes.SelfCheats:AddSlider("PromptReach", {
    Text = "Prompt Reach",
    Default = 6,
    Min = 1,
    Max = 12,
    Rounding = 0,
    Compact = true
})
Groupboxes.SelfCheats:AddDivider()
Groupboxes.SelfCheats:AddToggle("gm", {
    Text = "Godmode + Noclip Bypass",
    Default = false,
}):AddKeyPicker("gmKey", {
    Default = "G",
    SyncToggleState = true,
    NoUI = false,
    Mode = "Toggle"
})


Groupboxes.FE = Tabs.Fun:AddLeftGroupbox("FE")
Groupboxes.FE:AddToggle("serverSideKillJeff", {
    Text = "FE kill Jeff the Killer",
    Default = false,
    Visible = IsFloor.HardMode
})

Groupboxes.FE:AddDivider()

local breakDoors = Groupboxes.FE:AddButton({
    Text = "Teleport Unanchored",
    Func = function()
        for i, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Attachment") and not v:FindFirstAncestor("RushMoving") and not v:FindFirstAncestor("AmbushMoving") and not v:FindFirstAncestor("Dread") then
                v.WorldCFrame = PlayerVariables.HumanoidRootPart.CFrame
        end
    end

        workspace.CurrentRooms.DescendantAdded:Connect(function(v)
            if v:IsA("Attachment") and not v:FindFirstAncestor("RushMoving") and not v:FindFirstAncestor("AmbushMoving") and not v:FindFirstAncestor("Dread") then
                v.WorldCFrame = PlayerVariables.HumanoidRootPart.CFrame
            end
        end)
    end,
    DoubleClick = false,
})
Groupboxes.FE:AddDivider()

Groupboxes.FE:AddToggle("lagSwitch", {
    Text = "Lag Switch",
    Default = false,
}):AddKeyPicker("keyPicklag", {
    Default = "X",
    SyncToggleState = true,

    Mode = "Toggle",

    Text = "Lag Switch",
    NoUI = false,
})


Groupboxes.FE:AddDivider()

local TenLockpicks =  Groupboxes.FE:AddButton({
    Text = "Get 10 lockpicks",
    Func = function()
                local args = {
                    [1] = {
                        [1] = "Lockpick",
                        [2] = "Lockpick",
                        [3] = "Lockpick",
                        [4] = "Lockpick",
                        [5] = "Lockpick",
                        [6] = "Lockpick",
                        [7] = "Lockpick",
                        [8] = "Lockpick",
                        [9] = "Lockpick",
                        [10] = "Lockpick",
                    }
                }
                RemotesFolder.PreRunShop:FireServer(unpack(args))
            end,
    DoubleClick = false,
    Tooltip = "Need to be in the Item-Shop.",

})

local TenVitamins =  Groupboxes.FE:AddButton({
    Text = "Get 10 vitamins",
    Func = function()
                local args = {
                    [1] = {
                        [1] = "Vitamins",
                        [2] = "Vitamins",
                        [3] = "Vitamins",
                        [4] = "Vitamins",
                        [5] = "Vitamins",
                        [6] = "Vitamins",
                        [7] = "Vitamins",
                        [8] = "Vitamins",
                        [9] = "Vitamins",
                        [10] = "Vitamins",
                    }
                }
                RemotesFolder.PreRunShop:FireServer(unpack(args))
        end,
    DoubleClick = false,
    Tooltip = "Need to be in the Item-Shop.",

})
local TenLighters =  Groupboxes.FE:AddButton({
    Text = "Get 10 lighters",
    Func = function()
                local args = {
                    [1] = {
                        [1] = "Lighter",
                        [2] = "Lighter",
                        [3] = "Lighter",
                        [4] = "Lighter",
                        [5] = "Lighter",
                        [6] = "Lighter",
                        [7] = "Lighter",
                        [8] = "Lighter",
                        [9] = "Lighter",
                        [10] = "Lighter"
                    }
                }
                RemotesFolder.PreRunShop:FireServer(unpack(args))
        end,
    DoubleClick = false,
    Tooltip = "Need to be in the Item-Shop.",

})
local TenFlashlights =  Groupboxes.FE:AddButton({
    Text = "Get 10 flashlights",
    Func = function()
                local args = {
                    [1] = {
                        [1] = "Flashlight",
                        [2] = "Flashlight",
                        [3] = "Flashlight",
                        [4] = "Flashlight",
                        [5] = "Flashlight",
                        [6] = "Flashlight",
                        [7] = "Flashlight",
                        [8] = "Flashlight",
                        [9] = "Flashlight",
                        [10] = "Flashlight",
                    }
                }

                RemotesFolder.PreRunShop:FireServer(unpack(args))
        end,
    DoubleClick = false,
    Tooltip = "Need to be in the Item-Shop.",

})


Groupboxes.EntityESPBox = Tabs.Visuals:AddLeftGroupbox("Entity ESP")

Groupboxes.EntityESPBox:AddToggle("EntityESP", {
    Text = "Enabled",
    Default = false,
})


Groupboxes.InteractablesESP = Tabs.Visuals:AddLeftGroupbox("Interactables")

Groupboxes.InteractablesESP:AddToggle("DoorESP", {
    Text = "Door ESP",
    Default = false,
})

Groupboxes.InteractablesESP:AddToggle("ObjectiveESP", {
    Text = "Objective ESP",
    Default = false
})
Groupboxes.InteractablesESP:AddToggle("ItemESP", {
    Text = "Item ESP",
    Default = false,
})
Groupboxes.InteractablesESP:AddToggle("GoldESP", {
    Text = "Gold ESP",
    Default = false
})
Groupboxes.InteractablesESP:AddToggle("ChestESP", {
    Text = "Chest ESP",
    Default = false
})
Groupboxes.InteractablesESP:AddToggle("HidingSpotsESP", {
    Text = "Hiding Spots ESP",
    Default = false
})
Groupboxes.ESPSettings = Tabs.Visuals:AddLeftGroupbox("ESP Settings");

Groupboxes.ESPSettings:AddLabel("Entity ESP Color"):AddColorPicker("EntityESPColor", {
    Default = Color3.fromRGB(255, 0, 0),
    Title = "Entity ESP Color"
})

Groupboxes.ESPSettings:AddLabel("Door ESP Color"):AddColorPicker("DoorESPColor", {
    Default = Color3.fromRGB(178, 235, 242),
    Title = "Door ESP Color",
})
Groupboxes.ESPSettings:AddLabel("Player ESP Color"):AddColorPicker("PlayerESPColor", {
    Default = Color3.fromRGB(178, 235, 242),
    Title = "Player ESP Color",
})
Groupboxes.ESPSettings:AddLabel("Objective ESP Color"):AddColorPicker("ObjectiveESPColor", {
    Default = Color3.fromRGB(0, 150, 0),
    Title = "Objective ESP Color"
})
Groupboxes.ESPSettings:AddLabel("Item ESP Color"):AddColorPicker("ItemESPColor", {
    Default = Color3.fromRGB(178, 235, 242),
    Title = "Item ESP Color",
})
Groupboxes.ESPSettings:AddLabel("Gold ESP Color"):AddColorPicker("GoldESPColor", {
    Default = Color3.fromRGB(178, 235, 242),
    Title = "Gold ESP Color",
})
Groupboxes.ESPSettings:AddLabel("Chest ESP Color"):AddColorPicker("ChestESPColor", {
    Default = Color3.fromRGB(178, 235, 242),
    Title = "Chest ESP Color",
})
Groupboxes.ESPSettings:AddLabel("Hiding Spot ESP Color"):AddColorPicker("HidingSpotESPColor", {
    Default = Color3.fromRGB(178, 235, 242),
    Title = "Hiding Spot ESP Color",
})
Groupboxes.ESPSettings:AddDivider();

Groupboxes.ESPSettings:AddToggle("DistanceESP", {
    Text = "Show Distance",
    Default = false
})
Groupboxes.ESPSettings:AddToggle("RainbowESP", {
    Text = "Rainbow ESP",
    Default = false
})

Groupboxes.ESPSettings:AddDivider()

Groupboxes.PlayerESP = Tabs.Visuals:AddRightGroupbox("Player ESP")

Groupboxes.PlayerESP:AddToggle("PlayerESP", {
    Text = "Enable",
    Default = false,
})

Groupboxes.View = Tabs.Visuals:AddRightGroupbox("View")



Groupboxes.View:AddToggle("ambienceToggle", {
    Text = "Ambience",
    Default = false,
}):AddColorPicker("ambiencecol", {
    Default = Color3.fromRGB(255, 255, 255),
    Transparency = 0,
})
Groupboxes.View:AddSlider("fovSlider", {
    Text = "Field of View",
    Default = 70,
    Min = 0,
    Max = 120,
    Rounding = 0,
    Compact = true,
})

Groupboxes.View:AddDivider()

Groupboxes.View:AddToggle("TranslucentCloset", {
   Text = "Translucent Closet",
   Default = false
})

Groupboxes.View:AddSlider("TransparencySlider", {
   Text = "Transparency",
   Default = 0.5,
   Min = 0,
   Max = 1,
   Rounding = 1,
   Compact = true 
})
-- \ Logical Code \ --
Toggles.sbypass:OnChanged(function(value)
    if value then
        SpeedBypass();

        task.spawn(function()
            repeat task.wait() until not Toggles.sbypass.Value

            PlayerVariables.CollisionClone.Massless = false
        end)
    end
end)

Toggles.noslide:OnChanged(function(value)
    if value then
        PlayerVariables.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(100, 0, 0, 0, 0)
    else
        PlayerVariables.HumanoidRootPart.CustomPhysicalProperties = PlayerVariables.RootProperties
    end
end)

Toggles.autopl:OnChanged(function(value)
    if PlayerVariables.Character:FindFirstChild("LibraryHintPaper") or PlayerVariables.Character:FindFirstChild("LibraryHintPaperHard") then
        local code = getpadlockcode()

        if #code:split("") >= 5 then
            RemotesFolder.PL:FireServer(code)
        end
    end
end)

Toggles.plcode:OnChanged(function(value)
    if value then
        if PlayerVariables.Character:FindFirstChild("LibraryHintPaper") or PlayerVariables.Character:FindFirstChild("LibraryHintPaperHard") then
            local code = getpadlockcode()
            local Length = code:len()

            local NeededNumber = IsFloor.HardMode and 10 or 5

            local Missing = NeededNumber - Length

            code = code .. string.rep("_", Missing)

            Library:Notify("The code is " .. code ".")
        end
    end
end)

Toggles.plrleave:OnChanged(function(value)
    if value then
        Connections.PlayerLeaving = game.Players.PlayerRemoving:Connect(function(player)
            Library:Notify(player.DisplayName .. " has left the game.")
        end)

        task.spawn(function()
            repeat
                task.wait()
            until not Toggles.plrleave.Value
            Connections.PlayerLeaving:Disconnect();
        end)
    end
end)

Toggles.lightToggle:OnChanged(function(value)
    Disposal.Light.Enabled = value
    Disposal.Light.Brightness = Options.lightSlider.Value
end)

Options.lightSlider:OnChanged(function(value)
    Disposal.Light.Brightness = value
end)

Toggles.hidingExiting:OnChanged(function(value)
    if value then
        Connections.MoveDirection = PlayerVariables.Humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
            RemotesFolder.CamLock:FireServer()

            PlayerVariables.Character:SetAttribute("Hiding", false)
        end)

        task.spawn(function()
            repeat
                task.wait()
            until not Toggles.hidingExiting.Value

            Connections.MoveDirection:Disconnect()
        end)
    end
end)

Toggles.RemoveScreech:OnChanged(function(value)
    local Name = value and "Really Fucking Annoying" or "Screech"

    screechModule.Name = Name
end)

Toggles.GiggleHitboxRemoval:OnChanged(function(value)
    for _, v in pairs(workspace.CurrentRooms[CurrentRoom]:GetChildren()) do
        for i, giggle in pairs(v:GetChildren()) do
            if giggle.Name == "GiggleCeiling" then
                local Hitbox = giggle:WaitForChild("Hitbox", 5)

                if Hitbox then
                    Hitbox.CanTouch = not value
                end
            end
        end
    end
end)

Toggles.AntiGloomEgg:OnChanged(function(value)
    for _, v in pairs(workspace.CurrentRooms[CurrentRoom]:GetChildren()) do
        if v.Name == "GloomPile" then
            for index, egg in pairs(gloomPile:GetDescendants()) do
                if egg.Name == "Egg" then
                    egg.CanTouch = not value
                end
            end
        end
    end
end)

Toggles.NoTimothyJumpscare:OnChanged(function(value)
    timothyModel.Parent = if value then nil else Entity
end)

Toggles.A90Disabled:OnChanged(function(value)
    local Name = value and "DVHub" or "A90"

    A90.Name = Name
end)

Toggles.NoCutscenes:OnChanged(function(value)
    local Cutscenes = moduleScripts.MainGame:FindFirstChild("Cutscenes", true)

    if Cutscenes then
        for _, v in pairs(Cutscenes:GetChildren()) do
            if not table.find(ToExclude, v.Name) then
                local DefaultName = v.Name:gsub("_", "")

                local NewName = value and "OutPlayeddd_" .. DefaultName or DefaultName

                v.Name = NewName
            end
        end
    end
end)

Toggles.NoSeekFE:OnChanged(function(value)
    if value then
        if workspace.CurrentRooms:FindFirstChild(NextRoom) then
            task.spawn(deleteTriggerEventCollision, workspace.CurrentRooms[NextRoom])
        end
    end
end)
Toggles.NoGlitchFX:OnChanged(function(value)
    local Name = value and "DVHub" or "Glitch"

    Glitch.Name = Name
end)

Toggles.NoVoidJumpscare:OnChanged(function(value)
    local Name = value and "Solosss" or "Void"

    Void.Name = Name
end)

Options.BodyRotationDropdown:OnChanged(function(mode)
    local OldPos = PlayerVariables.Collision:GetPivot()

    if mode ~= "Normal" then
        PlayerVariables.Collision.CanCollide = false
        PlayerVariables.Collision.CustomPhysicalProperties = nil
    elseif mode == "Normal" then
        PlayerVariables.Collision.CanCollide = true
        PlayerVariables.Collision.CustomPhysicalProperties = PlayerVariables.CollisionProperties
    end

    if mode == "Normal" then
        PlayerVariables.Weld.C0 = PlayerVariables.DefaultC0
    elseif mode == "Upside Down" then
        PlayerVariables.Weld.C0 = CFrame.new(0, -0.335, 0.3) * CFrame.Angles(math.rad(180), math.rad(180), 0)
    elseif mode == "Up" then
        PlayerVariables.Weld.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-90), 0, 0)
    elseif mode == "Left" then
        PlayerVariables.Weld.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(-90))
    elseif mode == "Right" then
        PlayerVariables.Weld.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90))
    end
    task.wait()
    PlayerVariables.Collision:PivotTo(OldPos)
end)

Toggles.RemoveSnareHitbox:OnChanged(function(value)
    for _, v in pairs(workspace.CurrentRooms[CurrentRoom].Assets:GetChildren()) do
        if v.Name == "Snare" then
            SetTouch(v, not value)
        end
    end
end)

Toggles.NoDupeTouch:OnChanged(function(value)
    for _, v in pairs(workspace.CurrentRooms[CurrentRoom]:GetChildren()) do
        if v.Name == "SideroomDupe" then
            local DoorFake = v:WaitForChild("DoorFake", 5)

            if DoorFake then
                for _, l in pairs(DoorFake:GetDescendants()) do
                    if l:IsA("BasePart") then
                        l.CanTouch = not value
                    end
                end
            end

            for _, l in pairs(DoorFake:GetDescendants()) do
                if l:IsA("ProximityPrompt") then
                    l.Enabled = not value
                end
            end
        end
    end
end)

Toggles.nobanana:OnChanged(function(value)
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == "BananaPeel" then
            v.CanTouch = not value
        end
    end
end)

Toggles.nohalt:OnChanged(function(value)
    local Name = value and "GotYourAss" or "Shade"

    Shade.Name = Name
end)

Toggles.noObstaclesToggle:OnChanged(function(value)
    for _, v in pairs(workspace.CurrentRooms[CurrentRoom].Assets:GetChildren()) do
        for i, obstr in pairs(v:GetDescendants()) do
            if obstr.Name == "Seek_Arm" or obstr.Name == "ChandelierObstruction" then
                SetTouch(obstr, not value)
            end
        end
    end
end)

Options.PromptReach:OnChanged(function(value)
    for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            v.MaxActivationDistance = value;
        end
    end
end)

Toggles.PromptClip:OnChanged(function(value)
    for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            v.RequiresLineOfSight = not value
        end
    end
end)

Toggles.gm:OnChanged(function(value)
    if value then
        PlayerVariables.Collision.Position -= Vector3.new(0, 2.5, 0)

        task.spawn(function()
            repeat task.wait() until not Toggles.gm.Value

            PlayerVariables.Collision.Position += Vector3.new(0, 2.5, 0)
        end)
    end
end)

Toggles.serverSideKillJeff:OnChanged(function(value)
    if value then
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name == "JeffTheKiller" then
                task.spawn(function()
                    repeat
                        task.wait()
                    until isnetworkowner(v) or not v or not v:IsDescendantOf(workspace) or not Toggles.serverSideKillJeff.Value

                    if v and Toggles.serverSideKillJeff.Value then
                        v.Torso.Name = math.random(1, 100)
                    end
                end)
            end
        end
    end
end)

Toggles.EntityESP:OnChanged(function(value)
    if value then
        for _, v in pairs(workspace:GetChildren()) do
            for i, element in pairs(IsEntity) do
                if v.Name == element then
                    ESPFunctions.ESP({
                        Text = ShortName(v),
                        Object = v,
                        Color = Options.EntityESPColor.Value,
                        Type = "Entity"
                    })
                end
            end
        end

        for _, v in pairs(workspace.CurrentRooms[CurrentRoom]:GetDescendants()) do
            for i, element in pairs(IsEntity) do
                if v.Name == element then
                    ESPFunctions.ESP({
                        Text = ShortName(v),
                        Object = v,
                        Color = Options.EntityESPColor.Value,
                        Type = "SideEntity"
                    })
                end
            end
        end
    end
end)

Toggles.DoorESP:OnChanged(function(value)
    if value then
        for _, v in pairs(workspace.CurrentRooms[CurrentRoom]:GetChildren()) do
            if v.Name == "Door" then
                local Door = v:WaitForChild("Door")
                local Locked = v.Parent:GetAttribute("RequiresKey")
                local Opened = v:GetAttribute("Opened")
                local StinkerText = v.Sign.Stinker.Text
                local State = if Locked and not Opened then "\n[LOCKED]" elseif Opened then "\n[OPENED]" else ""
                local str = "Door " .. StinkerText .. State

                local DoorESP = ESPFunctions.ESP({
                    Text = str,
                    Object = Door,
                    Color = Options.DoorESPColor.Value,
                    Type = "Door",
                    
                    OnDestroy = function()
                        if Connections["Door " .. v.Sign.Stinker.Text] then
                            Connections["Door " .. v.Sign.Stinker.Text]:Disconnect()
                        end
                    end
                })

                Connections["Door " .. v.Sign.Stinker.Text] = v:GetAttributeChangedSignal("Opened"):Connect(function()
                    if DoorESP then
                        DoorESP.SetText("Door " .. StinkerText .. "\n[OPENED]")
                    end

                    Connections["Door " .. v.Sign.Stinker.Text]:Disconnect()
                end)
            end
        end
    else
        for _, v in pairs(ESPTable.Door) do
            v.Destroy()
        end
    end
end)

Toggles.ObjectiveESP:OnChanged(function(value)
    if value then
        for _, v in pairs(workspace.CurrentRooms[CurrentRoom]:GetDescendants()) do
            if Objectives[v.Name] and v.Name ~= "WaterPump" then
                ESPFunctions.ESP({
                    Text = Objectives[v.Name].ESPName,
                    Object = v,
                    Color = Options.ObjectiveESPColor.Value,
                    Type = "Objective"
                })

                if v.Name == "WaterPump" then
                    local Wheel = v:WaitForChild("Wheel", 5)
                    local On = v:FindFirstChild("OnFrame", true)


                    if Wheel and (On and On.Visible) then
                        local Random = RandomString()


                        local ESPSave = ESPFunctions.ESP({
                            Text = Objectives[v.Name].ESPName,
                            Object = Wheel,
                            Color = Options.ObjectiveESPColor.Value,
                            Type = "Objective",

                            OnDestroy = function()
                                if Connections[Random] then
                                    Connections[Random]:Disconnect()
                                end
                            end
                        })

                        Connections[Random] = On:GetPropertyChangedSignal("Visible"):Connect(function()
                            if ESPSave then
                                ESPSave.Destroy()
                            end
                        end)
                    end
                end
            end
        end
        task.spawn(function()
            repeat
                task.wait()
            until not Toggles.ObjectiveESP.Value
        end)
    else
        for _, esp in pairs(ESPTable.Objective) do
            esp.Destroy()
        end
    end
end)

Toggles.ItemESP:OnChanged(function(value)
    if value then
        for _, v in pairs(workspace.CurrentRooms[CurrentRoom].Assets:GetDescendants()) do
            if isItem(v) then
                ESPFunctions.ESP({
                    Text = ShortName(v):gsub("SkeletonKey", "Skeleton Key"),
                    Object = v,
                    Color = Options.ItemESPColor.Value,
                    Type = "Item"
                })
            end
        end

        for _, v in pairs(workspace.Drops:GetChildren()) do
            ESPFunctions.ESP({
                Text = ShortName(v):gsub("(%1)(%u), %1, %2"),
                Object = v,
                Color = Options.ItemESPColor.Value,
                Type = "Item"
            })
        end
    else
        for _, v in pairs(ESPTable.Item) do
            v.Destroy()
        end
    end
end)

Toggles.GoldESP:OnChanged(function(value)
    if value then
        for _, v in pairs(workspace.CurrentRooms[CurrentRoom].Assets:GetDescendants()) do
            if v.Name == "GoldPile" then
                ESPFunctions.ESP({
                    Text = "Gold " .. "[" .. v:GetAttribute("GoldValue") .. "]",
                    Object = v,
                    Color = Options.GoldESPColor.Value,
                    Type = "Gold"
                })
            end
        end
    else
        for _, v in pairs(ESPTable.Gold) do
            v.Destroy()
        end
    end
end)

Toggles.ChestESP:OnChanged(function(value)
    if value then
        for _, v in pairs(workspace.CurrentRooms[CurrentRoom]:GetDescendants()) do
            if v.Name == "Chest" or v.Name == "Toolshed_Small" or v:GetAttribute("Storage") == "ChestBox" then
                local Final = v.Name:gsub("_Small", ""):gsub("_Vine", ""):gsub("Locked", ""):gsub("Box", "")

                if v:GetAttribute("Locked") then
                    Final = Final .. "\n[LOCKED]"
                end

                ESPFunctions.ESP({
                    Text = Final,
                    Object = v,
                    Color = Options.ChestESPColor.Value,
                    Type = "Chest"
                })
            end
        end
    else
        for _, v in pairs(ESPTable.Chest) do
            v.Destroy()
        end
    end
end)

Toggles.HidingSpotsESP:OnChanged(function(value)
    if value then
        for _, v in pairs(workspace.CurrentRooms[CurrentRoom].Assets:GetChildren()) do
            if v:GetAttribute("LoadModule") == "Wardrobe" or v:GetAttribute("LoadModule") == "Bed" or v.Name == "Rooms_Locker" or v.Name == "Retro_Wardrobe" then
                local isBed = v:GetAttribute("LoadModule") == "Bed"
                ESPFunctions.ESP({
                    Text = if isBed then "Bed" else FloorHidingSpot[Floor],
                    Object = v,
                    Color = Options.HidingSpotESPColor.Value,
                    Type = "HidingSpot"
                })
            end
        end
    else
        for _, v in pairs(ESPTable.HidingSpot) do
            v.Destroy()
        end
    end
end)

Toggles.PlayerESP:OnChanged(function(value)
    if value then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= PlayerVariables.Player then
                local playerCharacter = player.Character or player.CharacterAdded:Wait()

                ESPFunctions.ESP({
                    Text = player.DisplayName,
                    Object = playerCharacter,
                    Color = Options.PlayerESPColor.Value,
                    Type = "Player"
                })
            end
        end
    else
        for _, v in pairs(ESPTable.Player) do
            v.Destroy()
        end
    end
end)

Options.EntityESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Entity) do
        v.Update({
            FillColor = value,
            OutlineColor = value,
            TextColor = value
        })
    end
end)

Options.DoorESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Door) do
        v.Update({
            FillColor = value,
            OutlineColor = value,
            TextColor = value
        })
    end
end)

Options.ObjectiveESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Objective) do
        v.Update({
            FillColor = value,
            OutlineColor = value,
            TextColor = value
        })
    end
end)

Options.ItemESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Item) do
        v.Update({
            FillColor = value,
            OutlineColor = value,
            TextColor = value
        })
    end
end)

Options.GoldESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Gold) do
        v.Update({
            FillColor = value,
            OutlineColor = value,
            TextColor = value
        })
    end
end)

Options.ChestESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Chest) do
        v.Update({
            FillColor = value,
            OutlineColor = value,
            TextColor = value
        })
    end
end)

Options.PlayerESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Player) do
        v.Update({
            FillColor = value,
            OutlineColor = value,
            TextColor = value
        })
    end
end)

Options.HidingSpotESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.HidingSpot) do
        v.Update({
            FillColor = value,
            OutlineColor = value,
            TextColor = value
        })
    end
end)

Toggles.RainbowESP:OnChanged(function(value)
    ESPLibrary.Rainbow:Set(value)
end)

Toggles.DistanceESP:OnChanged(function(value)
    ESPLibrary.Distance:Set(value)
end)

Toggles.TranslucentCloset:OnChanged(function(value)
    if value then
        if PlayerVariables.Character:GetAttribute("Hiding") then
            for _, v in pairs(workspace.CurrentRooms[CurrentRoom]:FindFirstChild("Assets"):GetChildren()) do
                if v:GetAttribute("LoadModule") == "Wardrobe" or v.Name == "Rooms_Locker" or v.Name == "Retro_Wardrobe"then
                    if v.HiddenPlayer.Value == PlayerVariables.Player then
                        local Parts = {}

                        for _, v in pairs(v:GetChildren()) do
                            if v:IsA("BasePart") then
                                table.insert(Parts, v)
                            end
                        end

                        task.spawn(function()
                            repeat
                                task.wait()
                                for _, v in pairs(Parts) do
                                    v.Transparency = Options.TransparencySlider.Value
                                end
                            until not Toggles.TranslucentCloset.Value or not PlayerVariables.Character:GetAttribute("Hiding")

                            for _, v in pairs(Parts) do
                                v.Transparency = 0
                            end

                            Parts = {}
                        end)
                        break;
                    end
                end
            end
        end

        Connections.Hidden = PlayerVariables.Character:GetAttributeChangedSignal("Hiding"):Connect(function(val)
            if val then
                for _, v in pairs(workspace.CurrentRooms[CurrentRoom]:FindFirstChild("Assets"):GetChildren()) do
                    if v:GetAttribute("LoadModule") == "Wardrobe" or v.Name == "Rooms_Locker" or v.Name == "Retro_Wardrobe" then
                        if v.HiddenPlayer.Value == PlayerVariables.Player then
                            local Parts = {}

                            for _, v in pairs(v:GetChildren()) do
                                if v:IsA("BasePart") then
                                    table.insert(Parts, v)
                                end
                            end

                            task.spawn(function()
                                repeat
                                    task.wait()
                                    for _, v in pairs(Parts) do
                                        v.Transparency = Options.TransparencySlider.Value
                                    end
                                until not Toggles.TranslucentCloset.Value or not PlayerVariables.Character:GetAttribute("Hiding")

                                for _, v in pairs(Parts) do
                                    v.Transparency = 0
                                end

                                Parts = {}
                            end)
                            break;
                        end
                    end
                end
            end

            task.spawn(function()
                repeat
                    task.wait()
                until not Toggles.TranslucentCloset.Value

                Connections.Hidden:Disconnect()
            end)
        end)
    end
end)




-- \ Main connections \ --
Connections.MainRenderStepped = RunService.RenderStepped:Connect(function()

    if not getgenv().Loaded then
        Library:Unload()
    end

    if Toggles.ambienceToggle.Value then
        game.Lighting.Ambient = Options.ambiencecol.Value
    else
        game.Lighting.Ambient = workspace.CurrentRooms[CurrentRoom]:GetAttribute("Ambient")
    end

    StoredValues.Distance = (workspace.CurrentRooms[CurrentRoom]:FindFirstChild("Door"):FindFirstChild("Door"):GetPivot().Position - PlayerVariables.Character:GetPivot().Position).Magnitude

    if StoredValues.Distance <= Options.doorReach.Value then
        workspace.CurrentRooms[CurrentRoom]:WaitForChild("Door"):WaitForChild("ClientOpen"):FireServer()
    end

    if Toggles.SpamOtherTools.Value and Options.SpamOtherToolsKeybind:GetState() then
        for _, player in pairs(game.Players:GetPlayers()) do
            for index, item in pairs(player.Backpack:GetChildren()) do
                item:FindFirstChildWhichIsA("RemoteEvent"):FireServer()
            end

            for index, item in pairs(player.Character:GetChildren()) do
                if item:IsA("Tool") then
                    item:FindFirstChildWhichIsA("RemoteEvent"):FireServer()
                end
            end
        end
    end

    if Toggles.noeyes.Value and (workspace:FindFirstChild("Eyes") or workspace:FindFirstChild("BackdoorLookman")) then
        RemotesFolder.MotorReplication:FireServer(-649)
    end

    PlayerVariables.Character:SetAttribute("Stunned", Toggles.StunToggle.Value)
    PlayerVariables.Humanoid.WalkSpeed = Options.Walkspeed.Value
    PlayerVariables.Character:SetAttribute("CanJump", Toggles.jump.Value)

    if Toggles.DisableCameraShake.Value then
        require(moduleScripts.MainGame).csgo = CFrame.new(0, 0, 0)
    end

    workspace.CurrentCamera.FieldOfView = Options.fovSlider.Value

    if identifyexecutor() ~= "Solara" then
        require(moduleScripts.MainGame).fovtarget = Options.fovSlider.Value
    end

    for _, v in pairs(PlayerVariables.Character:GetChildren()) do
        if v:IsA("BasePart") then
            v.CanCollide = not Toggles.nclip.Value
        end
    end

    if Toggles.lagSwitch.Value and Options.keyPicklag:GetState() then
        settings():GetService("NetworkSettings").IncomingReplicationLag = math.huge
    else
        settings():GetService("NetworkSettings").IncomingReplicationLag = 0
    end

    if PlayerVariables.CollisionClone and PlayerVariables.Collision then
        PlayerVariables.CollisionClone.CollisionGroup = PlayerVariables.Collision.CollisionGroup;
    end
    if Library.Unloaded then
        Connections.MainRenderStepped:Disconnect()
    end
end)

Connections.EntityHandler = workspace.ChildAdded:Connect(function(child: Model)
    if not child:IsA("Model") then return; end

    task.wait(0.5)
    if Toggles.EntityESP.Value then
        for i, element in pairs(IsEntity.Names) do
            if element == child.Name and (child:GetPivot().Position - PlayerVariables.Character:GetPivot().Position).Magnitude < 750 then
                ESPFunctions.ESP({
                    Text = ShortName(child),
                    Object = child,
                    Color = Options.EntityESPColor.Value,
                    Type = "Entity"
                })
            end
        end
    end

    if Toggles.entitynotif.Value then
        if NotifyTable[ShortName(child)] and (child:GetPivot().Position - PlayerVariables.Character:GetPivot().Position).Magnitude < 750 then
            print("Notif")
            Library:Notify(NotifyTable[ShortName(child)].Notification)
        end
    end

    if child.Name == "BananaPeel" then
        child.CanTouch = not Toggles.nobanana.Value
    end

    if Toggles.serverSideKillJeff.Value then
        if child.Name == "JeffTheKiller" then
            task.spawn(function()
                repeat
                    task.wait()
                until isnetworkowner(child) or not child or not child:IsDescendantOf(workspace) or not Toggles.serverSideKillJeff.Value

                if Toggles.serverSideKillJeff.Value and child then
                    child.Torso.Name = math.random(1, 50)
                end
            end)
        end
    end
end)


Connections.PromptBegan = PxPromptService.PromptButtonHoldBegan:Connect(function(prompt, playerWhoTriggered)
    if Toggles.noewait.Value then
        if playerWhoTriggered == PlayerVariables.Player then
            local OriginalDuration = prompt.HoldDuration

            prompt.HoldDuration = 0
            fireproximityprompt(prompt);

            prompt.HoldDuration = OriginalDuration
        end
    end
end)

Connections.Items = PlayerVariables.Character.ChildAdded:Connect(function(child: Tool)
    if Toggles.plcode.Value then
        if child.Name == "LibraryHintPaper" or child.Name == "LibraryHintPaperHard" then
            local Needed = child.Name == "LibraryHintPaperHard" and 10 or 5
            local code = getpadlockcode()
            local Amount = code:len()

            if Needed - Amount ~= 0 then
                local Missing = Needed - Amount

                code = code .. string.rep("_", Missing)
            end

            notification("The code is " .. code ".", Toggles.NotificationSound.Value)
        end
    end

    if Toggles.autopl.Value then
        if child.Name == "LibraryHintPaper" or child.Name == "LibraryHintPaperHard" then
            local Needed = child.Name == "LibraryHintPaperHard" and 10 or 5
            local code = getpadlockcode()
            local Amount = code:len()

            if Needed - Amount == 0 then
                RemotesFolder.PL:FireServer(code)
            end
        end
    end
end)


Connections.RoomHandler = workspace.CurrentRooms.ChildAdded:Connect(function(child: Model)
    child:WaitForChild("Assets")

    if Toggles.entitynotif.Value then
        if child:GetAttribute("RawName") == "HaltHallway" then
            Library:Notify("Halt is in the next room.")
        end
    end
end)

Connections.Dropped = workspace.Drops.ChildAdded:Connect(function(child: Instance)
    if Toggles.ItemESP.Value then
        ESPFunctions.ESP({
            Text = ShortName(child),
            Object = child,
            Color = Options.ItemESPColor.Value,
            Type = "Item"
        })
    end
end)

Connections.RoomChanged = PlayerVariables.Player:GetAttributeChangedSignal("CurrentRoom"):Connect(function(RoomValue)

    if workspace.CurrentRooms[tostring(PlayerVariables.Player:GetAttribute("CurrentRoom"))] == nil then
        CurrentRoom = gameData.LatestRoom.Value
    end

    CurrentRoom = tostring(PlayerVariables.Player:GetAttribute("CurrentRoom"))
    NextRoom = tostring(PlayerVariables.Player:GetAttribute("CurrentRoom") + 1)

    for i, v in pairs(Connections) do
        if type(i) == "number" then
            if i ~= tonumber(CurrentRoom) then
                v:Disconnect()
            end
        end
    end

    for _, v in pairs(workspace.CurrentRooms[CurrentRoom]:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            v.MaxActivationDistance = Options.PromptReach.Value
            v.RequiresLineOfSight = not Toggles.PromptClip.Value
        end
    end

    if Connections[tonumber(CurrentRoom)] then
        Connections[tonumber(CurrentRoom)]:Disconnect()
    end

    if Toggles.EntityESP.Value then
        for _, v in pairs(ESPTable.SideEntity) do
            v.Destroy()
        end
    end

    if Toggles.ItemESP.Value then
        for _, v in pairs(ESPTable.Item) do
            v.Destroy()
        end
    end

    if Toggles.DoorESP.Value then
        for _, v in pairs(ESPTable.Door) do
            v.Destroy()
        end
    end

    if Toggles.ObjectiveESP.Value then
        for _, v in pairs(ESPTable.Objective) do
            v.Destroy()
        end
    end

    if Toggles.GoldESP.Value then
        for _, v in pairs(ESPTable.Gold) do
            v.Destroy()
        end
    end

    if Toggles.ChestESP.Value then
        for _, v in pairs(ESPTable.Chest) do
            v.Destroy()
        end
    end

    if Toggles.HidingSpotsESP.Value then
        for _, v in pairs(ESPTable.HidingSpot) do
            v.Destroy()
        end
    end

    for _, v in pairs(workspace.CurrentRooms[CurrentRoom]:GetDescendants()) do
        if Objectives[v.Name] and Toggles.ObjectiveESP.Value and v.Name ~= "WaterPump" then
            ESPFunctions.ESP({
                Text = ShortName(v),
                Object = v,
                Color = Options.ObjectiveESPColor.Value,
                Type = "Objective"
            })
        end

        if v.Name == "WaterPump" and Toggles.ObjectiveESP.Value then
            local Wheel = v:WaitForChild("Wheel", 5)
            local OnFrame = v:FindFirstChild("OnFrame", true)

            if Wheel and (OnFrame and OnFrame.Visible) then
                local Random = RandomString()

                local ESP = ESPFunctions.ESP({
                    Text = "Valve",
                    Object = Wheel,
                    Color = Options.ObjectiveESPColor.Value,
                    Type = "Objective",

                    OnDestroy = function()
                        if Connections[Random] then
                            Connections[Random]:Disconnect()
                        end
                    end
                })


                Connections[Random] = OnFrame:GetPropertyChangedSignal("Visible"):Connect(function()
                    if Wheel and v and OnFrame and ESP then
                        ESP.Destroy()
                    end
                end)
            end
        end

        if Toggles.EntityESP.Value then
            for i, element in pairs(IsEntity) do
                if v.Name == element then
                    ESPFunctions.ESP({
                        Text = ShortName(v),
                        Object = v,
                        Color = Options.EntityESPColor.Value,
                        Type = "SideEntity"
                    })
                end
            end
        end


        if Toggles.ItemESP.Value then
            if isItem(v) then
                ESPFunctions.ESP({
                    Text = ShortName(v),
                    Object = v,
                    Color = Options.ItemESPColor.Value,
                    Type = "Item"
                })
            end
        end

        if Toggles.GoldESP.Value then
            if v.Name == "GoldPile" then
                ESPFunctions.ESP({
                    Text = "Gold " .. "[" .. v:GetAttribute("GoldValue") .. "]",
                    Object = v,
                    Color = Options.GoldESPColor.Value,
                    Type = "Gold"
                })
            end
        end

        if Toggles.ChestESP.Value then
            if v:GetAttribute("Storage") == "ChestBox" or v.Name == "Toolshed_Small" or string.find(v.Name, "Chest") then
                local Locked = v:GetAttribute("Category") == "ChestLocked"
                local str = v.Name:gsub("_Small", ""):gsub("_Vine", ""):gsub("Locked", ""):gsub("Box", "")
                
                if Locked then
                    str = str .. "\n[LOCKED]"
                end
            end
        end

        if Toggles.HidingSpotsESP.Value then
            if v:GetAttribute("LoadModule") == "Wardrobe" or v:GetAttribute("LoadModule") == "Bed" or v.Name == "Rooms_Locker" or v.Name == "Retro_Wardrobe" then
                local isBed = v:GetAttribute("LoadModule") == "Bed"
                local str = isBed and "Bed" or FloorHidingSpot[Floor]

                ESPFunctions.ESP({
                    Text = str,
                    Object = v,
                    Color = Options.HidingSpotESPColor.Value,
                    Type = "HidingSpot"
                })
            end
        end

        if v.Name == "GiggleCeiling" and v:FindFirstChild("Hitbox") then
            v.Hitbox.CanTouch = not Toggles.GiggleHitboxRemoval.Value
        end

        if v.Name == "Egg" then
            v.CanTouch = not Toggles.AntiGloomEgg.Value
        end

        if v.Name == "Snare" then
            SetTouch(v, not Toggles.noObstaclesToggle.Value)
        end

        if v.Name == "Seek_Arm" or v.Name == "ChandelierObstruction" then
            v.CanTouch = not Toggles.noObstaclesToggle.Value
        end

        if v.Name == "DoorFake" then
            for _, l in pairs(v:GetDescendants()) do
                if l:IsA("BasePart") then
                    l.CanTouch = not Toggles.NoDupeTouch.Value
                end
            end

            for _, l in pairs(v:GetDescendants()) do
                if l:IsA("ProximityPrompt") then
                    l.Enabled = not Toggles.NoDupeTouch.Value
                end
            end
        end
    end
    
    if Toggles.NoSeekFE.Value and workspace.CurrentRooms:FindFirstChild(NextRoom) then
        task.spawn(deleteTriggerEventCollision, workspace.CurrentRooms[NextRoom])
    end

    Connections[tonumber(CurrentRoom)] = workspace.CurrentRooms[CurrentRoom]:WaitForChild("Assets").DescendantAdded:Connect(function(v)
        task.wait(.5)

        if isItem(v) and Toggles.ItemESP.Value then
            ESPFunctions.ESP({
                Text = ShortName(v),
                Object = v,
                Color = Options.ItemESPColor.Value,
                Type = "Item"
            })
        end

        if v.Name == "GoldPile" and Toggles.GoldESP.Value then
            ESPFunctions.ESP({
                Text = "Gold " .. "[" .. v:GetAttribute("GoldValue") .. "]",
                Object = v,
                Color = Options.GoldESPColor.Value,
                Type = "Gold"
            })
        end
    end)

    for _, v in pairs(workspace.CurrentRooms[CurrentRoom]:GetChildren()) do
        if v.Name == "Door" then
            local Door = v:FindFirstChild("Door")
            local Locked = v.Parent:GetAttribute("RequiresKey")
            local Opened = v:GetAttribute("Opened")
            local State = if Opened then "\n[OPENED]" elseif Locked then "\n[LOCKED]" else "" 
            local StinkerText = v.Sign.Stinker.Text
            local str = "Door " .. StinkerText .. State

            local DoorESP = ESPFunctions.ESP({
                Text = str,
                Object = Door,
                Color = Options.DoorESPColor.Value,
                Type = "Door",

                OnDestroy = function()
                    if Connections["Door " .. v.Sign.Stinker.Text] then
                        Connections["Door " .. v.Sign.Stinker.Text]:Disconnect()
                    end
                end
            })

            Connections["Door " .. v.Sign.Stinker.Text] = v:GetAttributeChangedSignal("Opened"):Connect(function()
                if DoorESP then
                    DoorESP.SetText("Door " .. StinkerText .. "\n[OPENED]")
                end

                Connections["Door " .. v.Sign.Stinker.Text]:Disconnect()
            end)
        end
    end
end)
local MenuGroup = Tabs.Configs:AddLeftGroupbox("Menu")

MenuGroup:AddButton("Unload", function() Library:Unload() end)
MenuGroup:AddToggle("showKeybinds", {
    Text = "Show Keybinds",
    Default = false,
    Callback = function(Value)
        Library.KeybindFrame.Visible = Value
    end
})
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "Right Shift", NoUI = true, Text = "Menu Keybind" })
MenuGroup:AddToggle("CustomCursor", {
    Text = "Show Custom Cursor",
    Default = true,
    Callback = function(Value)
        Window.ShowCustomCursor = Value
    end
})

Library:OnUnload(function()
    for _, toggle in pairs(Toggles) do
        toggle:SetValue(false)
    end

    for _, conn in pairs(Connections) do
        conn:Disconnect()
    end

    Options.Walkspeed:SetValue(16)

    Library.Unloaded = true

    getgenv().Loaded = false
end)

Library.ToggleKeybind = Options.MenuKeybind


ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)


SaveManager:IgnoreThemeSettings()


SaveManager:SetIgnoreIndexes({ "MenuKeybind" })


ThemeManager:SetFolder("Divine Hub")
SaveManager:SetFolder("Divine Hub/DOORS")



SaveManager:BuildConfigSection(Tabs.Configs)


ThemeManager:ApplyToTab(Tabs.Configs)

SaveManager:LoadAutoloadConfig()


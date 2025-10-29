local skUI = {}

function skUI:CreateWindow(titleText)
    local player = game.Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "skUI"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = player:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    mainFrame.BorderSizePixel = 0
    mainFrame.Size = UDim2.new(0, 272, 0, 208)
    mainFrame.Position = UDim2.new(0, 54, 0, 2)
    mainFrame.Parent = gui

    Instance.new("UICorner", mainFrame)
    Instance.new("UIStroke", mainFrame).Thickness = 3

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(0, 272, 0, 44)
    title.Text = titleText
    title.TextWrapped = true
    title.TextSize = 36
    title.FontFace = Font.new("rbxasset://fonts/families/PressStart2P.json")
    title.TextColor3 = Color3.fromRGB(118, 118, 118)
    title.Parent = mainFrame
    Instance.new("UIStroke", title).Color = Color3.fromRGB(255, 255, 255)

    local pageHolder = Instance.new("Frame")
    pageHolder.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
    pageHolder.BorderSizePixel = 0
    pageHolder.Size = UDim2.new(0, 254, 0, 156)
    pageHolder.Position = UDim2.new(0, 8, 0, 44)
    pageHolder.Parent = mainFrame
    Instance.new("UICorner", pageHolder)
    Instance.new("UIStroke", pageHolder).Thickness = 2

    local scroll = Instance.new("ScrollingFrame")
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.ScrollBarThickness = 5
    scroll.Parent = pageHolder

    local page = {}
    function page:CreateButton(text, callback)
        local button = Instance.new("TextButton")
        button.Text = text
        button.TextWrapped = true
        button.TextScaled = true
        button.TextColor3 = Color3.fromRGB(195, 193, 193)
        button.BackgroundColor3 = Color3.fromRGB(108, 108, 108)
        button.FontFace = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Bold)
        button.BorderSizePixel = 0
        button.Size = UDim2.new(0, 238, 0, 46)
        button.Position = UDim2.new(0, 8, 0, 8)
        button.Parent = scroll

        Instance.new("UICorner", button)
        Instance.new("UIStroke", button).Thickness = 2

        button.MouseButton1Click:Connect(callback)
        return button
    end

    return page
end

return skUI

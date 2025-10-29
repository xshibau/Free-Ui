local skUI = {}
skUI.Windows = {}

function skUI:CreateWindow(title)
    local window = {}
    window.Tabs = {}

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = title or "Window"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("CoreGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,590,0,312)
    MainFrame.Position = UDim2.new(0,60,0,-24)
    MainFrame.BackgroundColor3 = Color3.fromRGB(83,83,83)
    MainFrame.BackgroundTransparency = 1
    MainFrame.Parent = ScreenGui
    window.Frame = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1,0,0,40)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title or "Window"
    TitleLabel.TextColor3 = Color3.fromRGB(206,177,66)
    TitleLabel.TextScaled = true
    TitleLabel.Parent = MainFrame
    window.Title = TitleLabel

    function window:CreateTab(name)
        local tab = {}
        tab.Pages = {}

        local TabFrame = Instance.new("Frame")
        TabFrame.Size = UDim2.new(0,182,1,-40)
        TabFrame.Position = UDim2.new(0,16,0,40)
        TabFrame.BackgroundColor3 = Color3.fromRGB(51,51,51)
        TabFrame.Parent = MainFrame

        local ScrollTab = Instance.new("ScrollingFrame")
        ScrollTab.Size = UDim2.new(1,0,1,0)
        ScrollTab.BackgroundTransparency = 1
        ScrollTab.ScrollBarThickness = 5
        ScrollTab.Parent = TabFrame

        local TabLayout = Instance.new("UIListLayout")
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Padding = UDim.new(0,5)
        TabLayout.Parent = ScrollTab

        function tab:CreatePage(name)
            local page = {}
            page.Elements = {}

            local PageFrame = Instance.new("Frame")
            PageFrame.Size = UDim2.new(1,-182,1,-40)
            PageFrame.Position = UDim2.new(0,182,0,40)
            PageFrame.BackgroundColor3 = Color3.fromRGB(51,51,51)
            PageFrame.Parent = MainFrame

            local PageLayout = Instance.new("UIListLayout")
            PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
            PageLayout.Padding = UDim.new(0,5)
            PageLayout.Parent = PageFrame

            function page:CreateButton(text, callback)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1,0,0,34)
                btn.Text = text
                btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
                btn.TextColor3 = Color3.fromRGB(255,255,255)
                btn.Parent = PageFrame
                btn.MouseButton1Click:Connect(callback)
                table.insert(page.Elements, btn)
                return btn
            end

            function page:CreateToggle(text, default, callback)
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Size = UDim2.new(1,0,0,34)
                toggleFrame.BackgroundTransparency = 1
                toggleFrame.Parent = PageFrame

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0.7,0,1,0)
                label.BackgroundTransparency = 1
                label.Text = text
                label.TextColor3 = Color3.fromRGB(255,255,255)
                label.TextScaled = true
                label.Parent = toggleFrame

                local switch = Instance.new("Frame")
                switch.Size = UDim2.new(0,50,0,20)
                switch.Position = UDim2.new(0.75,0,0.25,0)
                switch.BackgroundColor3 = default and Color3.fromRGB(0,255,0) or Color3.fromRGB(150,150,150)
                switch.Parent = toggleFrame
                local state = default or false

                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1,0,1,0)
                button.BackgroundTransparency = 1
                button.Text = ""
                button.Parent = toggleFrame
                button.MouseButton1Click:Connect(function()
                    state = not state
                    switch.BackgroundColor3 = state and Color3.fromRGB(0,255,0) or Color3.fromRGB(150,150,150)
                    callback(state)
                end)
                table.insert(page.Elements,toggleFrame)
                return toggleFrame
            end

            function page:CreateSlider(text, min, max, default, callback)
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Size = UDim2.new(1,0,0,34)
                sliderFrame.BackgroundTransparency = 1
                sliderFrame.Parent = PageFrame

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0.3,0,1,0)
                label.BackgroundTransparency = 1
                label.Text = text
                label.TextColor3 = Color3.fromRGB(255,255,255)
                label.TextScaled = true
                label.Parent = sliderFrame

                local bar = Instance.new("Frame")
                bar.Size = UDim2.new(0.6,0,0.4,0)
                bar.Position = UDim2.new(0.35,0,0.3,0)
                bar.BackgroundColor3 = Color3.fromRGB(100,100,100)
                bar.Parent = sliderFrame

                local knob = Instance.new("TextButton")
                knob.Size = UDim2.new(0,10,1,0)
                knob.Position = UDim2.new((default-min)/(max-min)*0.6,0,0,0)
                knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
                knob.Text = ""
                knob.Parent = bar

                local dragging = false
                knob.MouseButton1Down:Connect(function()
                    dragging = true
                end)
                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType==Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
                        local mouseX = math.clamp(input.Position.X - bar.AbsolutePosition.X,0,bar.AbsoluteSize.X)
                        knob.Position = UDim2.new(mouseX/bar.AbsoluteSize.X,0,0,0)
                        local value = min + (mouseX/bar.AbsoluteSize.X)*(max-min)
                        callback(value)
                    end
                end)
                table.insert(page.Elements,sliderFrame)
                return sliderFrame
            end

            function page:CreateDropdown(text,list,callback)
                local dropFrame = Instance.new("Frame")
                dropFrame.Size = UDim2.new(1,0,0,34)
                dropFrame.BackgroundTransparency = 1
                dropFrame.Parent = PageFrame

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0.4,0,1,0)
                label.BackgroundTransparency = 1
                label.Text = text
                label.TextColor3 = Color3.fromRGB(255,255,255)
                label.TextScaled = true
                label.Parent = dropFrame

                local selected = Instance.new("TextButton")
                selected.Size = UDim2.new(0.5,0,1,0)
                selected.Position = UDim2.new(0.5,0,0,0)
                selected.BackgroundColor3 = Color3.fromRGB(80,80,80)
                selected.TextColor3 = Color3.fromRGB(255,255,255)
                selected.Text = list[1] or ""
                selected.Parent = dropFrame
                local dropOpen = false
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Size = UDim2.new(0.5,0,0,0)
                dropdownFrame.Position = UDim2.new(0.5,0,1,0)
                dropdownFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
                dropdownFrame.ClipsDescendants = true
                dropdownFrame.Parent = dropFrame

                selected.MouseButton1Click:Connect(function()
                    dropOpen = not dropOpen
                    dropdownFrame.Size = dropOpen and UDim2.new(0.5,0,0,#list*34) or UDim2.new(0.5,0,0,0)
                end)

                for i,v in ipairs(list) do
                    local opt = Instance.new("TextButton")
                    opt.Size = UDim2.new(1,0,0,34)
                    opt.Position = UDim2.new(0,0,0,(i-1)*34)
                    opt.BackgroundColor3 = Color3.fromRGB(100,100,100)
                    opt.TextColor3 = Color3.fromRGB(255,255,255)
                    opt.Text = v
                    opt.Parent = dropdownFrame
                    opt.MouseButton1Click:Connect(function()
                        selected.Text = v
                        callback(v)
                        dropdownFrame.Size = UDim2.new(0.5,0,0,0)
                        dropOpen = false
                    end)
                end

                table.insert(page.Elements,dropFrame)
                return dropFrame
            end

            function page:CreateTextBox(text,placeholder,callback)
                local boxFrame = Instance.new("Frame")
                boxFrame.Size = UDim2.new(1,0,0,34)
                boxFrame.BackgroundTransparency = 1
                boxFrame.Parent = PageFrame

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0.3,0,1,0)
                label.BackgroundTransparency = 1
                label.Text = text
                label.TextColor3 = Color3.fromRGB(255,255,255)
                label.TextScaled = true
                label.Parent = boxFrame

                local box = Instance.new("TextBox")
                box.Size = UDim2.new(0.65,0,1,0)
                box.Position = UDim2.new(0.35,0,0,0)
                box.PlaceholderText = placeholder or ""
                box.Text = ""
                box.ClearTextOnFocus = false
                box.TextColor3 = Color3.fromRGB(255,255,255)
                box.BackgroundColor3 = Color3.fromRGB(80,80,80)
                box.Parent = boxFrame
                box.FocusLost:Connect(function(enter)
                    callback(box.Text)
                end)
                table.insert(page.Elements,boxFrame)
                return boxFrame
            end

            table.insert(tab.Pages,page)
            page.Frame = PageFrame
            return page
        end

        table.insert(window.Tabs,tab)
        return tab
    end

    table.insert(self.Windows,window)
    return window
end

return skUI

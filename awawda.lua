-- UILibrary.lua
local Library = {}
Library.__index = Library

-- Helper function to create UI elements
local function create(class, props)
	local obj = Instance.new(class)
	for k, v in pairs(props) do
		obj[k] = v
	end
	return obj
end

function Library:CreateWindow(title)
	local self = setmetatable({}, Library)

	-- ScreenGui
	self.Gui = create("ScreenGui", {
		Name = "MyUILibrary",
		ResetOnSpawn = false,
		Parent = game:GetService("CoreGui")
	})

	-- Main Frame
	self.Main = create("Frame", {
		Size = UDim2.new(0, 400, 0, 300),
		Position = UDim2.new(0.5, -200, 0.5, -150),
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderSizePixel = 0,
		Parent = self.Gui
	})

	-- Title
	self.Title = create("TextLabel", {
		Text = title,
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.SourceSansBold,
		TextSize = 20,
		Parent = self.Main
	})

	self.ElementsY = 50 -- initial element Y-position

	return self
end

function Library:CreateButton(text, callback)
	local button = create("TextButton", {
		Size = UDim2.new(0, 360, 0, 40),
		Position = UDim2.new(0, 20, 0, self.ElementsY),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Text = text,
		Font = Enum.Font.SourceSans,
		TextSize = 18,
		Parent = self.Main
	})

	button.MouseButton1Click:Connect(function()
		pcall(callback)
	end)

	self.ElementsY = self.ElementsY + 45 -- move next element down
end

function Library:CreateToggle(text, callback)
	local state = false

	local toggle = create("TextButton", {
		Size = UDim2.new(0, 360, 0, 40),
		Position = UDim2.new(0, 20, 0, self.ElementsY),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Text = text .. ": OFF",
		Font = Enum.Font.SourceSans,
		TextSize = 18,
		Parent = self.Main
	})

	toggle.MouseButton1Click:Connect(function()
		state = not state
		toggle.Text = text .. ": " .. (state and "ON" or "OFF")
		pcall(callback, state)
	end)

	self.ElementsY = self.ElementsY + 45
end

return Library

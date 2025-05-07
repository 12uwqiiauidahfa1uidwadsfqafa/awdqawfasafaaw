-- RDR2UILib.lua
local RDR2UI = {}
RDR2UI.__index = RDR2UI

local function create(class, props)
	local inst = Instance.new(class)
	for k, v in pairs(props) do
		inst[k] = v
	end
	return inst
end

function RDR2UI:CreateWindow(title)
	local self = setmetatable({}, RDR2UI)

	-- GUI
	self.Gui = create("ScreenGui", {
		Name = "RDR2UILib",
		ResetOnSpawn = false,
		Parent = game:GetService("CoreGui"),
	})

	-- Main Frame
	self.Main = create("Frame", {
		Size = UDim2.new(0, 400, 0, 300),
		Position = UDim2.new(0.5, -200, 0.5, -150),
		BackgroundColor3 = Color3.fromRGB(43, 32, 24), -- dark leather look
		BorderColor3 = Color3.fromRGB(170, 85, 0), -- gold trim
		BorderSizePixel = 2,
		Parent = self.Gui,
		Active = true,
		Draggable = true,
	})

	-- RDR2 Font-like Title
	self.Title = create("TextLabel", {
		Text = title,
		Font = Enum.Font.Garamond, -- serif font similar to RDR2
		TextSize = 24,
		TextColor3 = Color3.fromRGB(212, 175, 55), -- gold tone
		BackgroundColor3 = Color3.fromRGB(60, 45, 35),
		Size = UDim2.new(1, 0, 0, 40),
		Parent = self.Main,
	})

	self.ElementsY = 50

	-- Drag Support (Mouse + Touch)
	local dragging, dragInput, startPos, inputStart
	self.Main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			inputStart = input.Position
			startPos = self.Main.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	self.Main.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - inputStart
			self.Main.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
		end
	end)

	return self
end

function RDR2UI:CreateButton(text, callback)
	local button = create("TextButton", {
		Text = text,
		Font = Enum.Font.Garamond,
		TextSize = 20,
		TextColor3 = Color3.new(1, 1, 1),
		BackgroundColor3 = Color3.fromRGB(80, 60, 50),
		Size = UDim2.new(0, 360, 0, 40),
		Position = UDim2.new(0, 20, 0, self.ElementsY),
		Parent = self.Main,
	})

	button.MouseButton1Click:Connect(function()
		pcall(callback)
	end)

	self.ElementsY = self.ElementsY + 45
end

return RDR2UI

--[[
Add to StarterPlayerScripts as a LocalScript.
--]]


local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")


local moveDirection = Vector3.new(0, 0, 0)

local keyToVector = {
	W = Vector3.new(0, 0, -1),
	S = Vector3.new(0, 0, 1),
	A = Vector3.new(-1, 0, 0),
	D = Vector3.new(1, 0, 0),
	Up = Vector3.new(0, 0, -1),
	Down = Vector3.new(0, 0, 1),
	Left = Vector3.new(-1, 0, 0),
	Right = Vector3.new(1, 0, 0),
}

local keysDown = {}

local function updateMoveDirection()
	local directionsPressed = {}
	for key, down in pairs(keysDown) do
		if down then
			table.insert(directionsPressed, keyToVector[key])
		end
	end
	
	local preferredOrder = {"W","S","A","D","Up","Down","Left","Right"}
	
	for _, key in ipairs(preferredOrder) do 
		if keysDown[key] then
			moveDirection = keyToVector[key]
			return
		end
	end
	
	moveDirection = Vector3.new(0, 0, 0)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	local keyName = input.KeyCode.Name
	if keyToVector[keyName] then
		keysDown[keyName] = true
		updateMoveDirection()
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	local keyName = input.KeyCode.Name
	if keyToVector[keyName] then
		keysDown[keyName] = false
		updateMoveDirection()
	end
end)

RunService.RenderStepped:Connect(function()
	if not humanoid or humanoid.Health <= 0 then return end
	
	if moveDirection.Magnitude > 0 then
		
		local lookVector = moveDirection.Unit
		rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + lookVector)
		
		humanoid:Move(moveDirection, false)
	else
		humanoid:Move(Vector3.new(0, 0, 0), false)
	end
end)

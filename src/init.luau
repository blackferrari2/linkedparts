local collectionService = game:GetService("CollectionService")

local linkedparts = {}
linkedparts.__index = linkedparts

-------------

type self = {
	name: string,
	color: Color3,
	transparency: number,
}

export type linkedparts = typeof(setmetatable({} :: self, linkedparts))

-------------

function linkedparts.new(name: string, color: Color3?, transparency: number?): linkedparts
	local self = {
		name = name,
		color = color or Color3.new(0, 0, 0),
		transparency = transparency or 0,
	}

	setmetatable(self, linkedparts)

	return self
end

function linkedparts.create(self: linkedparts): Part
	local part = Instance.new("Part")

	part.Anchored = true
	part.CanCollide = false
	part.Parent = workspace

	self:link(part)

	return part
end

function linkedparts.link(self: linkedparts, with: BasePart)
	with.Color = self.color
	with.Transparency = self.transparency
	collectionService:AddTag(with, self.name)
end

function linkedparts.unlink(self: linkedparts, with: BasePart)
	collectionService:RemoveTag(with, self.name)
end

function linkedparts.setColor(self: linkedparts, new: Color3)
	for _, part in pairs(collectionService:GetTagged(self.name)) do
		part.Color = new
	end

	self.color = new
end

function linkedparts.setTransparency(self: linkedparts, new: number)
	for _, part in pairs(collectionService:GetTagged(self.name)) do
		part.Transparency = new
	end

	self.transparency = new
end

-- will just untag everything
function linkedparts.destroy(self: linkedparts)
	for _, part in pairs(collectionService:GetTagged(self.name)) do
		part:RemoveTag(self.name)
	end

	local setmetatable: any = setmetatable
	setmetatable(self, nil)
end

-------------

return linkedparts
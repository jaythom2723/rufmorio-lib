local entity_types = defines.prototypes.entity

ENTITY = setmetatable({}, {
    __call = function(self, entity)
        if not entity.type then error("Tried to extend an entity " .. entity.name .. " without providing a type") end
        if not entity_types[entity.type] then error("Tried to use ENTITY{} on a non-entity: " .. entity.name) end

        data:extend{entity}
        return entity
    end
})

local metas = {}

metas.add_flag = function(self, flag)
    if not self.flags then self.flags = {} end
    for i,f in pairs(self.flags) do
        if f == flag then table.remove(self.flags, i) end
    end
    return self
end

metas.has_flag = function(self, flag)
    if not self.flags then return false end
    for _,f in pairs(self.flags) do
        if f == flag then return true end
    end
    return false
end

return metas
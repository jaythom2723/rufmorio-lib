ITEM = setmetatable({}, {
    __call = function(self, item)
        if not item.type then error("Tried to extend an item " .. item.name .. " without providing a type...") end
        
        data:extend{item}
        return item
    end
})

local metas = {}

metas.add_flag = function(self, flag)
    if not self.flags then self.flags = {} end
    table.insert(self.flags, flag)
    return self
end

metas.remove_flag = function(self, flag)
    if not self.flags then return self end
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
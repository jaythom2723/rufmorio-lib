GROUP = setmetatable({}, {
    __call = function(self, group)
        if not group.type then
            error("Tried to extend a group " .. group.name .. " without providing a type ")
        end
        
        ext_group = {
            type = group.type,
            name = group.name,
            icon = group.icon,
            order = group.order or "a"
        }

        data:extend{ext_group}

        for _,sg in pairs(group.subs) do
            subgroup = {
                type = "item-subgroup",
                name = sg.name,
                group = group.name,
				order = sg.order or nil
            }
            data:extend{subgroup}
        end

        return group
    end
})
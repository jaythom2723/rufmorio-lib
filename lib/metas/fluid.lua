FLUID = setmetatable(data.raw.fluid, {
    __call = function(self, fluid)
        data:extend{fluid}
        return fluid
    end
})

local metas = {}

return metas
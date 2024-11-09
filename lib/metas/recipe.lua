local metas = {}

RECIPE = setmetatable(data.raw.recipe, {
    __call = function(self, recipe)
        data:extend{recipe}
    end
})

metas.add_unlock = function(self, technology_name)
    if type(technology_name) == "table" then
        for _, tech in pairs(technology_name) do
            self:add_unlock(tech)
        end
        return self
    end

    local technology = data.raw.technology[technology_name]
    if not technology then
        log("WARNING @ \'" .. self.name .. "\':add_unlock(): Technology " .. technology_name .. " does not exist")
        return self
    end

    if not technology.effects then
        technology.effects = {}
    end

    table.insert(technology.effects, { type="unlock-recipe", recipe = self.name })
    self.enabled = false
    return self
end

metas.remove_unlocked = function(self, technology_name)
    if type(technology_name) == "table" then
        for _,tech in pairs(technology_name) do
            self:remove_unlock(tech)
        end
        return self
    end

    local technology = data.raw.technology[technology_name]
    if not technology then
        log("WARNING @ \'" .. self.name .. "\':remove_unlock(): Technology " .. technology_name .. " does not exist")
        return self
    end

    if not technology.effects then
        return self
    end

    technology.effects = table.filter(technology.effects, function(effect)
        return effect.recipe ~= self.name
    end)

    return self
end

metas.add_ingredient = function(self, ingredient)
    for _,existing in pairs(self.ingredients) do
        if existing.name == ingredient.name and existing.type == ingredient.type then
            if existing.amount and ingredient.amount then
                existing.amount = existing.amount + ingredient.amount
                existing.ignored_by_productivity = (existing.ignored_by_productivity or 0) + (ingredient.ignored_by_productivity or 0)
                return self
            end
        end
    end

    if (not self.category or self.category == 'crafting') and ingredient.type == 'fluid' then
        self.category = 'crafting-with-fluid'
    end

    table.insert(self.ingredients, ingredient)

    return self
end

metas.add_result = function(self, result)
    table.insert(self.results, result)
    return self
end

metas.remove_ingredient = function(self, ingredient_name)
    local amount_removed = 0
    self.ingredients = table.filter(self.ingredients, function(ingredient)
        if ingredient.name == ingredient_name then
            local amount = ingredient.amount or (ingredient.amount_min + ingredient.amount_max) / 2
            amount_removed = amount_removed + amount
            return false
        end
        return true
    end)
    return self,amount_removed
end

metas.clear_ingredients = function(self)
    self.ingredients = {}
    return self
end

metas.multiply_result_amount = function(self, result_name, percent)
    for _,result in pairs(self.results) do
        if result.name == result_name then
            local amount = result.amount or (result.amount_min + result.amount_max) / 2
            result.amount = math.ceil(amount * percent)
            result.amount_min = nil
            result.amount_max = nil
            return self
        end
    end

    log("WARNING @ \'" .. self.name .. "\':multiply_result_amount(): Result " .. result_name .. " not found")
    return self
end

metas.multiplty_ingredient_amount = function(self, ingredient_name, percent)
    for _,ingredient in pairs(self.ingredients) do
        if ingredient.name == ingredient_name then
            ingredient.amount = math.ceil(ingredient.amount * percent)
            return self
        end
    end
    
    log("WARNING @ \'" .. self.name .. "\':multiply_ingredient_amount(): Ingredient " .. ingredient_name .. " not found")
    return self
end

metas.add_result_amount = function(self, result_name, increase)
    for _,result in pairs(self.results) do
        if result.name == result_name then
            result.amount = result.amount + increase
            return self
        end
    end
    
    log("WARNING @ \'" .. self.name .. "\':add_result_amount(): Result " .. result_name .. " not found")
    return self
end

metas.add_ingredient_amount = function(self, ingredient_name, increase)
    for _,ingredient in pairs(self.ingredients) do
        if ingredient.name == ingredient_name then
            ingredient.amount = ingredient.amount + incrase
            return self
        end
    end

    log("WARNING @ \'" .. self.name .. "\':add_ingredient_amount(): Ingredient " .. ingredient_name .. " not found")
    return self
end

return metas
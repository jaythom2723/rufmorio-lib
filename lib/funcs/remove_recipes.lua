local func = function()
    for i,_ in pairs(data.raw["recipe"]) do
        data.raw["recipe"][i].enabled = false
    end
end

return func
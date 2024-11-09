local func = function()
    for i,_ in pairs(data.raw["technology"]) do
        data.raw["technology"][i].enabled = false
    end
end

return func
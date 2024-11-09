local ores_to_remove = {
    "iron-ore",
    "copper-ore",
    "stone",
    "coal",
    "crude-oil",
    "uranium-ore"
}

local function removePresetOres(resource)
    for i,j in pairs(data.raw["map-gen-presets"]["default"]) do
        tbl = data.raw["map-gen-presets"]["default"][i]
        
        if type(tbl) == "table" and tbl.basic_settings and tbl.basic_settings.autoplace_controls then
            tbl.basic_settings.autoplace_controls[resource] = nil
        end

        data.raw["map-gen-presets"]["default"][i] = tbl
    end
end

local func = function()
    for _,v in ipairs(ores_to_remove) do
        data.raw["planet"]["nauvis"].map_gen_settings.autoplace_controls[v] = nil
        data.raw["planet"]["nauvis"].map_gen_settings.autoplace_settings["entity"].settings[v] = nil
        
        -- remove autoplace controls from the presets
        removePresetOres(v)
        
        data.raw["autoplace-control"][v] = nil
    end
end

return func
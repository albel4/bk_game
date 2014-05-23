function register_metal(name, metalDef)
	if not metalDef.ore and metalDef.ore ~= false then
		if not metalDef.lump then
			metalDef.lump = "metals:"..name.."_lump"
		end
	end

	minetest.register_craftitem(":"..metalDef.lump, {
		description = metalDef.description.." Lump",
		inventory_image = "metals_"..name.."_lump.png" ,
	});
	bk_game.register_ore(name, metalDef)
	if not metalDef.ingots and metalDef.ingots ~= false then
		if not metalDef.ingot then
			metalDef.ingot = "metals:"..name.."_ingot";
			minetest.register_craftitem(":"..metalDef.ingot, {
				description = metalDef.description.." Ingot",
				inventory_image = "metals_"..name.."_ingot.png",
			})
		end
		if not metalDef.craft and metalDef.craft ~= false then
			if not metalDef.lump then
				metalDef.lump = "metals:"..name.."_lump"
			end
			minetest.register_craft({
				type = "cooking",
				output = metalDef.ingot,
				recipe = metalDef.lump,
			})
		end
	end
	if not metalDef.source then
		if not metalDef.ingot then
			return
		else 
			metalDef.source = metalDef.ingot
		end 
	end

	if not metalDef.block and metalDef.block ~= false then
		metalDef.stair = true
		metalDef.slab = true
		-- now this only for minerals
		--metalDef.column = true
		--metalDef.pyramid = true
		bk_game.register_nodes(name, metalDef)
	end


	if metalDef.tools ~= false then
		bk_game.register_tools(name, metalDef)
	end
	
	metalDef.only_placer_can_open = true
	bk_game.register_door(name,metalDef)
end


list = {
    "adamant",
    "mithril",
    "chromium",
    "copper",
    "gold",
    "silver", 
    "steel",
    "tin",
    "zinc",
}

opts_list = {
    {description = "Adamant", level=1, uses=0, times={ [1]=0.50, [2]=0.50, [3]=0.50, [4]=0.50, [5]=0.50, [6]=0.50,}, full_punch_interval=0.20, chunk_size=3, height_max=-20000, tools=false, height_max=-25000, height_min=-37000}, -- for admins only?
    {description = "Mithril", level=2, uses=30, times={ [2]=2.00, [3]=1.80, [4]=1.60, [5]=1.40, [6]=1.20}, height_max=-10000},
    {description = "Chromium", tools = false, height_max=10, height_min=-5000},
    {description = "Copper", level=4, uses=20, times={ [4]=2.00, [5]=1.20, [6]=1.20},height_max=-250},
    {description = "Gold", tools = false, height_max=-10000},
    {description = "Silver", tools = false, height_max=-5000, height_min=-20000},
    {description = "Steel", lump = "metals:iron_lump", level=4, uses=20,  times={ [4]=2.20,[5]=1.80, [6]=1.20,}}, 
    {description = "Tin", tools = false, height_min=-10000},
    {description = "Zinc", tools = false, height_min=-15000},
}

for _, metal in ipairs(list) do
    register_metal(metal, opts_list[_]) 
end


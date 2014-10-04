function bk_game.register_tools(name, toolDef)
	if not toolDef.source or not toolDef or not name then
		return
	end
	if not toolDef.times then
		toolDef.times={ [1]=10.00, [2]=9.00, [3]=8.00, [4]=7.00, [5]=6.00, [6]=5.00, [7]=4.00, [8]=3.00, [9]=2.00, [10]=1.00,}
	end
	if not toolDef.uses then
		toolDef.uses = 10
	end
	if not toolDef.level then
		toolDef.level = 5
	end

	if not toolDef.full_punch_interval then
		toolDef.full_punch_interval = 0.9
	end
	-- Picks
	if not toolDef.pick and toolDef.pick ~= false then
		minetest.register_tool(":tools:pick_"..name, {
			description = toolDef.description.." Pickaxe",
			inventory_image = "tools_pick_"..name..".png",
			tool_capabilities = {
				full_punch_interval = toolDef.full_punch_interval,
				max_drop_level=toolDef.level,
				groupcaps={
					cracky = {times=toolDef.times , uses=toolDef.uses, maxlevel=toolDef.level},
				},
				damage_groups = {cracky=toolDef.level},
			},
		})
		minetest.register_craft({
			output = "tools:pick_"..name,
			recipe = {
				{toolDef.source, toolDef.source, toolDef.source},
				{"", "group:stick", ""},
				{"", "group:stick", ""},
			}
		})
	end

	-- Shovels
	if not toolDef.shovel and toolDef.shovel ~= false then
		minetest.register_tool(":tools:shovel_"..name, {
			description = toolDef.description.." Shovel",
			inventory_image = "tools_shovel_"..name..".png",
			tool_capabilities = {
				full_punch_interval = 0.9,
				max_drop_level=toolDef.level,
				groupcaps={
					crumbly = {times=toolDef.times , uses=toolDef.uses, maxlevel=toolDef.level},
				},
				damage_groups = {crumbly=toolDef.level},
			},
		})

		minetest.register_craft({
			output = "tools:shovel_"..name,
			recipe = {
				{toolDef.source},
				{"group:stick"},
				{"group:stick"},
			}
		})
	end

	-- Axes
	if not toolDef.axe and toolDef.axe ~= false then
		minetest.register_tool(":tools:axe_"..name, {
			description = toolDef.description.." Axe",
			inventory_image = "tools_axe_"..name..".png",
			tool_capabilities = {
				full_punch_interval = 0.9,
				max_drop_level=toolDef.level,
				groupcaps={
					choppy = {times=toolDef.times , uses=toolDef.uses, maxlevel=toolDef.level},
				},
				damage_groups = {choppy=toolDef.level},
			},
		})

		minetest.register_craft({
			output = "tools:axe_"..name,
			recipe = {
				{toolDef.source, toolDef.source},
				{toolDef.source, "group:stick"},
				{"", "group:stick"},
			}
		})
		minetest.register_craft({
			output = "tools:axe_"..name,
			recipe = {
				{"", toolDef.source, toolDef.source},
				{"", "group:stick",  toolDef.source},
				{"", "group:stick",  ""},
			}
		})
	end

	-- Sword`s
	if not toolDef.sword and toolDef.sword ~= false then
		minetest.register_tool(":tools:sword_"..name, {
			description = toolDef.description.." Sword",
			inventory_image = "tools_sword_"..name..".png",
			tool_capabilities = {
				full_punch_interval = 0.9,
				max_drop_level=toolDef.level,
				groupcaps={
					snappy = {times=toolDef.times , uses=toolDef.uses, maxlevel=toolDef.level},
				},
				damage_groups = {snappy=toolDef.level},
			},
		})
		minetest.register_craft({
			output = "tools:sword_"..name,
			recipe = {
				{toolDef.source},
				{toolDef.source},
				{"group:stick"},
			}
		})

	end

	-- Hoe`s
	if not toolDef.hoe and toolDef.hoe ~= false then

		minetest.register_tool(":tools:hoe_"..name, {
			description = toolDef.description.." Hoe",
			inventory_image = "tools_hoe_"..name..".png",
			on_use = function(itemstack, user, pointed_thing)
				-- check if pointing at a node
				if pointed_thing.type ~= "node" then
					return
				end

				local under = minetest.get_node(pointed_thing.under)
				local p = {x=pointed_thing.under.x, y=pointed_thing.under.y+1, z=pointed_thing.under.z}
				local above = minetest.get_node(p)

				-- return if any of the nodes is not registered
				if not minetest.registered_nodes[under.name] then
					return
				end
				if not minetest.registered_nodes[above.name] then
					return
				end

				-- check if the node above the pointed thing is air
				if above.name ~= "air" then
					return
				end

				-- check if pointing at dirt
				if minetest.get_item_group(under.name, "soil") ~= 1 then
					return
				end

				-- turn the node into soil, wear out item and play sound
				minetest.set_node(pointed_thing.under, {name="flowers:soil"})
				itemstack:add_wear(65535/(toolDef.uses*5-1))
				return itemstack
			end,
		})

		minetest.register_craft({
			output = "tools:hoe_"..name,
			recipe = {
				{toolDef.source, toolDef.source, ""},
				{"", "group:stick", ""},
				{"", "group:stick", ""},
			}
		})

	end

print("Register Tools "..toolDef.description.." [OK]")

end


-- stone tools

bk_game.register_tools("stone", {
	source = "default:cobble",
	description = "Stone",
	times= {[4] = 5.00,[5] = 3.50, [6]=1.80,},
	uses = 20,
	level = 5,
})

-- The hand

minetest.register_item(":", {
	type = "none",
	wield_image = "wieldhand.png",
	wield_scale = {x=1,y=1,z=2.5},
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			crumbly = {times={ [6]=2.50,}, uses=0, maxlevel=1},
			snappy = {times={[6]=2.50}, uses=0, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=6.00,[2]=3.00,[3]=1.50}, uses=0, maxlevel=2}
		},
		damage_groups = {fleshy=1},
	}
})

-- Wood/Stick tools

	bk_game.register_tools("wood", {
		description = "Wood",
		source = "group:planks", -- wood tools craft only from stick`s!
		times = {[5] = 4.00, [6]=2.50,},
		uses = 10,
		sword = false, -- no wood sword
		maxlevel = 5,
	})

-- Adamant Pick, can dig all

		minetest.register_tool("tools:pick_adamant", {
			description = "Adamant Pickaxe",
			inventory_image = "tools_pick_adamant.png",
			tool_capabilities = {
				full_punch_interval = 0.20,
				max_drop_level=8,
				groupcaps={
					cracky = {times={ [1]=0.80, [2]=0.80, [3]=0.80, [4]=0.80, [5]=0.80, [6]=0.80, } , uses=65535, maxlevel=6},
					crumbly = {times={ [1]=0.80, [2]=0.80, [3]=0.80, [4]=0.80, [5]=0.80, [6]=0.80, } , uses=65535, maxlevel=6},
					choppy = {times={ [1]=0.80, [2]=0.80, [3]=0.80, [4]=0.80, [5]=0.80, [6]=0.80, } , uses=65535, maxlevel=6},
					snappy = {times={ [1]=0.80, [2]=0.80, [3]=0.80, [4]=0.80, [5]=0.80, [6]=0.80, } , uses=65535, maxlevel=6},
				},
				damage_groups = {cracky=8},
			},
		})
		minetest.register_craft({
			output = "tools:pick_adamant",
			recipe = {
				{"metals:adamant_ingot", "metals:adamant_ingot", "metals:adamant_ingot"},
				{"", "group:stick", ""},
				{"", "group:stick", ""},
			}
		})

-- Adamant Hoe, indestructible

		minetest.register_tool(":tools:hoe_adamant", {
			description = "Adamant Hoe",
			inventory_image = "tools_hoe_adamant.png",
			on_use = function(itemstack, user, pointed_thing)
				-- check if pointing at a node
				if pointed_thing.type ~= "node" then
					return
				end

				local under = minetest.get_node(pointed_thing.under)
				local p = {x=pointed_thing.under.x, y=pointed_thing.under.y+1, z=pointed_thing.under.z}
				local above = minetest.get_node(p)

				-- return if any of the nodes is not registered
				if not minetest.registered_nodes[under.name] then
					return
				end
				if not minetest.registered_nodes[above.name] then
					return
				end

				-- check if the node above the pointed thing is air
				if above.name ~= "air" then
					return
				end

				-- check if pointing at dirt
				if minetest.get_item_group(under.name, "soil") ~= 1 then
					return
				end

				-- turn the node into soil, wear out item and play sound
				minetest.set_node(pointed_thing.under, {name="flowers:soil"})
				return itemstack
			end,
		})
		minetest.register_craft({
			output = "tools:hoe_adamant",
			recipe = {
				{"metals:adamant_ingot", "metals:adamant_ingot", ""},
				{"", "group:stick", ""},
				{"", "group:stick", ""},
			}
		})

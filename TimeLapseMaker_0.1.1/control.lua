require( "defines" )

-------------------------------
-- Tables to keep track of data
-------------------------------
local TimeLapses = {}
-------------------------------
-- Helper functions
-------------------------------

local function FindByName (arr, name)
	for i, v in ipairs(arr) do
		if arr.name == name then
			return i
		end
	end
	return nil
end

-------------------------------
-- Button callbacks
-------------------------------

--add new
local function addTimeLapse(event)
	game.get_player(event.player_index).gui.left["TimeLapseMaker_MainMenu_frame"].destroy()
	local centerGUI = game.get_player(event.player_index).gui.center
	if not centerGUI["TimeLapseMaker_AddNew_frame"] then
		local AddMenu = centerGUI.add({
			type = "frame",
			caption = "Add New TimeLapse",
			direction = "vertical",
			name = "TimeLapseMaker_AddNew_frame"
		})
		
		AddMenu.add{
			type = "label",
			name = "info",
			caption = "The Images will be taken from your current position"
		}
		
		NameFlow = AddMenu.add{
			type = "flow",
			direction = "horizontal",
			name = "TimeLapseMaker_Name_flow"
		}
		
		NameFlow.add{
			type = "label",
			caption = "Name of This TimeLapse",
			name = "TimeLapseMaker_Name_label"
		}
		
		NameFlow.add{
			type = "textfield",
			name = "TimeLapseMaker_Name_textfield"
		}
		
		PathFlow = AddMenu.add{
			type = "flow",
			direction = "horizontal",
			name = "TimeLapseMaker_Path_flow"
		}
		
		PathFlow.add{
			type = "label",
			caption = "Folder for screenshots",
			name = "TimeLapseMaker_Path_label"
		}
		
		PathFlow.add{
			type = "textfield",
			name = "TimeLapseMaker_Path_textfield"
		}
		
		DelayFlow = AddMenu.add{
			type = "flow",
			direction = "horizontal",
			name = "TimeLapseMaker_Delay_flow"
		}
		
		DelayFlow.add{
			type = "label",
			caption = "Time Between Screenshots (sec)",
			name = "TimeLapseMaker_Delay_label"
		}
		
		DelayFlow.add{
			type = "textfield",
			name = "TimeLapseMaker_Delay_textfield"
		}
		
		ZoomFlow = AddMenu.add{
			type = "flow",
			direction = "horizontal",
			name = "TimeLapseMaker_Zoom_flow"
		}
		
		ZoomFlow.add{
			type = "label",
			caption = "Zoom Level (all the way in = 3, all the wat out = 0.18",
			name = "TimeLapseMaker_Zoom_label"
		}
		
		ZoomFlow.add{
			type = "textfield",
			name = "TimeLapseMaker_Zoom_textfield"
		}
		
		DurationFlow = AddMenu.add{
			type = "flow",
			direction = "horizontal",
			name = "TimeLapseMaker_Duration_flow"
		}
		
		DurationFlow.add{
			type = "label",
			caption = "duration (sec)(0 = forever)",
			name = "TimeLapseMaker_Duration_label"
		}
		
		DurationFlow.add{
			type = "textfield",
			name = "TimeLapseMaker_Duration_textfield"
		}
		
		AltModeFlow = AddMenu.add{
			type = "flow",
			direction = "horizontal",
			name = "TimeLapseMaker_AltMode_flow"
		}
		
		AltModeFlow.add{
			type = "checkbox",
			state = false,
			name = "TimeLapseMaker_AltMode_checkbox"
		}
		
		AltModeFlow.add{
			type = "label",
			caption = "Show Entity Info? (Alt-Mode)",
			name = "TimeLapseMaker_AltMode_label"
		}
		
		ButtonFlow = AddMenu.add{
			type = "flow",
			direction = "horizontal",
			name = "TimeLapseMaker_Buttons_flow"
		}
		
		ButtonFlow.add{
			type = "button",
			caption = "Accept",
			name = "TimeLapseMaker_AcceptNew"
		}
		
		ButtonFlow.add{
			type = "button",
			caption = "Cancel",
			name = "TimeLapseMaker_CancelNew"
		}
	end
end

local function AcceptNew(event)

	local ply = game.get_player(event.player_index)
	local frame = ply.gui.center["TimeLapseMaker_AddNew_frame"]
	local nm = frame["TimeLapseMaker_Name_flow"]["TimeLapseMaker_Name_textfield"].text
	local zm = tonumber( frame["TimeLapseMaker_Zoom_flow"]["TimeLapseMaker_Zoom_textfield"].text)
	local pth = frame["TimeLapseMaker_Path_flow"]["TimeLapseMaker_Path_textfield"].text
	local del = tonumber(frame["TimeLapseMaker_Delay_flow"]["TimeLapseMaker_Delay_textfield"].text)
	local dur = tonumber(frame["TimeLapseMaker_Duration_flow"]["TimeLapseMaker_Duration_textfield"].text)
	local alt = frame["TimeLapseMaker_AltMode_flow"]["TimeLapseMaker_AltMode_checkbox"].state
	local pos = ply.position
	
	if not nm or nm == "" then
		ply.print("invalid name")
	elseif FindByName(TimeLapses, nm)	then
		ply.print("Name already used")
	elseif not zm or zm <= 0 then
		ply.print("invalid zoom")
	elseif not pth or path == "" then
		ply.print("invalid path")
	elseif not del or del <= 0 then
		ply.print("invalid delay")
	elseif not dur or dur < 0 then
		ply.print("invalid duration")
	else 
		table.insert(TimeLapses, {
			path = pth,
			delay = math.floor(del * 60 + .5),
			duration = math.floor(dur * 60 + .5),
			zoom = zm,
			altMode = alt,
			position = pos,
			name = nm,
			start = game.tick
		})
		frame.destroy()
	end
end

local function CancelNew(event)
	game.get_player(event.player_index).gui.center["TimeLapseMaker_AddNew_frame"].destroy()
end

local function MainMenu(event)
	local ply = game.get_player(event.player_index)
	if ply.gui.left["TimeLapseMaker_MainMenu_frame"] then
		ply.gui.left["TimeLapseMaker_MainMenu_frame"].destroy()
	else
		local Menu = ply.gui.left.add({
			type = "frame",
			caption = "TimeLapses",
			direction = "vertical",
			name = "TimeLapseMaker_MainMenu_frame"
		})
		
		Menu.add{
			type = "button",
			caption = "Add New",
			name = "TimeLapseMaker_MainMenu_AddNew"
		}
		
		local List = Menu.add{
			type = "flow",
			direction = "vertical",
			name = "TimeLapseMaker_MainMenu_Listflow"
		}
		
		for i, v in ipairs(TimeLapses) do
			local flow = List.add{
				type = "flow",
				direction = "horizontal",
				name = "TimeLapseMaker_" .. i .. "_flow"
			}
			flow.add{
				type = "button",
				caption = "x",
				name = "TimeLapseMaker_" .. i .. "_delete",
				index = i
			}
			flow.add{
				type = "label",
				caption = v.name,
				name = "TimeLapseMaker_" .. i .. "_label"
			}
		end			
	end
end

local function deleteTimeLapse (event)
	table.remove(TimeLapses, event.element.index)
	event.element.parent.destroy()
end

-------------------------------
-- Update gui
-------------------------------

-------------------------------
-- Main menu
-------------------------------

-------------------------------
-- Events
-------------------------------

script.on_event( defines.events.on_player_created, function( event )
	game.get_player( event.player_index ).gui.left.add{
		type = "button",
		caption = "TimeLapses",
		name = "TimeLapseMaker_MainMenu"
	}
end)

local gui_element_callbacks = {
	TimeLapseMaker_MainMenu_AddNew = addTimeLapse,
	TimeLapseMaker_AcceptNew = AcceptNew,
	TimeLapseMaker_CancelNew = CancelNew,
	TimeLapseMaker_MainMenu = MainMenu
}

-- Handle callbacks
script.on_event(defines.events.on_gui_click ,function(event)
	local element_name = event.element.name

	for k,v in pairs( gui_element_callbacks ) do
		if string.find( element_name, k ) then
			v( event )
			return
		end
	end
	if string.find(element_name, "TimeLapseMaker_%d+_delete") then
		deleteTimeLapse(event)
		return
	end
end)

script.on_event(defines.events.on_tick, function(event)
	for i, v in ipairs(TimeLapses) do
		local dif = game.tick - v.start
		if dif % v.delay == 0 then
			game.take_screenshot{
				position = v.position,
				zoom = v.zoom,
				path = v.path .. "\\" .. string.format("%03d", dif / v.delay ) .. ".png",
				show_entity_info = v.altMode
			}
		end
		if not v.duration == 0 and dif >= v.duration then -- if duration is 0, never remove it
			table.remove(TimeLapses, i)
		end
	end
end)
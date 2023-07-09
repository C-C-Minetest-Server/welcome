local MN = minetest.get_current_modname()
local MP = minetest.get_modpath(MN)
local FORMSPEC_PATH = MP .. "/formspec/"

local function load_formspec(id)
	local f = io.open(FORMSPEC_PATH .. tostring(id) .. ".txt")
	if not f then return nil end
	local form = f:read("*a")
	f:close()
	return form
end

local formspecs = {}
formspecs[1] = load_formspec(1)

minetest.register_chatcommand("welcome",{
	description = "Show welcome message",
	params = "[<Page ID>]",
	func = function(name, param)
		if param == "" then param = "1" end
		id = tonumber(param)
		if not formspecs[id] then
			return false, "Formspec Not Found!"
		end
		minetest.show_formspec(name, "welcome:form_" .. param, formspecs[id])
		minetest.chat_send_player(name,formspecs[id])
		return true, "Formspec's here."
	end,
})

minetest.register_chatcommand("welcome_reload",{
	description = "Reload welcome message",
	params = "<Page ID>",
	privs = {server = true},
	func = function(name, param)
		if param == "" then return false, "Please give me an ID!" end
		id = tonumber(param)
		formspecs[id] = load_formspec(id)
		return true, "Reloaded."
	end,
})

local config = json.load_file("BenchmarkCutsceneSkipper.json") or {
	enabled = true,
}
local configChanged
local function saveConfig()
	if not configChanged then return end
	json.dump_file("BenchmarkCutsceneSkipper.json", config)
	configChanged = false
end
re.on_config_save(saveConfig)

local DM = sdk.get_managed_singleton("app.DemoMediator")

sdk.hook(sdk.find_type_definition("app.DemoMediator"):get_method("isExistEventSkip"), function(args)
	if not config.enabled then return end
	DM:execSkip()
end)

sdk.hook(sdk.find_type_definition("app.GUI800202"):get_method("setupPanels"), function(args)
	if not config.enabled then return end
	local BMM = sdk.get_managed_singleton("app.BenchmarkManager")
	-- Adjust the score to compensate for the points lost from cutscenes
	BMM._score = BMM._score * 1.65
end)

re.on_draw_ui(function()
	local changed
	changed, config.enabled = imgui.checkbox("Skip Cutscenes", config.enabled)
	if changed then
		configChanged = true
	end
end)

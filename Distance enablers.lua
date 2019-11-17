local getui = ui.get
local checkbox = ui.new_checkbox
local slider = ui.new_slider
local setui = ui.set
local reference = ui.reference
local vis = ui.set_visible

local menu = {
	dtenable = checkbox("Rage", "Other", "Enable double tap at distance"),
	dtreverse = checkbox("Rage", "Other", "Double tap: reverse"),
	dtdistanceslider = slider("Rage", "Other", "Double tap: distance", 0, 1000, 0, true),

	osenable = checkbox("AA", "Other", "Enable on shot at distance"),
	osreverse = checkbox("AA", "Other", "On shot: reverse"),
	osdistanceslider = slider("AA", "Other", "On shot: distance", 0, 1000, 0, true),

	fsenable = checkbox("AA", "Other", "Enable freestanding at distance"),
	fsreverse = checkbox("AA", "Other", "Freestanding: reverse"),
	fsdistanceslider = slider("AA", "Other", "Freestanding: distance", 0, 1000, 0, true),

	hcenable = checkbox("Rage", "Other", "Change hit chance at distance"),
	hcdistancelider = slider("Rage", "Other", "Hit chance: distance", 0, 1000, 0, true),
	hcnormal = slider("Rage", "Other", "Hit chance: normal", 0, 100, 0, true),
	hcnew = slider("Rage", "Other", "Hit chance: new", 0, 100, 0, true),

	mdenable = checkbox("Rage", "Other", "Change min damage at distance"),
	mddistancelider = slider("Rage", "Other", "Min damage: distance", 0, 1000, 0, true),
	mdnormal = slider("Rage", "Other", "Min damage: normal", 0, 100, 0, true),
	mdnew = slider("Rage", "Other", "Min damage: new", 0, 100, 0, true),

	distancedebug = checkbox("Misc", "Settings", "Distance debug")
}

local dt, dtt = reference("Rage", "Other", "Double tap")
local os, ost = reference("AA", "Other", "On shot anti-aim")
local fs, fst = reference("AA", "Anti-aimbot angles", "Freestanding")
local hc = reference("Rage", "Aimbot", "Minimum hit chance")
local md = reference("Rage", "Aimbot", "Minimum damage")

--ROUNDING FUNCTION--
local function round(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0)

	if num >= 0 then return math.floor(num * mult + 0.5) / mult
	else 
		return math.ceil(num * mult - 0.5) / mult
	end
end

local function getNearestDist()
    local nearestDist
    local lp = entity.get_local_player()
    local myOrigin = Vector3(entity.get_prop(lp, "m_vecOrigin"))
    for _, player in ipairs(entity.get_players(true)) do
        local targetOrigin = Vector3(entity.get_prop(player, "m_vecOrigin"))
        local dist = myOrigin:dist_to(targetOrigin)
        if (nearestDist == nil or dist < nearestDist) then
            nearestDist = dist
        end
    end
    if (nearestDist ~= nil) then
        -- Source SDK: #define METERS_PER_INCH (0.0254f)
        local meters = nearestDist * 0.0254
        -- Convert to feet
        local feet = meters * 3.281
        return feet;
    end
end

local function paint(ctx)
	--DOUBLE TAP--
    if getui(menu.dtenable) then
    	vis(menu.dtreverse, true)
    	vis(menu.dtdistanceslider, true)

        if getNearestDist() ~= nil then
        	if getui(menu.dtreverse) then
	            if getNearestDist() <= getui(menu.dtdistanceslider) then
	            	renderer.indicator(255, 0, 0, 255, "DT")
	            	setui(dtt, "On hotkey")
	            else
	            	renderer.indicator(0, 255, 0, 255, "DT")
	                setui(dtt, "Always on")
	            end
	        else
	        	if getNearestDist() <= getui(menu.dtdistanceslider) then
	                renderer.indicator(0, 255, 0, 255, "DT")
	                setui(dtt, "Always on")
	            else
	            	renderer.indicator(255, 0, 0, 255, "DT")
	            	setui(dtt, "On hotkey")
	            end
	        end
        end
    else
    	vis(menu.dtreverse, false)
    	vis(menu.dtdistanceslider, false)

    	setui(dtt, "On hotkey")
    end

    --ON SHOT ANTI-AIM--
    if getui(menu.osenable) then
    	vis(menu.osreverse, true)
    	vis(menu.osdistanceslider, true)

    	if getNearestDist() ~= nil then
    		if getui(menu.osreverse) then
	            if getNearestDist() <= getui(menu.osdistanceslider) then
	            	renderer.indicator(255, 0, 0, 255, "OS")
	            	setui(ost, "On hotkey")
	            else
	            	renderer.indicator(0, 255, 0, 255, "OS")
	                setui(ost, "Always on")
	            end
	        else
	        	if getNearestDist() <= getui(menu.osdistanceslider) then
	                renderer.indicator(0, 255, 0, 255, "OS")
	                setui(ost, "Always on")
	            else
	            	renderer.indicator(255, 0, 0, 255, "OS")
	            	setui(ost, "On hotkey")
	            end
	        end
        end
    else
    	vis(menu.osreverse, false)
    	vis(menu.osdistanceslider, false)

    	setui(ost, "On hotkey")
    end

    --FREESTANDING--
    if getui(menu.fsenable) then
    	vis(menu.fsreverse, true)
    	vis(menu.fsdistanceslider, true)

    	if getNearestDist() ~= nil then
    		if getui(menu.fsreverse) then
	            if getNearestDist() <= getui(menu.fsdistanceslider) then
	            	renderer.indicator(255, 0, 0, 255, "FS")
	            	setui(fst, "On hotkey")
	            else
	            	renderer.indicator(0, 255, 0, 255, "FS")
	                setui(fst, "Always on")
	            end
	        else
	        	if getNearestDist() <= getui(menu.fsdistanceslider) then
	                renderer.indicator(0, 255, 0, 255, "FS")
	                setui(fst, "Always on")
	            else
	            	renderer.indicator(255, 0, 0, 255, "FS")
	            	setui(fst, "On hotkey")
	            end
	        end
        end
    else
    	vis(menu.fsreverse, false)
    	vis(menu.fsdistanceslider, false)

    	setui(fst, "On hotkey")
    end

    --HIT CHANCE--
    if getui(menu.hcenable) then
    	vis(menu.hcdistancelider, true)
    	vis(menu.hcnormal, true)
    	vis(menu.hcnew, true)

    	if getNearestDist() ~= nil then
            if getNearestDist() <= getui(menu.hcdistancelider) then
                renderer.indicator(0, 255, 0, 255, "HC")
                setui(hc, getui(menu.hcnew))
            else
            	renderer.indicator(255, 0, 0, 255, "HC")
            	setui(hc, getui(menu.hcnormal))
            end
        end
    else
    	vis(menu.hcdistancelider, false)
    	vis(menu.hcnormal, false)
    	vis(menu.hcnew, false)
    end

    --MINIMUM DAMAGE--
    if getui(menu.mdenable) then
    	vis(menu.mddistancelider, true)
    	vis(menu.mdnormal, true)
    	vis(menu.mdnew, true)

    	if getNearestDist() ~= nil then
            if getNearestDist() <= getui(menu.mddistancelider) then
                renderer.indicator(0, 255, 0, 255, "MD")
                setui(md, getui(menu.mdnew))
            else
            	renderer.indicator(255, 0, 0, 255, "MD")
            	setui(md, getui(menu.mdnormal))
            end
        end
    else
    	vis(menu.mddistancelider, false)
    	vis(menu.mdnormal, false)
    	vis(menu.mdnew, false)
    end

    --DEBUG--
    local w, h = client.screen_size()

    if getui(menu.distancedebug) then
    	if getNearestDist() ~= nil then
	    	client.log("Distance to nearest player: "..round(getNearestDist(), 2))
	    	renderer.text(w - 180, h - 20, 255, 255, 255, 255, "", 0, "Distance to nearest player: "..round(getNearestDist(), 2))
	    else
	    	client.log("Distance to nearest player: No player in range")
	    	renderer.text(w - 180, h - 20, 255, 255, 255, 255, "", 0, "Distance to nearest player: Nil")
	    end
    end
end

client.set_event_callback('paint', paint)

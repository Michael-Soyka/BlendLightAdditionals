local function SearchAddon(id)

	local addons = engine.GetAddons()

	for i, e in ipairs(addons) do
		if e.wsid == id then
			return e
		end
	end
end

addon = SearchAddon("2897972935")
if not addon then
    print("[BlendLight additionals for mappers]: It seems you don't install https://steamcommunity.com/sharedfiles/filedetails/?id=2897972935")
end
if not addon.mounted then
    print("[BlendLight additionals for mappers]: It seems you don't enable https://steamcommunity.com/sharedfiles/filedetails/?id=2897972935")
end

local function getBLLightEnttityInfo(ent)
    BLEntTab[ent] = BLEntTab[ent] or {
        entity = ent,
        className = ent:GetClass(),
        keyValues = {}
    }
    return BLEntTab[ent]
end

local booleanConverter = function(hammerVal) return val == "1" end
local colorConverter = string.ToColor
local angleConverter = function(hammerAngle) 
    local p, y, r = string.match(hammerAngle, "(%d+)%s*(%d+)%s*(%d+)")
    return Angle(tonumber(p), tonumber(y), tonumber(r))
end
local numberConverter = tonumber

local blLightEntityKeyMethods = {
    bl_point = {
        On = {
            setter = "SetOn",
            converter = booleanConverter
        },
        _light = {
            setter = "SetColor",
            converter = colorConverter
        },
        LightSize = {
            setter = "SetLightSize",
            converter = numberConverter
        },
        Brightness = {
            setter = "SetBrightness",
            converter = numberConverter
        },
        ShadowSize = {
            setter = "SetShadow",
            converter = numberConverter
        },
        LightWorld = {
            setter = "SetLightWorld",
            converter = booleanConverter
        },
        LightModels = {
            setter = "SetLightModels",
            converter = booleanConverter
        }
    },
    bl_spot = {
        On = {
            setter = "SetOn",
            converter = booleanConverter
        },
        _light = {
            setter = "SetColor",
            converter = colorConverter
        },
        Angles = {
            setter = "SetAngles",
            converter = angleConverter
        },
        FOV = {
            setter = "SetLightFOV",
            converter = numberConverter
        },
        Distance = {
            setter = "SetDistance",
            converter = numberConverter
        },
        Brightness = {
            setter = "SetBrightness",
            converter = numberConverter
        },
    }
}

hook.Add( "EntityKeyValue", "SetRightProps", function( ent, key, value )
    local entMethods = blLightEntityKeyMethods[ent:GetClass()]
    if not entMethods then
        return
    end
    local keyMethod = entMethods[key]
    if not keyMethod then
        return
    end
    ent[keyMethod.setter](ent, keyMethod.converter(value))
end )

-- RIP Hairy cocks 2004 - 2023
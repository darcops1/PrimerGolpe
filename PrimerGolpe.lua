local addonName, addon = "PrimerGolpe", {}  

-- Variables para rastrear el inicio del combate  
local combatStartEvent = false  
local lastSpellName, lastTargetName  

-- Función para obtener el nombre del jugador que inició el combate  
local function GetAggressor()  
    return UnitName("player") -- En una versión avanzada, se puede expandir para grupos/bandas.  
end  

-- Detecta el hechizo/ataque usado antes del combate  
local function OnSpellCast(self, event, unit, spellName)  
    if unit == "player" and not combatStartEvent then  
        lastSpellName = spellName  
    end  
end  

-- Detecta el objetivo del ataque  
local function OnTargetChanged(self, event)  
    if UnitExists("target") and UnitCanAttack("player", "target") then  
        lastTargetName = UnitName("target")  
    end  
end  

-- Maneja el inicio/fin del combate  
local function OnCombatEvent(self, event)  
    if event == "PLAYER_REGEN_DISABLED" then  
        combatStartEvent = true  
        local aggressor = GetAggressor()  
        local spellUsed = lastSpellName or "Ataque cuerpo a cuerpo"  
        local target = lastTargetName or "Objetivo desconocido"  

        -- Mensaje en el chat  
        print(string.format(  
            "|cFFFF0000Combate iniciado|r por |cFF00FF96%s|r con |cFFFFFF00%s|r contra |cFFFFA500%s|r.",  
            aggressor, spellUsed, target  
        ))  

    elseif event == "PLAYER_REGEN_ENABLED" then  
        combatStartEvent = false  
        print("|cFF00FF00Combate terminado.|r")  
    end  
end  

-- Registramos eventos  
local frame = CreateFrame("Frame")  
frame:RegisterEvent("PLAYER_REGEN_DISABLED")  
frame:RegisterEvent("PLAYER_REGEN_ENABLED")  
frame:RegisterEvent("UNIT_SPELLCAST_SENT")  
frame:RegisterEvent("PLAYER_TARGET_CHANGED")  
frame:SetScript("OnEvent", function(self, event, ...)  
    if event == "UNIT_SPELLCAST_SENT" then  
        OnSpellCast(self, event, ...)  
    elseif event == "PLAYER_TARGET_CHANGED" then  
        OnTargetChanged(self, event)  
    else  
        OnCombatEvent(self, event)  
    end  
end)  

-- Mensaje de carga  
print("|cFF00FF00CombatLogger|r cargado. ¡Listo para registrar combates!")  
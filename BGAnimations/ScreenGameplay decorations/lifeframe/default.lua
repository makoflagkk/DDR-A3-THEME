local pn = ...

local function LifeFrame(pn)
	if _VERSION == "Lua 5.3" then
		return GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):LifeSetting() == 'LifeType_Battery'
	else
		return (GAMESTATE:PlayerIsUsingModifier(pn,'battery') or GAMESTATE:GetPlayMode() == 'PlayMode_Oni')
	end
end 

return Def.ActorFrame{
    InitCommand=function(s)
        s:xy(pn==PLAYER_1 and _screen.cx-231 or _screen.cx+229,SCREEN_TOP+23):draworder(99)
    end,
    Name="LifeFrame",
	Def.Sprite{
        Texture=THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/base"),
		InitCommand=function(s) s:x(pn==PLAYER_1 and -7 or 9):zoomto(296,20):diffusealpha(LifeFrame(pn) and 0 or 1) end,
	};
	Def.Sprite{
        Texture=THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/normal"),
		InitCommand=function(s) s:x(pn==PLAYER_1 and -8 or 10) end,
        OnCommand=function(s) s:scaletoclipped(296,20)
            :MaskDest():ztestmode("ZTestMode_WriteOnFail"):customtexturerect(0,0,1,1)
            :texcoordvelocity(pn=="PlayerNumber_P2" and 0.6 or -0.6,0)
        end,
        HealthStateChangedMessageCommand=function(self, param)
			if param.PlayerNumber == pn then
				if param.HealthState == "HealthState_Danger" then
					self:Load(THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/danger"))
				elseif param.HealthState == "HealthState_Hot" then
					self:Load(THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/full"))
		  		else
					self:Load(THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/normal"))
		  		end;
			end;
		end;
    };
	Def.Sprite{
        Name="LifeFrame"..pn,
        InitCommand=function(s) s:x(pn==PLAYER_1 and -3.97 or 6):zoom(0.667):rotationy(pn==PLAYER_2 and 180 or 0):y(-0.5) end,
        BeginCommand=function(self)
			if LifeFrame(pn) then
				self:Load(THEME:GetPathB("ScreenGameplay","decorations/lifeframe/"..Model().."life"))  
			else
				self:Load(THEME:GetPathB("ScreenGameplay","decorations/lifeframe/"..Model().."normal"))
			end;
        end
    };
};
SWEP.MaxLeanOffset = 16
SWEP.MaxLeanAngle = 15

function SWEP:ThinkLean()
    if self:GetOwner():KeyDown(IN_ALT1) then
        self:SetLeanState(-1)
    elseif self:GetOwner():KeyDown(IN_ALT2) then
        self:SetLeanState(1)
    else
        self:SetLeanState(0)
    end

    local maxleanfrac = 1

    if self:GetLeanState() != 0 then
        local tr = util.TraceHull({
            start = self:GetOwner():EyePos(),
            endpos = self:GetOwner():EyePos() + self:GetOwner():EyeAngles():Right() * self.MaxLeanOffset * self:GetLeanState(),
            filter = self:GetOwner(),
            maxs = Vector(1, 1, 1) * 4,
            mins = Vector(-1, -1, -1) * 4,
        })

        if tr.Hit then
            maxleanfrac = tr.Fraction * 0.5
        end
    end

    local amt = self:GetLeanAmount()
    local tgt = self:GetLeanState()

    if maxleanfrac < 1 then
        tgt = 0
    end

    amt = math.Approach(amt, tgt, FrameTime() * 10)
    amt = math.Clamp(amt, -maxleanfrac, maxleanfrac)

    self:SetLeanAmount(amt)

    self:DoPlayerModelLean()
end

function SWEP:GetLeanDelta()
    return self:GetLeanAmount()
end

function SWEP:GetLeanOffset()
    local amt = self:GetLeanDelta()

    return amt * self.MaxLeanOffset
end

function SWEP:DoCameraLean(pos, ang)
    local amt = self:GetLeanDelta()

    if amt == 0 then return pos, ang end

    local newpos = pos + ang:Right() * self:GetLeanOffset()

    ang:RotateAroundAxis(ang:Forward(), amt * self.MaxLeanAngle)

    return newpos, ang
end

local leanbone = "ValveBiped.Bip01_Spine1"

local leanang_left = Angle(3.5, 3.5, 0)
local leanang_right = Angle(3.5, 1, 0)

function SWEP:DoPlayerModelLean()
    local amt = self:GetLeanDelta()

    if amt == 0 then return end

    local bone = self:GetOwner():LookupBone(leanbone)

    if !bone then return end

    self:GetOwner():ManipulateBoneAngles(bone, (amt < 0 and leanang_left or leanang_right) * amt * self.MaxLeanAngle, false)
end
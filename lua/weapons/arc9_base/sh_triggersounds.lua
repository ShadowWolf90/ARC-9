function SWEP:ThinkTriggerSounds()
    if self:GetAnimLockTime() > CurTime() then return end
    if self:StillWaiting() then return end
    if self:SprintLock() then return end
    if self:GetSafe() then return end
    local owner = self:GetOwner()

    if owner:KeyReleased(IN_ATTACK) then
        local soundtab = {
            name = "triggerup",
            sound = self:RandomChoice(self:GetProcessedValue("TriggerUpSound", _, _, true)),
            channel = ARC9.CHAN_TRIGGER
        }

        self:PlayTranslatedSound(soundtab)
    elseif owner:KeyPressed(IN_ATTACK) then
        local soundtab = {
            name = "triggerdown",
            sound = self:RandomChoice(self:GetProcessedValue("TriggerDownSound", _, _, true)),
            channel = ARC9.CHAN_TRIGGER
        }

        self:PlayTranslatedSound(soundtab)
    end
end
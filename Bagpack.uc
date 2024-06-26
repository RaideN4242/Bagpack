class Bagpack extends KFWeapon;

#exec OBJ LOAD FILE=bagpack_t.utx package=ServerPerksDZ.bagpack_t


var int AddWeight;
var Name OldVeterancy;
var bool bAlreadyAdded, bAlreadySubstracted;

function Tick(float dt)
{
	local KFPlayerReplicationInfo KFPRI;
	if(Instigator!=none)
	{
		KFPRI=KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
		if(KFPRI!=none)
		{
			if(OldVeterancy!=KFPRI.ClientVeteranSkill.Name)
				bAlreadyAdded=false;
			if(!bAlreadyAdded)
			{
				KFHumanPawn(Instigator).MaxCarryWeight+=AddWeight;
				bAlreadyAdded=true;
				OldVeterancy=KFPRI.ClientVeteranSkill.Name;
			}
		}
	}
	Super.Tick(dt);
}

event Destroyed()
{
	if(!bAlreadySubstracted)
	{
		KFHumanPawn(Instigator).MaxCarryWeight-=AddWeight;
		bAlreadySubstracted=true;
	}
	Super.Destroyed();
}

simulated function Weapon WeaponChange(byte F, bool bSilent)
{
	if(Inventory == None)
		return None;
	else
		return Inventory.WeaponChange(F,bSilent);
}

simulated function WeaponTick(float dt)
{
	//Instigator.PendingWeapon=Weapon(self.Inventory);
	if(Role<ROLE_Authority)
	{
		Instigator.PendingWeapon = Instigator.Inventory.PrevWeapon(None, self);
		Log("self.Inventory"@Instigator.PendingWeapon);
		//BringUp(Instigator.PendingWeapon);
		Instigator.Weapon = Instigator.PendingWeapon;
		//Instigator.PendingWeapon;
		Instigator.Controller.ChangedWeapon();
	}
	Super.WeaponTick(dt);
}

defaultproperties
{
	FireModeClass(0)=Class'KFMod.NoFire'
	FireModeClass(1)=Class'KFMod.NoFire'
	InventoryGroup=5
	PickupClass=Class'BagpackPickup'
	ItemName="Bagpack"
	bKFNeverThrow=false
	bCanThrow=false
	Weight=0.00
	TraderInfoTexture=Texture'ServerPerksDZ.bagpack_t.trader_bagpack'
	Description="Bagpack, adds some weight"
	AddWeight=10
	Priority=1
}

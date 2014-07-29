package com.scaleform.hud
{
public class PlayerData
{
	// 武器のインベントリー		Set My Inventory in here
	private var weaponInv:Array = [0,1,2,3];
	
	// アクセサリーのインベントリー
	private var accessoryInv:Array = [0,0,0,1];
	
	// エンチャントのインベントリー
	private var enchantInv:Array = [8,9,10,11,12];
	
	// マテリアルのインベントリー
	private var materialInv:Array = [13];
	
	// 全体のインベントリー
	private var Inv:Array = [];
	
public function PlayerData()
{
	
}

public function setInv(inv:Array):void
{
	this.Inv = inv;
}

public function getInv():Array
{
	return this.Inv;
}

public function setWeaponInv(wInv:Array)
{
	this.weaponInv = wInv;
}

public function getWeaponInv():Array
{
	return this.weaponInv;
}

public function setAccessoryInv(aInv:Array)
{
	this.accessoryInv = aInv;
}

public function getAccessoryInv():Array
{
	return this.accessoryInv;
}

public function setMaterialInv(mInv:Array)
{
	this.materialInv = mInv;
}

public function getMaterialInv():Array
{
	return this.materialInv;
}

public function setEnchantInv(eInv:Array)
{
	this.enchantInv = eInv;
}

public function getEnchantInv():Array
{
	return this.enchantInv;
}


}
}

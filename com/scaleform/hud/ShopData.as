package com.scaleform.hud 
{ 
    import flash.events.Event; 
    import flash.net.URLLoader; 
    import flash.net.URLRequest; 
    import flash.net.URLVariables; 
    import flash.net.URLLoaderDataFormat; 
    import flash.text.TextField;
    import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	//timer
	import flash.utils.Timer;
	import flash.events.TimerEvent;

public class ShopData 
{ 
    /* ---------------------------------------- */
  
    // 表示する番号を入れておく物 
    private var WeaponData:Array;
    private var AccessoriesData:Array; 
    private var EnchantmentsData:Array; 
    private var MaterialData:Array; 
  
    // 全データ格納 
    private var Name:Array; 
    private var Price:Array;    
    private var Description:Array;  
	private var Viewshop:Array;
    
	// ループ用
	private var i:int = 0;
	
// コンストラクタ
public function ShopData():void
{
	
}

// お店のデータを全て入れる（全部の名前、全部の値段、全部の説明、表示するショップ）
public function allSetData(names:Array,price:Array,Description:Array,shopData:Array)
{
	this.Name  = names;
	this.Price = price;
	this.Description = Description;
	this.Viewshop = shopData;
}

// 表示する店のデータを返す
public function getViewShop()
{
	return this.Viewshop;
}
  
// すべての名前データを返す 
public function getAllName():Array
{ 
    return this.Name; 
} 
  
// すべての情報データを返す 
public function getAllDescription():Array
{ 
    return this.Description; 
} 
  
// すべての値段データを返す 
public function getAllPrice():Array
{ 
    for(i = 0; i < this.Price.length; i++) 
    { 
        // 数字なので数値に変換しておく 
        this.Price[i] = parseInt(this.Price[i]); 
    } 
    return this.Price; 
} 
  
} 
} 
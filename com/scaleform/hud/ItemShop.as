package com.scaleform.hud
{
	import flash.display.Stage;
	import flash.events.MouseEvent;

public class ItemShop extends BaseShop
{
	private var pData:PlayerInv;
	private var pInv:Array;
	
public function ItemShop(inv:Array)
{
	this.inv = inv;
}

// ボタンをクリックしたら
private function btClick(e:MouseEvent):void
{
	if (this.tmpSelectItem != -1)
	{
		this.shopBuy();
		this.tmpSelectItem = -1;
	}
}

private function shopBuy():void
{
	this.pData.buyAction(this.inv[this.tmpSelectItem]);
	this.detailsImg.view.text ="";
	this.allAlpha1();
}

//--publucメソッド--

public function setPlayerData(p:PlayerInv):void
{
	this.pData = p;
}

// 売るボタンをセットする
public function viewButton()
{
	this.button.name = "bt";
	this.cover.addChild(this.button);
	this.cover.getChildByName("bt").addEventListener(MouseEvent.CLICK,btClick);
	
	//ボタンの横幅がスクロール部分の横幅と同じならば 
	if(this.button.width == this.detailsImg.width)
	{
		this.cover.getChildByName("bt").x = this.posX;
	}
	else
	{
		this.cover.getChildByName("bt").x = this.posX + this.detailsImg.width / 6;
	}
	
	this.cover.getChildByName("bt").y = this.posY + this.cMask.height + this.detailsImg.height + this.button.height;
}

}
}
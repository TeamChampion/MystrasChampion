package com.scaleform.hud
{
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.display.SimpleButton;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.display.MovieClip;

public class PlayerInv extends BaseShop
{
	// お金を表示するために必要なものたち…
	private var moneyFi:TextField = new TextField();
	private var moneyFo:TextFormat= new TextFormat();
	private var money:int = 100000;
	
	// 装備ボタン
	private var equipmentImg:SimpleButton;
	
	// 装備中の物を表示する
	private var equippedFi:TextField = new TextField();
	private var equippedFo:TextFormat= new TextFormat();
	
	// 装備中のアイテムの番号
	private var equipped:int = -1;
	
	// 元の値段 \ SAIL_DISCONTED = 売る値段(2の倍数推奨）
	private var SAIL_DISCONTED = 2;
	
	private var pData:PlayerData;

// インベントリーデータを設定
public function PlayerInv(inv:Array):void
{
	this.inv = inv;
}

// 売るボタンをセットする
public function viewButton()
{
	this.button.name = "bt";
	this.cover.addChild(this.button);
	this.cover.getChildByName("bt").addEventListener(MouseEvent.CLICK,btClick);
	this.cover.getChildByName("bt").x = this.posX;
	this.cover.getChildByName("bt").y = this.posY + this.cMask.height + this.detailsImg.height + this.button.height;
	
	// プレイヤーのお金を表示するよ
	this.viewPlayerMoney();
}

// ボタンをクリックしたら
private function btClick(e:MouseEvent):void
{
	if (this.tmpSelectItem != -1)
	{
		// 売ったときの処理
		this.money += this.itemPrice[this.inv[this.tmpSelectItem]];
		this.updateMoney();
		
		this.shopSell();
		this.tmpSelectItem = -1;
	}
}

private function shopSell():void
{
	this.deleteInv();
	// もし最後の一個を売ったら配列を初期化
	if(this.inv.length == 1)
	{
		this.inv = [];
	}
	else 
	{
		// そのアイテムを配列から消す
		this.inv.splice(this.tmpSelectItem,1);
	}
	// 詳細を消す
	this.detailsImg.view.text = "";	
	
	// 再描画
	this.viewContents(0);
	this.arrowPoint();
}

// 表示されているインベントリーを消す
private function deleteInv():void
{
	for (var i:int = 0; i < this.inv.length; i++)
	{
		this.cArea.removeChild(this.cArea.getChildByName("sp"+i));
		this.cArea.removeChild(this.cArea.getChildByName("mp"+i));
	}
	this.arrowPoint();
}

// お金を表示するテキストフィールドの設定
private function viewPlayerMoney():void
{
	// テキストの設定
	this.moneyFo.size = 25;
	this.moneyFo.font = "メイリオ";	
	this.moneyFi.defaultTextFormat = this.moneyFo;
	this.moneyFi.width = 300;
	this.moneyFi.height= 300;
	this.moneyFi.selectable = false;
	
	// 位置を決めるよ
	this.cover.addChild(moneyFi);
	moneyFi.x = this.button.width / 3;
	moneyFi.y = this.button.y + this.button.height;
	
	// 文字を入れるよ
	this.updateMoney();
}

// お金の更新をするよ
private function updateMoney():void
{
	this.moneyFi.text = "your money is :"+ this.money;
}

// 装備中の物を表示するためのテキストフィードを用意
private function viewEquipped()
{
	// テキストの設定
	this.equippedFo.size = 30;
	this.equippedFo.font = "メイリオ";	
	this.equipmentImg.enabled = true;
 	this.equippedFi.defaultTextFormat = this.equippedFo;
	this.equippedFi.width = 300;
	this.equippedFi.height= 100;
	this.equippedFi.selectable = false;
	
	// 位置を決めるよ
	this.cover.addChild(equippedFi);
	equippedFi.x = this.equipmentImg.x;
	equippedFi.y = this.equipmentImg.y - this.equippedFi.height;
	
	// 文字を入れる
	this.updateEquipped();
}

private function updateEquipped()
{
	if(this.equipped != -1)
	{
		this.equippedFi.text = "装備中\n"+ this.itemName[this.equipped];
	}
}

//--publucメソッド--

// 買うときの処理
public function buyAction(num:int):void
{
	this.deleteInv();
	
	// お金が足りていれば
	if(this.itemPrice[num] * this.SAIL_DISCONTED <= this.money)
	{
		// 買ったアイテムの番号を入れる
		this.inv.push(num);
		this.money -= this.itemPrice[num] * this.SAIL_DISCONTED;
		this.updateMoney();
	}
	else 
	{
		this.moneyFi.text = "your money is :"+ this.money+ "\nお金が足りません";
	}
	
	
	// 再描画
	if(this.cAreaImg.height * this.inv.length <= this.cMask.height)
	{
		this.viewContents(0);
	}
	else
	{
		this.viewContents(-(this.cAreaImg.height * this.inv.length - this.cMask.height));
	}
	this.arrowPoint();
}

// 売り値変更
public function sailPrice():void
{
	for(var i:int = 0; i < this.itemPrice.length; i++)
	{
		this.itemPrice[i] /= this.SAIL_DISCONTED;
	}
}

// 装備ボタンの画像を設定
public function setEquipmentImg(img:SimpleButton):void
{
	this.equipmentImg = img;
}

// 装備ボタンの表示位置と座標を設定
public function addEquipmentImg(x:int,y:int):void
{
	this.equipmentImg.name = "eq";
	this.cover.addChild(this.equipmentImg);
	this.cover.getChildByName("eq").x = x;
	this.cover.getChildByName("eq").y = y;
	this.cover.getChildByName("eq").addEventListener(MouseEvent.CLICK,equipmentAction);
	
	// 装備中の物を表示するテキストフィールドの用意
	this.viewEquipped();
}

//装備ボタンの動作
public function equipmentAction(e:MouseEvent):void
{
	// 選択したインベントリーがnullじゃなかったら
	if(this.inv[this.tmpSelectItem] != null)
	{
		// 選択している位置のアイテムの番号をとります
		this.equipped = this.inv[this.tmpSelectItem];
		this.updateEquipped();
	}
}

// UDKから装備中のアイテム番号を受け取る
public function setEquipped(num:int)
{
	// -1なら装備していないので処理しない
	if(num != -1)
	{
		this.equipped = num;
	}
}

// 装備中のアイテムの番号を返す
public function getEquipped():int
{
	return this.equipped;
}


}
}
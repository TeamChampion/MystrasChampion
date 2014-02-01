package com.scaleform.hud
{
	import flash.text.TextField;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;

public class BaseShop
{
	protected var sd:ShopData;
	// マスク,エリア,選択された時の画像,タブ画像
	protected var cMask:Sprite = new Sprite();
	protected var cArea:Sprite = new Sprite();
	protected var cover:Sprite = new Sprite();
	
	// 詳細情報画面のx,y座標と座標が指定されているかを示すboolean
	protected var dX:int;
	protected var dY:int;
	protected var detailsSettingFlag:Boolean;
	
	// X座標,Y座標,maskの高さ
	protected var posX:int;
	protected var posY:int;
	protected var maskHe:int;
	
	// タブの文字
	protected var LeftString:String;
	protected var RightString:String;
	
	// 一時的に保存
	protected var tmpSelectItem:int = -1;
	
	// 画像の指定が必要なクラス
	protected var up:MovieClip;
	protected var down:MovieClip;
	protected var cAreaImg:MovieClip;
	protected var SelectBackGround:MovieClip;
	protected var tabImg:MovieClip;
	protected var detailsImg:MovieClip;
	protected var button:SimpleButton;

	
	// ファイルデータを一時的に保存
	protected var tmpcAreaImg:Class;
	protected var tmpSelectBackGround:Class;
	
	// お店のデータ
	protected var inv:Array;
	protected var itemName:Array;
	protected var itemPrice:Array;
	protected var itemDetails:Array;

protected function viewWindow():void
{
	this.createArea(this.posX,this.posY,this.cAreaImg.width,this.cAreaImg.height * this.inv.length);
	this.createMask(this.posX,this.posY,this.cAreaImg.width,this.maskHe);
	
	this.cArea.mask = this.cMask;
	// 中身を表示
	this.viewContents(0);
	// tabを表示
	this.tabView(this.LeftString,this.RightString);
	
	// ----矢印も配置する----
	up   = new UpAnime();
	down = new DownAnime();
	// ----------------------
		
	this.up.name   = "up";
	this.down.name = "down";
	this.cover.addChild(this.up);
	this.cover.addChild(this.down);
	
	this.cover.getChildByName("up").x   = ((this.cAreaImg.width / 2) - (this.up.width / 2 )) + this.posX;
	this.cover.getChildByName("up").y   = this.posY - this.up.height - this.tabImg.height;
	this.cover.getChildByName("down").x = ((this.cAreaImg.width / 2) - (this.up.width / 2 )) + this.posX;
	this.cover.getChildByName("down").y = (this.posY + this.cMask.height);
	
	this.cover.getChildByName("up").addEventListener(MouseEvent.CLICK,upClick);
	this.cover.getChildByName("down").addEventListener(MouseEvent.CLICK,downClick);
	
	// 矢印が表示できるか出来ないかを判定
	this.arrowPoint();
	
	// 武器詳細画面が入っていたら
	if(this.detailsImg != null)
	{
		// 情報を表示するウィンドウの設定
		this.detailsImg.name = "det";
		this.cover.addChild(this.detailsImg);
		if(this.detailsSettingFlag)
		{
			this.cover.getChildByName("det").x = dX; 
			this.cover.getChildByName("det").y = dY;
		}
		else
		{
			this.cover.getChildByName("det").x = this.posX;
			this.cover.getChildByName("det").y = this.posY + this.maskHe + this.down.height * 2;
		}
	}
}

// スクロールするコンテンツの表示
protected function viewContents(posY:int):void
{
	// 位置を戻す
	this.cArea.y = posY;
	
	for(var i:int = 0; i < this.inv.length; i++)
	{
		// -1以外ならアイテムがあるので表示する
		if( this.inv[i]!= -1)
		{
			// ----cAreaImgの中にテキストの背景の画像を入れる----
			cAreaImg         = new tmpcAreaImg();
			SelectBackGround = new tmpSelectBackGround();
			// --------------------------------------------------			
			this.SelectBackGround.name = "mp" + i;
			this.cAreaImg.name = "sp" + i;
			
			this.cArea.addChild(this.SelectBackGround);
			this.cArea.addChild(this.cAreaImg);
			
			// シングルクリックにする場合はコメントアウトを取り、下のをコメントアウトにする
			this.cArea.getChildByName("sp"+i).addEventListener(MouseEvent.CLICK,clickAC);
			//this.cArea.getChildByName("sp"+i).addEventListener(MouseEvent.DOUBLE_CLICK,clickAC);
			
			this.cArea.getChildByName("sp"+i).addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelAC);
			this.cArea.getChildByName("sp"+i).addEventListener(MouseEvent.MOUSE_OVER,mouseOverAC);
			this.cArea.getChildByName("sp"+i).addEventListener(MouseEvent.MOUSE_OUT,rmViewDetails);
			
			// --ダブルクリックを取得するのに必要--
			//this.cAreaImg.doubleClickEnabled = true;
			//this.cAreaImg.mouseChildren = false;
			// --シングルクリックにする場合は上２つをコメントアウト--
			
			/* 表示される文字はこちら
			   cAreaImgに入れた画像に[textArea]と[priceArea]というインスタンスの
			   テキストフィールドを作成する必要がある（値を変えれば変更可能） */
			this.cAreaImg.textArea.text  = this.itemName[this.inv[i]];
			this.cAreaImg.priceArea.text = this.itemPrice[this.inv[i]];
			this.SelectBackGround.textArea.text = "選択";
		}
	}
	// Yの初期位置
	var moveY:int = 0;
	
	// 表示した物を配置させる
	for(i = 0; i < this.inv.length; i++)
	{
		this.cArea.getChildByName("sp"+i).x = this.posX;
		this.cArea.getChildByName("sp"+i).y = moveY + this.posY; 
		
		this.cArea.getChildByName("mp"+i).x = this.posX;
		this.cArea.getChildByName("mp"+i).y =  moveY + this.posY;
		moveY += this.cAreaImg.height;
	}
	
}

// クリックされた時
protected function clickAC(e:MouseEvent):void
{
	// 画像が表示されていたら非表示に（つまり選択されたことに）
	if(cArea.getChildByName(e.currentTarget.name).alpha == 1)
	{
		this.allAlpha1();
		cArea.getChildByName(e.currentTarget.name).alpha = 0;
		// 一時的にインスタンス名を保存し数値だけを取る
		var a1:String = e.currentTarget.name;
		var a2:String = a1.split("sp").join("");
		var a:int = parseInt(a2);
		// なにが選択されたか保持
		this.tmpSelectItem = a;
	}
	else
	{
		cArea.getChildByName(e.currentTarget.name).alpha = 1;
		this.tmpSelectItem = -1;
	}
}

// すべてを表示
protected function allAlpha1():void
{
	for(var i:int = 0; i < this.inv.length; i++)
	{
		cArea.getChildByName("sp"+i).alpha = 1;
	}
}

// マウスオーバーしたとき
protected function mouseOverAC(e:MouseEvent):void
{
	// 一時的にインスタンス名を保存し数値だけを取る
	var a1:String = e.currentTarget.name;
	var a2:String = a1.split("sp").join("");
	var a:int = parseInt(a2);
	this.viewDetails(a);
}
// マウスオーバーしたときに武器情報を変える
protected function viewDetails(num:int):void
{
	/* detailsImgに設定した画像の中に[view]というインスタンス名の
	　テキストフィールドを用意すること */
	this.detailsImg.view.text = this.itemDetails[this.inv[num]];
}

// マウスオーバーの範囲外に出た時に作動
protected function rmViewDetails(e:MouseEvent):void
{
	if(this.tmpSelectItem == -1)
	{
		this.detailsImg.view.text ="";
	}
	else
	{
		this.detailsImg.view.text = this.itemDetails[this.inv[this.tmpSelectItem]];
	}
}

// スクロールしたとき
protected function mouseWheelAC(e:MouseEvent):void
{
	// 上にスクロールされたら
	if(0 < e.delta)
	{
		// 上に動かせるかどうか
		if(this.cArea.y < 0) // 0以下なら～
		{
			this.cArea.y += this.cAreaImg.height;
			this.arrowPoint();
		}
	}
	// 下の場合
	else
	{
		if(-this.cArea.y < ((this.cAreaImg.height * this.inv.length) - this.cMask.height))
		{
			this.cArea.y -= this.cAreaImg.height;
			this.arrowPoint();
		}
	}
}

// 矢印が表示されるかされないか
protected function arrowPoint():void
{
	// 上にスクロールできないならば上の矢印は非表示
	if(this.cArea.y == 0)
	{
		this.cover.getChildByName("up").alpha = 0;
	}
	else 
	{
		this.cover.getChildByName("up").alpha = 1;
	}
	// 下にスクロールできないならば下の矢印は非表示
	if(this.cMask.height >= this.cAreaImg.height * this.inv.length || this.cArea.y == -(this.cAreaImg.height * this.inv.length - this.cMask.height)) 
	{
		this.cover.getChildByName("down").alpha = 0;
	}
	else 
	{
		this.cover.getChildByName("down").alpha = 1;
	}
}

// 上矢印をクリックしたら
protected function upClick(e:MouseEvent):void
{
	if(this.cArea.y < 0) // 0以下なら～
	{
		this.cArea.y += this.cAreaImg.height;
		this.arrowPoint();
	}
}

// 下矢印をクリックしたら
protected function downClick(e:MouseEvent):void
{
	if(-this.cArea.y < ((this.cAreaImg.height * this.inv.length) - this.cMask.height  || this.cAreaImg.height * this.inv.length < this.cMask.height))
	{
		this.cArea.y -= this.cAreaImg.height;
		this.arrowPoint();
	}
}

// ---- ※beginFillを消さないこと（正常に動きません） ----
protected function createMask(x:int,y:int,wi:int,he:int):void
{
	this.cMask.graphics.beginFill(0xff0000,0);
	this.cMask.graphics.drawRect(x,y,wi,he);
	this.cover.graphics.drawRect(x,y,wi,he);
}

protected function createArea(x:int,y:int,wi:int,he:int):void
{
	this.cArea.graphics.beginFill(0x00ff00,0);
	this.cArea.graphics.drawRect(x,y,wi,he);
}
// -------------------------------------------------------

// tabを表示
protected function tabView(L:String,R:String):void
{
	/* tabImgの画像の中に
	cAreaImgに入れた画像に[textArea]と[priceArea]というインスタンスの
	テキストフィールドを作成する必要がある（値を変えれば変更可能） */
	tabImg.textArea.text = L;
	tabImg.priceArea.text= R;
	
	this.tabImg.name = "tab";
	this.cover.addChild(tabImg);
	this.cover.getChildByName("tab").x = this.posX;
	this.cover.getChildByName("tab").y = this.posY - this.tabImg.height;
}

//--publucメソッド--

// 表示位置を指定
public function setXY(px:int,py:int):void
{
	this.posX = px;
	this.posY = py;
}

// maskの画像の高さの指定（横は自動調整される）
public function setMaskHe(he:int):void
{
	this.maskHe = he;
}

// スクロールの画像
public function getInv():Sprite
{
	return this.cArea;
}

// 矢印とかボタンとか
public function getSub():Sprite
{
	return this.cover;
}

// 武器詳細画面の設定(設定しておかないと詳細画面は表示されない)
public function setDetailsImg(img:MovieClip):void
{
	this.detailsImg = img;
}

// tabに表示される文字の設定（L左側、R右側）
public function setTabSring(L:String,R:String):void
{
	this.LeftString = L;
	this.RightString= R;
}

// テキストを表示するエリアの画像
public function setcAreaImg(img:MovieClip):void
{
	this.cAreaImg = img;
	this.tmpcAreaImg = this.cAreaImg.constructor;
}

// タブの画像
public function setTabImg(img:MovieClip):void
{
	this.tabImg = img;
}

// クリックした後の画像
public function setSelectBackGround(img:MovieClip):void
{
	this.SelectBackGround = img
	this.tmpSelectBackGround = this.SelectBackGround.constructor;
}

// スクロールさせるところを作るよ
public function createInv():void
{
	this.viewWindow();
}

// ボタンをセットするよ
public function setButton(b:SimpleButton):void
{
	this.button = b;
}

// データを読み込み格納
public function setShopData(s:ShopData):void
{
	this.sd = s;	
	this.itemName    = sd.getAllName();
	this.itemPrice   = sd.getAllPrice();
	this.itemDetails = sd.getAllDescription();
}

public function setDetailXY(x:int,y:int):void
{
	this.dX = x;
	this.dY = y;
	this.detailsSettingFlag = true;
}

}
}
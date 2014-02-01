/**
 * スペルの処理をまとめています
 * ―――――――――――――――――――――――――――――――――――
 * ※
 * 座標指定の際+2と+1をしている場所があるが
 * これは表示位置がずれている為である。設置範囲が8*8の場合はこれらを排除する
 * ――――――――――――――――――――――――――――――――――― 
 * @author NakanishiMasahiro
 */
package com.scaleform.hud
{	
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flashx.textLayout.elements.ParagraphElement;
	import flash.geom.Point;

public class SpellAction
{
	
/**
 * @serial グローバル変数を設定
 */

public var iFirst:	int = 0;
public var iSecond:	int = 0;
public var iThird:	int = 0;
public var iForth:	int = 0;

// UDKで使う変数を呼び出すためのもの
private var gp:getFlashProperty = new getFlashProperty();

private var stg:Stage = null;
// スペルの画像を保存
private var spell:Array = 
	[
	 	// 学園系
	 	[
			new def_spells1(),
			new def_spells2(),
			new def_spells3(),
			new def_spells4(),
			new def_spells5()
		],
		// 火系
		[
		 	new s_fire1(),
			new s_fire2(),
			new s_fire3(),
			new s_fire4()
		],
		// 氷系
		[
		 	new s_ice1(),
			new s_ice2(),
			new s_ice3(),
			new s_ice4(),
			new s_ice5(),
			new s_ice6()
		],
		// 土系
		[
		 	new s_earth1(),
			new s_earth2(),
			new s_earth3(),
			new s_earth4(),
			new s_earth5(),
			new s_earth6()
		],
		// 毒系
		[
		 	new s_poison1(),
			new s_poison2(),
			new s_poison3(),
			new s_poison4()
		],
		// 雷系
		[
		 	new s_Thunder1(),
			new s_Thunder2(),
			new s_Thunder3()
		]
	];
	
// スペルのナンバーを保持	
private var spellNum:Array =
	[
	 	// 学園系
	 	[1,2,3,4,5],
		// 火系
		[6,7,8,9],
		// 氷系
		[10,11,12,13,14,15],
		// 土系
		[16,17,18,19,20,21],
		// 毒系
		[22,23,24,25],
		// 雷系
		[26,27,28]
	];

private var TOTAL_SPELL:int = 28;

// ２マス分の大きさがあるスペルのナンバーを昇順で保存
private var spellNumDoubleSize:Array = 
	[1,2,3,4,5,11,15,16,18,20,23,24,28];

// スペルが表示されているか（ 0 = False !0 = true)
private var spellSetFlag:Array =
	[
	 	// 学園系
	 	[0,0,0,0,0],
		// 炎系
		[0,0,0,0],
		// 氷系
		[0,0,0,0,0,0],
		// 土系
		[0,0,0,0,0,0],
		// 毒系
		[0,0,0,0],
		// 雷系
		[0,0,0]
	];

// 画像の番号を保存しておく為のもの coint(Category) numint(number)
private var coint:int  = -1;
private var numint:int = -1;

// 画像を表示していたら true
private var spellFlag = false;
// 画像を再設置のために動かしている場合は true
private var movedFlag = false;

// WinPanel参考インスタンス
private var WP:WinPanel;

//バックアップ用の配列
static private var backUp:Array = [[0,0,0,0,0,0,0,0],
							[0,0,0,0,0,0,0,0],
							[0,0,0,0,0,0,0,0],
							[0,0,0,0,0,0,0,0],
							[0,0,0,0,0,0,0,0],
							[0,0,0,0,0,0,0,0],
							[0,0,0,0,0,0,0,0],
							[0,0,0,0,0,0,0,0]];
//戻る確認で保持するための奴						
static private var agein:Array = [[0,0,0,0,0,0,0,0],
							[0,0,0,0,0,0,0,0],
							[0,0,0,0,0,0,0,0],
							[0,0,0,0,0,0,0,0],
							[0,0,0,0,0,0,0,0],
							[0,0,0,0,0,0,0,0],
							[0,0,0,0,0,0,0,0],
							[0,0,0,0,0,0,0,0]];
							
static private var NoFlag:Boolean = false;
/* ――――――――――――――――――――――――――――――――――― */

/**
 * 表示するステージを設定する
 * @param stg ステージを指定
 */
public function SpellAction(stg:Stage,wp)
{
	this.stg = stg;
	this.WP = wp;
}
//バックアップセットする関数
public function getBackUp():void
{
	for(var i:int = 0; i < 8;i++)
		for(var j:int = 0; j < 8;j++)
			backUp[i][j] = gp.spellData[i][j];
}

//バックアップのデータに戻す関数
public function returnBackUp():void
{
	for(var i:int = 0; i < 8;i++)
		for(var j:int = 0; j < 8;j++)
			gp.spellData[i][j] = backUp[i][j];
}
//もどるの確認でデータを保持するための奴
public function getAgein():void
{
	for(var i:int = 0; i < 8;i++)
		for(var j:int = 0; j < 8;j++)
			agein[i][j] = gp.spellData[i][j];
	NoFlag = true;
}

//agein配列の読み込み
public function returnAgein():void
{
	for(var i:int = 0; i < 8;i++)
		for(var j:int = 0; j < 8;j++)
		gp.spellData[i][j] = agein[i][j];
	NoFlag = false;
}

public function getNoFlag():Boolean
{
	if(NoFlag)
		return true;
	else
		return false;
}
public function setNoFlag(a:Boolean):void
{
	NoFlag = a;
}

/**
 * 設置したスペルのナンバーをgp.spellDataに入れる
 * @param he   設置した場所の縦の列番号
 * @param wi   設置した場所の横の列番号
 * @param size スペルの大きさ（１で１マス、２で２マス） 
 */
public function inputData(he:int,wi:int,size:int)
{
	if(size == 1)
	{
		gp.spellData[he][wi]     = spellNum[coint][numint];
	}
	else
	{
		gp.spellData[he][wi]     = spellNum[coint][numint];
		gp.spellData[he][wi + 1] = spellNum[coint][numint];
	}
}

/**
 * gp.spellDataに入っているナンバーを初期化する
 * @param he   初期化したい場所の縦の列番号
 * @param wi   初期化したい場所の横の列番号
 * @param size スペルの大きさ（１で１マス、２で２マス）
 */
public function inputDataDel(he:int,wi:int,size:int)
{
	if(size == 1)
	{
		gp.spellData[he][wi]     = 0;
	}
	else
	{
		gp.spellData[he][wi]     = 0;
		gp.spellData[he][wi + 1] = 0;
	}
}

/**
 * 設置のために一時的に表示する画像
 * @param coint  スペルのカテゴリー番号
 * @param numint スペルのナンバー
 * @param posx   デフォルトで表示するx座標
 * @param posy   デフォルトで表示するy座標
 */
 public function spellView(coint:int,numint:int,posx:int,posy:int)
{
	// 画像の情報を保持
	this.coint  = coint;
	this.numint = numint;
	
	// 表示しようとしているスペルが設置されていなければ表示する
	if(spellSetFlag[coint][numint] == 0)
	{
		// 画像を表示したのでtrueに
		spellFlag = true;
		
		stg.addChildAt(spell[coint][numint],stg.numChildren);
		
		setSpellPos(posx,posy);
	}
}

/** 
 * 画像を設置する
 * @param coint  スペルのカテゴリー番号
 * @param numint スペルのナンバー
 * @param posx   デフォルトで表示するx座標
 * @param posy   デフォルトで表示するy座標
 */
public function putInSpell(coint:int,numint:int,posx:int,posy:int)
{
	// 画像の情報を保持
	this.coint  = coint;
	this.numint = numint;
	
	// 設置するスペルの位置
	spell[coint][numint].x = posx;
	spell[coint][numint].y = posy;
	
	// スペルが設置されるので１を入れる
	this.spellSetFlag[coint][numint] = 1;
	
	stg.addChildAt(spell[coint][numint],stg.numChildren - 2);
	
	// Flagを初期化
	spellFlag  = false;
	movedFlag  = false;
}

/**
 * 設置するときに下にスペルが無いかどうか
 * @param  cx クリックした位置のx座標
 * @param  cy クリックした位置のy座標
 * @return Boolean true:置かれていない、flase:置かれている
 */
public function putInSpellFlag(cx:int,cy:int):Boolean
{
	if(gp.spellData[cy + WP.getHitFlagTop()][cx + WP.getHitFlagLeft()] == 0)
	{
		return true;
	}
	else
	{
		return false;
	}
}

/**
 * 画像の位置を設定
 * @param mx マウスのx座標
 * @param my マウスのy座標
 */
public function setSpellPos(mx:int, my:int)
{
	// ２マスのスキルか
	if(spellTypeCheck())
	{
		spell[coint][numint].x = mx - 20;
		spell[coint][numint].y = my - 40;
	}
	else
	{
		spell[coint][numint].x = mx - 40;
		spell[coint][numint].y = my - 40;	
	}
}

/** 
 * スキルが２マスのものか調べる
 * @return Boolean ２マス:true １マス:false
 */
public function spellTypeCheck() : Boolean
{
	// ２マスのスペルの番号かどうか調べる
	for(var i:int = 0; i <= spellNumDoubleSize.length - 1; i++)
	{
		 if(spellNum[coint][numint] == spellNumDoubleSize[i] )
		 {
			 return true;
		 }
	}
	return false;
}

/**
 * modeによって今の状態を取得する
 * @param flagMode 取得したい条件が正しければtrueを返す
 * @return Boolean 真:true 偽:false
 */
public function spellFlagCheck(flagMode:int):Boolean
{
	// １ならば画像を持っていない状態かどうか調べる
	if(flagMode == 1)
	{
		if(!spellFlag && !movedFlag)
		{
			return true;
		}
	}
	
	//２ならば再配置の為に画像を動かしているかどうかを調べる
	else if(flagMode == 2)
	{
		if(movedFlag)
		{
			return true;
		}
	}
	
	// ３ならば新しく設置するために画像を動かしているかどうか調べる
	else if(flagMode == 3)
	{
		if(spellFlag)
		{
			return true;
		}
	}
	// ４ならば画像をもっているかどうかを調べる
	else if(flagMode == 4)
	{
		if(spellFlag || movedFlag)
		{
			return true;
		}
	} 
	return false;
}

/**
 * クリックした場所にあるスキルの情報を取得
 * @param cx クリックした位置のx座標
 * @param cy クリックした位置のy座標
 */
public function checkSpell(cx:int,cy:int)
{
	// スペルの数分ループ
	for(var s = 6; s <= TOTAL_SPELL; s++)
	{
		// 0ならスペルは入っていないので抜け出す
		if(gp.spellData[cy + WP.getHitFlagTop()][cx + WP.getHitFlagLeft()] == 0) 
		{
			s = TOTAL_SPELL;
		}
		
		// スペルの番号を見つけ出す
		else if(gp.spellData[cy + WP.getHitFlagTop()][cx + WP.getHitFlagLeft()] == s)
		{
			stg.addChild(spellNumToSpell(s));
			
			// 設置データを初期化
			if(spellTypeCheck())
			{
				inputDataDel(cy + WP.getHitFlagTop(),cx + WP.getHitFlagLeft(),2);
			}
			else
			{
				inputDataDel(cy + WP.getHitFlagTop(),cx + WP.getHitFlagLeft(),1);
			}
			
			// 動かされたので0にする
			spellSetFlag[coint][numint] = 0;
			// 再設置中なのでtrueになる
			movedFlag = true;
		}
	}
}

/**
 * クリックした場所にあるスキルの番号を取得
 * @param cx クリックした位置のx座標
 * @param cy クリックした位置のy座標
 * @return スペルの番号
 */
public function checkSpellReturnNum(cx:int,cy:int):int
{
	// スペルの数分ループ
	for(var s = 6; s <= TOTAL_SPELL; s++)
	{
		// 0ならスペルは入っていないので抜け出す
		if(gp.spellData[cy + WP.getHitFlagTop()][cx + WP.getHitFlagLeft()] == 0) 
		{
			s = TOTAL_SPELL;
		}
		
		// スペルの番号を見つけ出す
		else if(gp.spellData[cy + WP.getHitFlagTop()][cx + WP.getHitFlagLeft()] == s)
		{
			return s;
		}
	}
	return -1;
}

/**
 * スペルの番号で画像を表示
 * (ついでに番号をcoint、numintに保存)
 * @param num        スペルのナンバー
 * @return MovieClip スペルの画像
 */
public function spellNumToSpell(num:int):MovieClip
{
	// 一時的に保存しておく配列番号
	var tmpx:int = -1;
	var tmpy:int = -1;
	switch(num)
	{
		// 学園系
		case 1:
		tmpx = 0;	tmpy = 0;
		break;
		case 2:
		tmpx = 0;	tmpy = 1;
		break;
		case 3:
		tmpx = 0;	tmpy = 2;
		break;
		case 4:
		tmpx = 0;	tmpy = 3;
		break;
		case 5:
		tmpx = 0;	tmpy = 4;
		break;
		
		// 炎系
		case 6:
		tmpx = 1;	tmpy = 0;
		break;
		case 7:
		tmpx = 1;	tmpy = 1;
		break;
		case 8:
		tmpx = 1;	tmpy = 2;
		break;
		case 9:
		tmpx = 1;	tmpy = 3;
		break;
		
		// 氷系
		case 10:
		tmpx = 2;	tmpy = 0;
		break;
		case 11:
		tmpx = 2;	tmpy = 1;
		break;
		case 12:
		tmpx = 2;	tmpy = 2;
		break;
		case 13:
		tmpx = 2;	tmpy = 3;
		break;
		case 14:
		tmpx = 2;	tmpy = 4;
		break;
		case 15:
		tmpx = 2;	tmpy = 5;
		break;
		
		// 土系のスキル
		case 16:
		tmpx = 3;	tmpy = 0;
		break;
		case 17:
		tmpx = 3;	tmpy = 1;
		break;
		case 18:
		tmpx = 3;	tmpy = 2;
		break;
		case 19:
		tmpx = 3;	tmpy = 3;
		break;
		case 20:
		tmpx = 3;	tmpy = 4;
		break;
		case 21:
		tmpx = 3;	tmpy = 5;
		break;
		
		// 毒系のスキル
		case 22:
		tmpx = 4;	tmpy = 0;
		break;
		case 23:
		tmpx = 4;	tmpy = 1;
		break;
		case 24:
		tmpx = 4;	tmpy = 2;
		break;
		case 25:
		tmpx = 4;	tmpy = 3;
		break;
		
		// 雷系のスキル
		case 26:
		tmpx = 5;	tmpy = 0;
		break;
		case 27:
		tmpx = 5;	tmpy = 1;
		break;
		case 28:
		tmpx = 5;	tmpy = 2;
		break;
	}
	this.coint  = tmpx;
	this.numint = tmpy;
	return spell[tmpx][tmpy];
}

// スペルの番号から設置に用いる番号を返す
public function spellNumToNum(num:int):Point
{
	// 一時的に保存しておく配列番号
	var tmpx:int = -1;
	var tmpy:int = -1;
	switch(num)
	{
		// 学園系
		case 1:
		tmpx = 0;	tmpy = 0;
		break;
		case 2:
		tmpx = 0;	tmpy = 1;
		break;
		case 3:
		tmpx = 0;	tmpy = 2;
		break;
		case 4:
		tmpx = 0;	tmpy = 3;
		break;
		case 5:
		tmpx = 0;	tmpy = 4;
		break;
		
		// 炎系
		case 6:
		tmpx = 1;	tmpy = 0;
		break;
		case 7:
		tmpx = 1;	tmpy = 1;
		break;
		case 8:
		tmpx = 1;	tmpy = 2;
		break;
		case 9:
		tmpx = 1;	tmpy = 3;
		break;
		
		// 氷系
		case 10:
		tmpx = 2;	tmpy = 0;
		break;
		case 11:
		tmpx = 2;	tmpy = 1;
		break;
		case 12:
		tmpx = 2;	tmpy = 2;
		break;
		case 13:
		tmpx = 2;	tmpy = 3;
		break;
		case 14:
		tmpx = 2;	tmpy = 4;
		break;
		case 15:
		tmpx = 2;	tmpy = 5;
		break;
		
		// 土系のスキル
		case 16:
		tmpx = 3;	tmpy = 0;
		break;
		case 17:
		tmpx = 3;	tmpy = 1;
		break;
		case 18:
		tmpx = 3;	tmpy = 2;
		break;
		case 19:
		tmpx = 3;	tmpy = 3;
		break;
		case 20:
		tmpx = 3;	tmpy = 4;
		break;
		case 21:
		tmpx = 3;	tmpy = 5;
		break;
		
		// 毒系のスキル
		case 22:
		tmpx = 4;	tmpy = 0;
		break;
		case 23:
		tmpx = 4;	tmpy = 1;
		break;
		case 24:
		tmpx = 4;	tmpy = 2;
		break;
		case 25:
		tmpx = 4;	tmpy = 3;
		break;
		
		// 雷系のスキル
		case 26:
		tmpx = 5;	tmpy = 0;
		break;
		case 27:
		tmpx = 5;	tmpy = 1;
		break;
		case 28:
		tmpx = 5;	tmpy = 2;
		break;
	}
	this.coint  = tmpx;
	this.numint = tmpy;
	return new Point(coint,tmpy);
}


/**
 * spellViewの画像を排除する
 */
public function removeView()
{
	// スペルが表示されているか再設置中でありそのスペルが表示されていたら画像を消す
	if(spellFlag || movedFlag && spell[coint][numint].stage != null)
	{
		stg.removeChild(spell[coint][numint]);
		spellFlag = false;
		movedFlag = false;
	}
}

/**
 * cointの中身を受け渡す
 * @return int cointの中身
 */
public function getCo():int
{
	return this.coint;
}

/**
 * numintの中身を受け渡す
 * @return int numintの中身
 */
public function getNum():int
{
	return this.numint;
}

/**
 * X座標のハーフサイズの中身を受け渡す
 * @return int ２マスなら80、１マスなら40
 */
public function getXHalfSize():int
{
	if(spellTypeCheck())
	{
		return 20;
	}
	else
	{
		return 40;
	}
}

/**
 * 画像を排除する（内部データは保存）
 */
public function removeSpell()
{
	for(var i = 0; i < 8; i++)
	{
		for(var j = 0; j < 8; j++)
		{
			// スペルの数分ループ
			for(var s = 1; s <= TOTAL_SPELL; s++)
			// 0ならスペルは入っていないので抜け出す
			if(gp.spellData[i][j] == 0)
			{
				s = TOTAL_SPELL;	
			}
			
			// スペルの番号を見つけ出す
			else if(gp.spellData[i][j] == s)
			{
				// すでに消していたら二重に消さないようにする
				if(spellNumToSpell(s).stage != null)
				{
					stg.removeChild(spellNumToSpell(s));
				}
			}
		}
	}
}


/** 
 * 画像を排除する（内部データも完全排除
 */
public function killSpell()
{
	for(var i = 0; i < 8; i++)
	{
		for(var j = 0; j < 8; j++)
		{
			// スペルの数分ループ
			for(var s = 1; s <= TOTAL_SPELL; s++)
			{
				// 0ならスペルは入っていないので抜け出す
				if(gp.spellData[i][j] == 0)
				{
					s = TOTAL_SPELL;
				}
				
				// スペルの番号を見つけ出す
				else if(gp.spellData[i][j] == s)
				{
					// 二列のスペルの場合
					if(gp.spellData[i][j] <= 5)
					{
						stg.removeChild(spellNumToSpell(s));
						gp.spellData[i][j]   = 0;
						gp.spellData[i][j+1] = 0;
					}
					else
					{
						stg.removeChild(spellNumToSpell(s));
						gp.spellData[i][j] = 0;
					}
				}
			}
		}
	}
}

// デバッグ用
public function debug():String
{
	var aaa:String = new String("");
	for(var i:int = 0; i < 8; i++)
	{
		aaa += (gp.spellData[i][0]+" "+gp.spellData[i][1]+" "+gp.spellData[i][2]+" "+gp.spellData[i][3]+" "+gp.spellData[i][4]+" "+gp.spellData[i][5]+" "+gp.spellData[i][6]+" "+gp.spellData[i][7]+"\n");
		//aaa += (backUp[i][0]+" "+backUp[i][1]+" "+backUp[i][2]+" "+backUp[i][3]+" "+backUp[i][4]+" "+backUp[i][5]+" "+backUp[i][6]+" "+backUp[i][7]+"\n");
	}
	return aaa;
}
public function debug2():String
{
	var aaa:String = new String("");
		// Uppe spells
		aaa += (gp.spellData[3][3]+" "+gp.spellData[3][4]+"\n");
		// Nere spells
		aaa += (gp.spellData[4][3]+" "+gp.spellData[4][4]+"\n");

	return aaa;
}

public function getFirstSpells():int
{
	//var aaa:String = new String("");
	// Uppe spells
	
	iFirst	+=	(gp.spellData[3][3]);
	iSecond	+=	(gp.spellData[3][4]);
	iThird	+=	(gp.spellData[4][3]);
	iForth	+=	(gp.spellData[4][4]);
		
		//aaa += (gp.spellData[3][3] + " " + gp.spellData[3][4]+"\n");
		// Nere spells
		//aaa += (gp.spellData[4][3] + " " + gp.spellData[4][4]+"\n");

	return iFirst, iSecond, iThird, iForth;
}

public function DrawField():void
{
	var countreturn:int = 0;
	
	var fieldSize:Point;
	fieldSize = WP.getF_loc();
	
	var spellSize:Point;
	spellSize = WP.getS_img();
	
	for(var i:int = 0;i < 8;i++)
	{
		for(var j:int = 0;j < 8;j++)
		{
			if(gp.spellData[i][j] != 0)
			{
				var tmpNum:Point = this.spellNumToNum(gp.spellData[i][j]);
				var tmp:MovieClip = new MovieClip();
				tmp = spellNumToSpell(gp.spellData[i][j]);
				tmp.name = "tmp" + countreturn;
				this.stg.addChild(tmp);
				this.stg.getChildByName("tmp" + countreturn).x = fieldSize.x + (spellSize.x * j);
				this.stg.getChildByName("tmp" + countreturn).y = fieldSize.y + (spellSize.y * i);
				
				if(this.doubleSpellCheck(i,j))
				{
					j++;
				}
				
				this.spellSetFlag[tmpNum.x][tmpNum.y] = 1;
				countreturn++;
			}
		}
	}
}

private function doubleSpellCheck(i:int,j:int):Boolean
{
	for(var ii:int = 0; ii < this.spellNumDoubleSize.length; ii++)
	{
		if(gp.spellData[i][j] == this.spellNumDoubleSize[ii])
		{
			return true;
		}
	}
	return false;
}

/* カテゴリーとスペル番号からIDを取り出す
	@param category カテゴリーナンバー
	@param num		ナンバー */
public function returnIDToSpell(category:int,num:int)
{
	return this.spellNum[category][num];
}
}
}

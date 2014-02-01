// フィールドの内部的処理

package  com.scaleform.hud
{	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.display.MovieClip;

public class WinPanel extends Sprite 
{
	/*スペルフィールドを置く座標(x,y)
	 *スペルの画像サイズ(x,y)
	 *スペルを置く場所の(縦,横)幅
	 */
	private var f_loc:Point   = new Point(630,250);	//ここは要変更 y値はフィールドデータを表示するための最低値です　この前は250が入ってました
	private var s_img:Point   = new Point(80,80);		//ここは画像なので固定
	private var s_block:Point = new Point(8,8);			//8*8ということでここも固定 前回までは6,4が入ってましtあ
	
	// スペルを置く場所の横と高さ（自動で設定されます）
	private var s_loc:Point;
	
	//プレイヤーのレベルを保持する
	private var p_lev:int = 3;
	
	//マップ作るときにつかうやつ
	private var pad_top:int  = 0;
	private var pad_left:int = 0;
	private var pad_right:int= 8;
	
	//paddingへのセッター
	public function setPadding(top:int,left:int,right:int):void
	{
		this.pad_top = top;
		this.pad_left = left;
		this.pad_right = right;
	}
	
	//あたり判定するときにつかうやつ
	private var hit_flg_top:int = 0;
	private var hit_flg_left:int = 0;	
	private var createPoint:int = 0;
	
	public function setHitFlg(top:int,left:int,point:int)
	{
		this.hit_flg_left = left;
		this.hit_flg_top = top;
		this.createPoint = point;
	}
	
	
	private var stg:Stage;
	private var type:int = 0;
	public  var mov:MovieClip;
	
	//レベルによってここの1(点滅しておける場所を示す箇所)を増やしたい
	public var fieldData = [
				  [0,0,0,0,0,0,0,0],
				  [0,0,0,0,0,0,0,0],
				  [0,0,0,0,0,0,0,0],
				  [0,0,0,1,1,0,0,0],
				  [0,0,0,1,1,0,0,0],
				  [0,0,0,0,0,0,0,0],
				  [0,0,0,0,0,0,0,0],
				  [0,0,0,0,0,0,0,0]
				 ];
/* ――――――――――――――――――――――――――――――――――― */
// スペルフィールドを初期化用意
public function WinPanel(stge:Stage) 
{		
	stg = stge;
}
	
// MAP初期化
public function initMap():void
{
	
	// スペルのフィールドのx,yを取得
	s_loc = new Point(s_img.x * s_block.x,s_img.y * s_block.y);
	
	// フィールドの画像を用意
	for(var i:int = 0; i< s_block.x * s_block.y; i++)
	{
		mov = new SpellField();
	    mov.name = "f"+i;
		stg.addChild(mov);
		stg.setChildIndex(mov,i);
		// スペルを置くことができるかどうか判定（０なら置けない）
		if(fieldData[this.pad_top][this.pad_left++] == 0)	mov.stop();
		
		if(this.pad_left == this.pad_right)
		{
			this.pad_top++;
			this.pad_left = this.createPoint;
			
		}
	}
	
	var tmp:int = 0;
	// stgに描写
	for(i = 0; i < s_block.y; i++)
	{
		for(var j:int = 0; j < s_block.x; j++)
		{
			stg.getChildByName("f"+tmp).x = f_loc.x + j * s_img.x;
			stg.getChildByName("f"+tmp).y = f_loc.y + i * s_img.y;
			tmp++;
		}
	}
	tmp = 0;
}

//ここにx,yで大きさを入れることで変更させる
private function Change_f_loc(x:int,y:int):void
{
	this.f_loc.x = x;
	this.f_loc.y = y;
}

//f_locの座標を返す
public function getF_loc():Point
{
	return this.f_loc;
}

public function getS_img():Point
{
	return this.s_img;
}



//ここにx,yで大きさを入れることで変更させる
private function Change_s_block(x:int,y:int):void
{
	this.s_block.x = x;
	this.s_block.y = y;
}


/**/
public function createSpell():void
{
	this.Change_f_loc(630,180);
	this.Change_s_block(6,4);
	this.setPadding(2,1,7);
	this.setHitFlg(this.pad_top,this.pad_left,1);
}
public function ChangeSpell():void
{
	this.Change_f_loc(500,50);
	this.Change_s_block(8,8);
}


//レベル関係のAcceccer
public function getLevel():int
{
	return this.p_lev;
}

public function setLevel(level:int):void
{
	this.p_lev = level;
}

//プレイヤーのレベルに合わせてfieldDataに1をぶっこんでいく
public function UpdatefieldData():void
{
	switch(this.p_lev)
	{
		case 1:
			fieldData[3][3] = 1;
			fieldData[3][4] = 1;
			fieldData[4][3] = 1;
			fieldData[4][4] = 1;
			break;
		case 2:
			fieldData[2][2] = 1;
			fieldData[2][5] = 1;
			fieldData[5][2] = 1;
			fieldData[5][5] = 1;
			break;
		case 3:
			fieldData[2][3] = 1;
			fieldData[2][4] = 1;
			fieldData[3][2] = 1;
			fieldData[3][5] = 1;
			fieldData[4][2] = 1;
			fieldData[4][5] = 1;
			fieldData[5][3] = 1;
			fieldData[5][4] = 1;
			break;
		case 4:
			fieldData[1][2] = 1;
			fieldData[1][5] = 1;
			fieldData[2][1] = 1;
			fieldData[2][6] = 1;
			fieldData[5][1] = 1;
			fieldData[5][6] = 1;
			fieldData[6][2] = 1;
			fieldData[6][5] = 1;
			break;
		case 5:
			fieldData[0][2] = 1;
			fieldData[0][5] = 1;
			fieldData[2][0] = 1;
			fieldData[2][7] = 1;
			fieldData[5][0] = 1;
			fieldData[5][7] = 1;
			fieldData[7][2] = 1;
			fieldData[7][5] = 1;
			break;
		case 6:
			fieldData[1][1] = 1;
			fieldData[1][6] = 1;
			fieldData[6][1] = 1;
			fieldData[6][6] = 1;
			break;
		case 7:
			fieldData[0][3] = 1;
			fieldData[0][4] = 1;
			fieldData[3][0] = 1;
			fieldData[3][7] = 1;
			fieldData[4][0] = 1;
			fieldData[4][7] = 1;
			fieldData[7][3] = 1;
			fieldData[7][4] = 1;
			break;
		case 8:
			fieldData[0][1] = 1;
			fieldData[0][6] = 1;
			fieldData[1][0] = 1;
			fieldData[1][7] = 1;
			fieldData[6][0] = 1;
			fieldData[6][7] = 1;
			fieldData[7][1] = 1;
			fieldData[7][6] = 1;
			break;
		case 9:
			fieldData[0][0] = 1;
			fieldData[0][7] = 1;
			fieldData[7][0] = 1;
			fieldData[7][7] = 1;
			break;
		case 10:
			fieldData[1][3] = 1;
			fieldData[1][4] = 1;
			fieldData[3][1] = 1;
			fieldData[3][6] = 1;
			fieldData[4][1] = 1;
			fieldData[4][6] = 1;
			fieldData[6][3] = 1;
			fieldData[6][4] = 1;
			break;
		default:
			break;
	}
}

public function getArea(mx:int, my:int):Point
{
	// スキルを置くところの一番左上の座標をとる（マウス(x,y) - フィールド左上の座標
	var orgx:int = mx - f_loc.x;
	var orgy:int = my - f_loc.y;

	// 範囲に入っていない場合マイナス-1を返す
	if ( orgx > s_loc.x || orgx < 0 || orgy > s_loc.y || orgy < 0 )
	{
		return	(new Point(-1, -1));
	}
	
	// フィールドの中のどこなのか(縦、横)で出す
	var area:Point = new Point(int(orgx / s_img.x), int(orgy / s_img.y));
	return area;
}

public function getWinPos():Point
{
	// フィールドのサイズを返します
	return	(new Point(f_loc.x, f_loc.y));
}

public function canPutInFlag(vx,vy):Boolean
{
	
	if(vx == -1 && vy == -1)
	{
		return false;
	}
	else if(0 <= vx && 0 <= vy && fieldData[this.hit_flg_top + vy][this.hit_flg_left +vx] == 0)
	{
		return false;
	}
	else return true;
}
				
// 完全に消去
public function killPanel()
{	
	var tmp = 0;
	for(var i = 0; i < s_block.y; i++)
	{
		for(var j = 0; j < s_block.x; j++)
		{
			stg.removeChild(stg.getChildByName("f"+tmp));
			tmp++;
		}
	}
}


public function getHitFlagTop():int
{
	return this.hit_flg_top;
}


public function getHitFlagLeft():int
{
	return this.hit_flg_left;
}

}
}

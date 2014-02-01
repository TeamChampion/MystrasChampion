package com.scaleform.hud
{
// scalefoamを使えるようにするため
//import scaleform.gfx.Extensions;
	
public class getFlashProperty
{
	// UDKで読み込む変数
	
	/** どの学園を選んだか
	 * 1 = 火山口金工
	 * 2 = 冷凍の湖避難
	 * 3 = 鉄塔図書館
	 * 4 = 天の門
	 * 5 = 結晶霧の洞窟
	 * 6 = 独学のアルカナ
	 **/
	public var AcademyNumber:int = -1;
	
	
	// 各スペルのポイント割り振り状態
	public var firePoint:int    = -1; // 炎
	public var icePoint:int     = -1; // 氷
	public var earthPoint:int   = -1; // 土
	public var poisonPoint:int  = -1; // 毒
	public var thunderPoint:int = -1; // 雷
	
	
	// プレイヤーの名前
	public var playerName:String;
	
	// スペルの入っている場所（0 = 入っていない）
	public var spellData =
	[
		 [0,0,0,0,0,0,0,0],
		 [0,0,0,0,0,0,0,0],
		 [0,0,0,0,0,0,0,0],
		 [0,0,0,0,0,0,0,0],
		 [0,0,0,0,0,0,0,0],
		 [0,0,0,0,0,0,0,0],
		 [0,0,0,0,0,0,0,0],
		 [0,0,0,0,0,0,0,0]
	 ];

// null参照回避の為メソッド宣言
public function getFlashProperty()
{
	
}

}
}
package com.scaleform.hud
{
	import flash.display.MovieClip;

public class TowerInventoryView extends BaseClickInventory
{
	public function TowerInventoryView()
	{
		super.viewTextNum = 10;
	}
	
	/**
	 * 引数のMovieClipの更新をする。
	 * @param tf 更新する場所のMovieClip(テキストフィールド)
	 */
	public function upDate(tf:MovieClip):void
	{
		// データが無かったら処理を中断
		if(this.viewNameData == null || this.viewExplanationData == null)
		{
			trace("Error : createに失敗しました。データが入っていません");
			return ;
		}
		// まずは最大ページ数を計算する
		tf.maxPage.text = Math.ceil(this.viewNameData.length / this.viewTextNum);
		
		// 今のページを描画する
		tf.nowPage.text = super.nowPage + 1;
		
		// 表示する範囲だけの配列を取得
		var textData:Array = getNowPageTextData();
		
		tf.text1.textF.text  = textData[0];
		tf.text2.textF.text  = textData[1];
		tf.text3.textF.text  = textData[2];
		tf.text4.textF.text  = textData[3];
		tf.text5.textF.text  = textData[4];
		tf.text6.textF.text  = textData[5];
		tf.text7.textF.text  = textData[6];
		tf.text8.textF.text  = textData[7];
		tf.text9.textF.text  = textData[8];
		tf.text10.textF.text = textData[9];
		
		this.viewEquips(tf);
	}
	
	/**
	 * 現在のページを最初のページに戻す。
	 */
	public function nowPageFirst()
	{
		super.nowPage = 0;
	}
	
	/**
	 * 説明文を送る。
	 * @param num 番号
	 * @return Staring 説明文
	 */
	public function getExplanation(num:int):String
	{
		return super.viewExplanationData[super.nowPage*this.viewTextNum + num];
	}
	
	
	// 以下テストコード
	/* ---------------------------------------- */
	
	/**
	 * 装備さている物。
	 */
	 private function viewEquips(tf:MovieClip)
	 {
		 // 装備されているかチェック
		for(var i = 0; i < this.viewTextNum; i++)
		{
			if(this.aa[this.viewTextNum*this.nowPage + i] == 1)
			{
				this.viewEquip(tf,i);
			}
			else
			{
				this.viewUnequip(tf,i);
			}
		}
	 }
	
	/**
	 * 装備されてる物を表示。
	 */
	private function viewEquip(tf:MovieClip,i:int)
	{
		switch(i)
		{
			case 0 : tf.text1.gotoAndStop("equip"); break;
			case 1 : tf.text2.gotoAndStop("equip"); break;
			case 2 : tf.text3.gotoAndStop("equip"); break;
			case 3 : tf.text4.gotoAndStop("equip"); break;
			case 4 : tf.text5.gotoAndStop("equip"); break;
			case 5 : tf.text6.gotoAndStop("equip"); break;
			case 6 : tf.text7.gotoAndStop("equip"); break;
			case 7 : tf.text8.gotoAndStop("equip"); break;
			case 8 : tf.text9.gotoAndStop("equip"); break;
			case 9 : tf.text10.gotoAndStop("equip"); break;
		}
	}
	
	/**
	 * 装備されていない物を表示。
	 */
	private function viewUnequip(tf:MovieClip,i:int)
	{
		switch(i)
		{
			case 0 : tf.text1.gotoAndStop("d"); break;
			case 1 : tf.text2.gotoAndStop("d"); break;
			case 2 : tf.text3.gotoAndStop("d"); break;
			case 3 : tf.text4.gotoAndStop("d"); break;
			case 4 : tf.text5.gotoAndStop("d"); break;
			case 5 : tf.text6.gotoAndStop("d"); break;
			case 6 : tf.text7.gotoAndStop("d"); break;
			case 7 : tf.text8.gotoAndStop("d"); break;
			case 8 : tf.text9.gotoAndStop("d"); break;
			case 9 : tf.text10.gotoAndStop("d"); break;
		}
	}
	
	public var aa:Array = [0,0,0,1,0,0,0,0,0,0,0];
	/**
	 * 装備する。
	 * @param num 番号
	 * @param 表示するMovieClip
	 */
	public function equip(num:int,tf:MovieClip)
	{
		this.AllUnequip(tf);
		this.viewEquips(tf);
		// 新しく装備する
		this.aa[this.viewTextNum*this.nowPage + num] = 1;
	}
	
	/**
	 * 装備を全て外す。
	 * @param 表示するMovieClip
	 */
	public function AllUnequip(tf:MovieClip)
	{
		for(var i:int = 0; i < this.aa.length; i++)
		{
			this.aa[i] = 0;
		}
		viewEquips(tf);
	}

	// とりあえずの装備されているアイテムの表示
	public function getEquip()
	{
		return aa;
	}
	
	// 装備しているものの説明を返す
	public function nowEquip()
	{
		for(var i:int = 0; i < this.aa.length; i++)
		{
			if(this.aa[i] == 1)
			{
				return super.viewExplanationData[i];
			}
		}
	}
}
}

package com.scaleform.hud
{
import flash.display.MovieClip;

public class TraitsAndTitlesView extends BaseClickInventory
{
	/**
	 * 初期化。
	 */
	public function TraitsAndTitlesView() 
	{
		super.viewTextNum = 5; 
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
		tf.maxPage.text = Math.ceil(this.viewNameData.length / viewTextNum);
		
		// 今のページを描画する
		tf.nowPage.text = this.nowPage + 1;
		
		// 表示する範囲だけの配列を取得
		var textData:Array = getNowPageTextData();
		
		tf.text1.text = textData[0];
		tf.text2.text = textData[1];
		tf.text3.text = textData[2];
		tf.text4.text = textData[3];
		tf.text5.text = textData[4];
	}
}	
}

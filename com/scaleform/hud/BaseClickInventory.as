package com.scaleform.hud
{	
	import flash.display.MovieClip;

	public class BaseClickInventory
	{
		// 表示するテキスト数
		protected var viewTextNum:int = 5;
		// 表示させる名前データを入れておく配列
		protected var viewNameData:Array;
		// 表示させる説明データを入れておく配列
		protected var viewExplanationData:Array;
		
		// 今表示しているページ
		protected var nowPage:int;
		
		/* ---------------------------------------- */
		
		/**
		 * コンストラクタ
		 * おもに初期化。
		 */
		public function  BaseClickInventory()
		{
		}
		
		/**
		 * 次のページにする。
		 */
		public function nextPage():void
		{
			// 今のページが最後のページじゃなければ
			if(this.nowPage != ~~(this.viewNameData.length / viewTextNum))
			{
				this.nowPage++;
			}
		}
		
		/**
		 * クリックされたテキストの番号をとる。
		 * @return クリックしたテキストの番号
		 */
		 public function getClickedNum(selectCont)
		 {
			 if(this.viewNameData[this.nowPage*viewTextNum + selectCont] != null)
			 {
			 	return this.nowPage*viewTextNum + selectCont;
			 }
		 }
		
		/**
		 * 前のページに戻る。
		 */
		public function backPage():void
		{
			// 一番最初のページじゃなければ
			if(this.nowPage != 0)
			{
				this.nowPage--;
			}
		}
		
		/**
		 * 名前を送る。
		 * @param  selectCont 参照するデータ
		 * @retrun 選択された場所の名前
		 */
		public function getSelectedName(selectCont)
		{
			// nullじゃなければ送る
			if(this.viewNameData[this.nowPage*viewTextNum + selectCont] != null)
			{
				return this.viewNameData[this.nowPage*viewTextNum + selectCont];
			}
			else
			{
				return "";
			}
		}
		
		/**
		 * 説明文を送る。
		 * @param  selectCont 参照するデータ
		 * @retrun 選択された場所の説明文
		 */
		public function getSelectedExplanation(selectCont)
		{
			// nullじゃなければ送る
			if(this.viewExplanationData[this.nowPage*viewTextNum + selectCont] != null)
			{
				return this.viewExplanationData[this.nowPage*viewTextNum + selectCont];
			}
			else
			{
				return "";
			}
		}
		
		/**
		 * ページ数に応じてその範囲だけのテキストを配列で用意。
		 * @return 範囲のテキストが入った配列
		 */
		 protected function getNowPageTextData():Array
		 {
			 var tmp:Array = [];
			 
			 for(var i:int = 0; i < viewTextNum; i++)
			 {
				 // 文字が入っていれば
				 if(this.viewNameData[this.nowPage*viewTextNum + i] != null)
				 {
				 	tmp[i] = this.viewNameData[this.nowPage*viewTextNum + i];
				 }
				 else
				 {
					tmp[i] = "";
				 }
			 }
			 return tmp;
		 }
		/* ---------------------------------------- */
		
		/**
		 * アクセッサー。
		 */
		public function setViewNameData(viewNameData:Array):void
		{
			this.viewNameData = viewNameData;
		}
		
		public function getViewNameData()
		{
			// 配列が無ければエラー
			if(this.viewNameData == null)
			{
				trace("Error : viewNameDataはnullです");
				return ;
			}
			return this.viewNameData;
		}
		
		public function setViewExplanationData(viewExplanationData:Array):void
		{
			this.viewExplanationData = viewExplanationData;
		}
		
		public function getViewExplanationData()
		{
			// 配列が無ければエラー
			if(this.viewExplanationData == null)
			{
				trace("Error : viewExplanationDataはnullです");
				return ;
			}
			return this.viewExplanationData;
		}
		
		/**
		 * 今表示されているページを返す。
		 * @return 今表示されているページ
		 */
		public function getNowPage():int
		{
			return this.nowPage;
		}
		/* ---------------------------------------- */
	}
}

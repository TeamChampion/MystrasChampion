package com.scaleform.hud
{
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class CreateInventory
	{
		// 表示するデータを格納
		private var inv:Array;
		// 描画位置x,y
		private var px_:int;
		private var py_:int;
		
		// 表示するMask(範囲)とインベントリデータを貼り付けるArea
		private var cMask_:Sprite = new Sprite();
		private var cArea_:Sprite = new Sprite();
		
		// 選択してないときの画像（これらはcAreaにaddChildされる）
		private var selectField_:MovieClip;
		// 選択したときの画像
		private var selected_:MovieClip
		
		/**
		 * スクロールする部分を作る。
		 */
		private function create()
		{
			this.createArea(this.px_,this.py_,this.selectField_.width,this.selectField_ * this.inv.length);
			this.createMask(this.px_,this.py_,this.selectField_.width,this.maskHe);
		}
		
		// ---- ※beginFillを消さないこと（正常に動きません） ----
		/**
		 * マスク部分を作成。
		 */
		private function createMask(x:int,y:int,wi:int,he:int):void
		{
			this.cMask_.graphics.beginFill(0xff0000,0);
			this.cMask_.graphics.drawRect(x,y,wi,he);
		}
		
		/**
		 * スクロールさせる部分を作成。
		 */
		private function createArea(x:int,y:int,wi:int,he:int):void
		{
			this.cArea_.graphics.beginFill(0x00ff00,0);
			this.cArea_.graphics.drawRect(x,y,wi,he);
		}
		
		/* ---------------------------------------- */
		/**
		 * publicメソッド。
		 */
		public function setXY(px:int,py:int):void
		{
			this.px = px;
			this.py = py;
		}
		
		/**
		 * 未選択画像、選択画像をセット。
		 */
		public function setSelectFieldAndSelected(SFimg:MovieClip,SDimg:MovieClip):void
		{
			this.selectField_ = SFimg;
			this.selected_    = SDimg;
		}
	}
}

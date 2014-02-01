package com.scaleform.hud
{

	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.StaticText;
	import flash.text.TextField;
	import com.scaleform.hud.MoveCtrl;
	import flash.display.MovieClip;
	
	/**
	* ...
	* @author shin-go
	* 
	*/

	public class Scrollbar extends MovieClip
	{
		//bar_mcとback_mcはMC内に配置する
		
		public var bar_mc:MovieClip;
		
		public var back_mc:MovieClip;
		private var bar_moveCtrl:MoveCtrl;
		private var bar_movableArea:Rectangle;
		
		private var target_mc:MovieClip;
		private var target_moveCtrl:MoveCtrl;
		private var target_movableArea:Rectangle;
		private var containerRect:Rectangle;
		
		//コンテンツのスクロール時の加速度
		private const target_acc:Number = 0.2;
		
		//スクロールバーのスクロール時の加速度
		private const bar_acc:Number = 0.2;
		
		//target_mc内の選択可能なTextFieldを格納
		private var selectableTxt_ary:Array;
		
		public function Scrollbar() 
		{
			//setScroll();
			bar_mc = _bar_mc;
			back_mc = _back_mc;
			
		}
		public function setScroll(_target_mc:MovieClip, _containerRect:Rectangle,_scrollBtoT:Boolean,_scrollAcc:Number):void
		{
			target_mc = _target_mc;
			containerRect = _containerRect;
			changeBarHeight();
			checkTargetTextField();
			setBar();
			setBack();
			setWheel();
			setKey();
			setTarget();
			
			if (_scrollBtoT)
			{
				scrollBtoT(_scrollAcc);
			}
		}
		private function scrollBtoT(_acc:Number):void
		{
			if (!_acc)
			{
				_acc = 0.2;
			}
			bar_mc.y = bar_movableArea.bottom;
			target_mc.y = target_movableArea.top;
			moveBar(bar_movableArea.top, _acc);
			
		}
		
		private function changeBarHeight():void
		{
			bar_mc.back.height = Math.floor(back_mc.height / target_mc.height * containerRect.height);
			bar_mc.slit.scaleY = 1/this.scaleY;
			//bar_mc.slit.scaleY = 100;
			bar_mc.slit.y = Math.floor(bar_mc.back.height/2-bar_mc.slit.height/2);
		}
		public function setBar():void
		{
			bar_mc.buttonMode = true;
			bar_movableArea = new Rectangle(bar_mc.x, back_mc.y, 0, back_mc.height - bar_mc.height);
			bar_mc.movableArea = bar_movableArea;
			bar_moveCtrl = new MoveCtrl(bar_mc);
			back_mc.bar_moveCtrl = bar_moveCtrl;
			
			bar_mc.addEventListener(MouseEvent.MOUSE_DOWN, barPress);
			stage.addEventListener(MouseEvent.MOUSE_UP, barRelease);
			target_mc.addEventListener(MouseEvent.MOUSE_UP, barRelease);

		}
		private function barPress(e:MouseEvent = null):void
		{
			stopBar();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, barMouseMove);
			bar_mc.startDrag(false, bar_movableArea);
			changeSelectable(false);
		}
		private function barRelease(e:MouseEvent = null):void
		{
			//stage.removeEventListener(MouseEvent.MOUSE_MOVE, barMouseMove);
			bar_mc.stopDrag();
			bar_mc.y = Math.floor(bar_mc.y);
			changeSelectable(true);
		}
		private function barMouseMove(e:MouseEvent=null):void
		{
			//trace("barMouseMove");
			moveTarget(bar_mc.y);
			e.updateAfterEvent();
		}
		
		
		private function setBack():void
		{
			back_mc.addEventListener(MouseEvent.MOUSE_DOWN, backPress);
			back_mc.addEventListener(MouseEvent.MOUSE_UP, backRelease);
			back_mc.addEventListener(MouseEvent.MOUSE_OUT, backRelease);
		}
		private function backPress(e:MouseEvent = null):void
		{
			if (this.mouseY < bar_mc.y)
			{
				moveBar(this.mouseY,0.4);
			}else
			{
				moveBar(Math.floor(this.mouseY - bar_mc.height),0.4);
			}
			
		}
		private function backRelease(e:MouseEvent = null):void
		{
			stopBar();
		}
		
		
		private function setTarget():void
		{
			target_movableArea = new Rectangle(target_mc.x, containerRect.bottom - target_mc.height, 0, target_mc.height - containerRect.height);
			target_moveCtrl = new MoveCtrl(target_mc);
		}
		
		//target_mc内の選択可能なテキストフィールドの参照を配列に入れて返す
		private function checkTargetTextField():void
		{
			selectableTxt_ary = new Array();
			_checkTargetTextFiled(target_mc);
			trace(selectableTxt_ary);
		}
		private function _checkTargetTextFiled(_target:DisplayObjectContainer):void
		{
			for (var i:int = 0; i < _target.numChildren; i++)
			{
				var child = _target.getChildAt(i);
				if (child is TextField)
				{
					if (child.selectable == true)
					{
						selectableTxt_ary.push(child);
					}
				}
				if (child is DisplayObjectContainer)
				{
					_checkTargetTextFiled(child);
				}
			}
		}
		private function changeSelectable(_state:Boolean):void
		{
			for (var i:int; i < selectableTxt_ary.length; i++)
			{
				selectableTxt_ary[i].selectable = _state;
			}
		}
		
		private function setWheel():void
		{
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		public function setWheelRemove():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
		}
		
		private function onMouseWheel(e:MouseEvent = null)
		{
			if(containerRect.contains(this.parent.mouseX, this.parent.mouseY)){
			var delta:Number = e.delta;
			moveBar(Math.floor(bar_mc.y + delta * -20), bar_acc);
			}
		}
		
		
		
		private function setKey():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
		}
		private function onKeyDownHandler(e:KeyboardEvent):void
		{
			var UpCode = 38;;
			var DownCode = 40;
			
			if (e.keyCode == UpCode)
			{
				moveBar(Math.floor(bar_mc.y + -30), bar_acc);
				
			}else if(e.keyCode == DownCode)
			{
				moveBar(Math.floor(bar_mc.y + 30), bar_acc);
			}
		}
		
		
		
		
		public function moveBar(_toY:Number,_acc:Number):void
		{
			var movableArea:Rectangle = bar_movableArea;
			var toY:Number;
			if (_toY < movableArea.top)
			{
				toY = movableArea.top;
			}else if (_toY > movableArea.bottom)
			{
				toY = movableArea.bottom;
			}else
			{
				toY = _toY;
			}
			bar_moveCtrl.slowTo(new Point(bar_mc.x, toY), _acc);
			moveTarget(toY);
			
			//trace(target_movableArea.bottom - (toY - bar_movableArea.top) / bar_movableArea.height * target_movableArea.height);
			
			
		}
		public function stopBar():void
		{
			bar_moveCtrl.stop();
		}
		public function moveTarget(_bar_y:Number):void
		{
			var _toY:Number=Math.floor(target_movableArea.bottom - (_bar_y - bar_movableArea.top) / bar_movableArea.height * target_movableArea.height)
			var _acc:Number = target_acc;
			var movableArea:Rectangle = target_movableArea;
			var toY:Number;
			if (_toY < movableArea.top)
			{
				toY = movableArea.top;
			}else if (_toY > movableArea.bottom)
			{
				toY = movableArea.bottom;
			}else
			{
				toY = _toY;
			}
			target_moveCtrl.slowTo(new Point(target_mc.x,toY), _acc);
		}
	}
}
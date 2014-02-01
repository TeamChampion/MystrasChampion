package com.scaleform.hud
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	* ...
	* @author shin-go
	* @version 20080816
	*/

	public class MoveCtrl {
		private var target_mc:MovieClip;
		
		private var endMethodTarget_mc:MovieClip;
		private var endMethodName:String;
		
		//onEnterFrameするMC
		private var ctrl_mc:MovieClip;
		
		private var acc:Number;
		private var toPoint:Point;
		private var spring:Number;
		private var friction:Number;
		
		private var speed_x:Number;
		private var speed_y:Number;
		
		private var speed:Number;
		private var toY:Number;
		
		public function MoveCtrl(_target_mc:MovieClip ) {
			target_mc = _target_mc;
			ctrl_mc = new MovieClip();
			target_mc.addChild(ctrl_mc);
		}
		public function slowTo(_point:Point, _acc:Number)
		{
			slowto(_point, _acc);
		}
		public function slowto(_point:Point, _acc:Number) {
			//trace("slowto:"+ctrl_mc);
			//加速度
			if (_acc) {
				acc = _acc;
			}else {
				acc = 0.1;
			}
			toPoint = _point;
			
			stop();
			ctrl_mc.addEventListener(Event.ENTER_FRAME, onEnterFrameSlowTo);
		}
		private function onEnterFrameSlowTo(e:Event):void
		{
			if (Math.abs(toPoint.x - target_mc.x) < 0.5 && Math.abs(toPoint.y - target_mc.y) < 0.5) {
				target_mc.x = toPoint.x;
				target_mc.y = toPoint.y;
				toPoint = null;
				acc = 0;
				ctrl_mc.removeEventListener(Event.ENTER_FRAME, onEnterFrameSlowTo);
				
				if (endMethodName && endMethodTarget_mc) {
					endMethodTarget_mc[endMethodName]();
				}
			}else {
				target_mc.x += (toPoint.x - target_mc.x) * acc;
				target_mc.y += (toPoint.y - target_mc.y) * acc;
			}
		}
		
		
		
		public function springTo(_toPoint:Point, _spring:Number, _friction:Number) {
			if (_spring || _spring==0) {
				spring = _spring;
			}else {
				spring = 0.01;
			}
			if (_friction || _friction==0) {
				friction = _friction;
			}else {
				friction = 0.02;
			}
			toPoint = _toPoint;
			speed_x = 0;
			speed_y = 0;
			
			ctrl_mc.addEventListener(Event.ENTER_FRAME, onEnterFrameSpringTo);
		}
		private function onEnterFrameSpringTo(e:Event = null):void
		{
			if (Math.abs(toPoint.x - target_mc.x) < 0.5 && Math.abs(toPoint.y - target_mc.y) < 0.5  && Math.abs(speed_x)<0.5 && Math.abs(speed_y)<0.5 ) {
				target_mc.x = toPoint.x;
				target_mc.y = toPoint.y;
				toPoint = null;
				friction = 0;
				speed_x = 0;
				speed_y = 0;
				spring = 0;
				
				ctrl_mc.removeEventListener(Event.ENTER_FRAME, onEnterFrameSpringTo);
				
				if (endMethodName && endMethodTarget_mc) {
					endMethodTarget_mc[endMethodName]();
				}
			}else {
			//trace("speed=" + this.speed);
			//trace("target_mc.scale = "+ target_mc._xscale);
				
				speed_x += (toPoint.x - target_mc.x) * spring - speed_x * friction;
				target_mc.x += speed_x;
				
				speed_y += (toPoint.y - target_mc.y) * spring - speed_y * friction;
				target_mc.y += speed_y;
			}
		}
		
		
		
		
		
		
		public function moveToY(_speed:Number, _toY:Number) {
			speed = _speed;
			toY = _toY;
			
			stop();
			ctrl_mc.addEventListener(Event.ENTER_FRAME, onEnterFrameMoveToY);
	
		}
		private function onEnterFrameMoveToY(e:Event = null):void
		{		
			if (speed > 0 && target_mc.y + this.speed  > this.toY) {
				target_mc.y = toY;
				if (endMethodName && endMethodTarget_mc) {
					this.endMethodTarget_mc[endMethodName]();
				}
				
				ctrl_mc.removeEventListener(Event.ENTER_FRAME, onEnterFrameMoveToY);
			}else if (speed < 0 && target_mc.y + speed < toY) {
				target_mc.y = this.toY;
				if (endMethodName && endMethodTarget_mc) {
					endMethodTarget_mc[endMethodName]();
				}
				ctrl_mc.removeEventListener(Event.ENTER_FRAME, onEnterFrameSpringTo);
			}else {
				target_mc.y += this.speed;
			}
			
		}
		
		
		
		public function stop() {
			ctrl_mc.removeEventListener(Event.ENTER_FRAME, onEnterFrameSlowTo);
			ctrl_mc.removeEventListener(Event.ENTER_FRAME, onEnterFrameSpringTo);
			ctrl_mc.removeEventListener(Event.ENTER_FRAME, onEnterFrameMoveToY);
		}
		public function setEndMethod(_target_mc:MovieClip, _methodName:String) {
			endMethodName=_methodName;
			endMethodTarget_mc = _target_mc;
			//trace("setEndMethod:"+endMethod);
		}
		public function deleteEndMethod() {
			endMethodName = null;
			endMethodTarget_mc = null;
		}
	}
}
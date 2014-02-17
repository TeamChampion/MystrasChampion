package com.scaleform.hud
{	
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.TimerEvent;
	import flash.utils.*;
	import flash.display.SimpleButton;
	import flash.system.fscommand;

public class MakeScenario 
{
	// キャラクターネーム保存
	private var characterName:Array;
	/* ---------------------------------------- */
	// 最終的に表示する台詞と話す順番を格納
	private var word:Array;
	private var speak:Array;
	/* ---------------------------------------- */
	// flaから持ってきて格納するもの
	private var flameWindow:MovieClip; 
	private var fadeOut_B:MovieClip;
	private var fadeIn_B:MovieClip;
	private var fadeOut_W:MovieClip;
	private var skipButton:SimpleButton;
	private var stg:Stage;
	private var img:Array;
	private var scenarioNumber:int;
	/* ---------------------------------------- */
	// 定数
	// キャラクターの画像が必要になる番号(それ以下は画像がないもの)
	// = 主人公の画像番号でもあります
	private var START_NUMBER   = 7;
	
	// イベント番号
	private var FADE_OUT_EVENT_B    = 2;
	private var FADE_IN_EVENT_B     = 3;
	private var FADE_OUT_EVENT_W    = 4;
	private var LAST_IMG_ALPHA_0    = 5;
	private var END        = 6;
	
	// 表示座標
	private var RIGHT_X = 600;
	private var LEFT_X  = 100;
	
	/* ---------------------------------------- */
	// シナリオ情報保存クラス（この中に全シナリオの台詞など格納）
	private var SC:ScenarioConfiguration = new ScenarioConfiguration();
	// 現在の台詞番号
	private var wordNum:int = -1;
	// 台詞を次に飛ばせるか
	private var nextFlag:Boolean = true;
	// ボタンをさせないか
	private var buttonAlpha0:Boolean = false;
	// 右に表示しているキャラクターの番号(-1が初期値)
	private var showRightCharacterNow:int = -1;
	
	
	/* ---------------------------------------- */
	
	// ステージ情報と画像と表示シナリオ番号を引数に
	public function MakeScenario(stg:Stage,img:Array,num:int)
	{
		this.stg = stg;
		this.img = img;
		this.scenarioNumber = num;
	}
	
	/* ---------------------------------------- */
	// flash側からの設定が必要
	
	// プレイヤーの名前をセット
	public function setPlayerName(PlayerName:String)
	{
		this.SC.setPlayerName(PlayerName,this.START_NUMBER);
	}
	
	// フレーム画像をセット
	public function setFlameWindow(flameWindow:MovieClip)
	{
		this.flameWindow = flameWindow;
	}
	
	// フェード画像をセット
	public function setFadeImg(fadeOut_B:MovieClip,fadeIn_B:MovieClip,fadeOut_W:MovieClip)
	{
		this.fadeOut_B = fadeOut_B;
		this.fadeIn_B  = fadeIn_B;
		this.fadeOut_W = fadeOut_W;
	}
	
	// 全てセットし終えたらこれを呼び出す
	public function createScenarioScene()
	{
		this.SC.create(this.scenarioNumber);
		
		this.word          = this.SC.getWord();
		this.speak         = this.SC.getSpeak();
		this.characterName = this.SC.getCharacterName();
		
		this.flameProperty();
	}
	/* ---------------------------------------- */
	
	// フレームの設定
	private function flameProperty()
	{
		this.flameWindow.x = 80;
		this.flameWindow.y = 480;
		stg.addChildAt(this.flameWindow,1);
		
		// テキストエリアクリックで次の台詞に行くように
		this.flameWindow.cover.addEventListener(MouseEvent.CLICK,nextClick);
		this.flameWindow.cover.buttonMode = true;
		
		// Spaceキーでも次の台詞へ
		stg.addEventListener(KeyboardEvent.KEY_DOWN,spacePush);
		
		// 話に出てくるキャラクターをステージに非表示で表示
		this.setCharacter();
		
		this.nextEvent();
	}
	/* ---------------------------------------- */
	// nextButtonイベント設定
	private function nextClick(e:MouseEvent)
	{
		this.nextEvent();
	}
	private function spacePush(e:KeyboardEvent)
	{
		// スペースを押していたら
		if(e.keyCode == Keyboard.SPACE) this.nextEvent();
	}
	/* ---------------------------------------- */
	
	// 引数がSTART_NUMBER以下ならfalse
	private function checkNum(num:int):Boolean
	{
		if(START_NUMBER <= num) return true;
		else return false;
	}
	
	// キャラクターをセットする
	private function setCharacter()
	{
		// 画像に名前を付ける
		for(var i:int = 0;i < this.img.length; i++)
		{
			this.img[i].name = ""+i;
		}
		
		// 出番のあるキャラクターだけ表示
		for(i = 0; i < this.speak.length; i++)
		{
			if(this.checkNum(this.speak[i]))
			{
				stg.addChildAt(this.img[(this.speak[i] - this.START_NUMBER)],0).alpha = 0;
				stg.getChildByName(""+(this.speak[i] - this.START_NUMBER)).x = this.RIGHT_X;
			}
		}
		if(stg.getChildByName("0") != null)
		{
			// プレイヤーだけいつも左側に
			stg.getChildByName("0").x = this.LEFT_X;
		}
		
	}
	
	private function nextEvent()
	{
		if(this.wordNum != this.word.length - 1 && this.nextFlag)
		{
			this.wordNum++;
			// フェードアウトなら
			if(this.speak[this.wordNum] == this.FADE_OUT_EVENT_B)
			{
				this.flameWindow.nameSpace.text = "";
				this.flameWindow.textFieldOfWords.text = "";
				this.fadeOut();
			}
			// フェードインなら
			else if(this.speak[this.wordNum] == this.FADE_IN_EVENT_B)
			{
				this.flameWindow.nameSpace.text = "";
				this.flameWindow.textFieldOfWords.text = "";
				this.fadeIn();
			}
			// フェードアウト（白）なら
			else if(this.speak[this.wordNum] == this.FADE_OUT_EVENT_W)
			{
				this.flameWindow.nameSpace.text = "";
				this.flameWindow.textFieldOfWords.text = "";
				this.fadeOut_WH();
			}
			else if(this.speak[this.wordNum] == this.LAST_IMG_ALPHA_0)
			{
				this.semitransparentAlpha0();
			}
			// 台詞の最後なら
			else if(this.speak[this.wordNum] == this.END)
			{
				endEvent(this.scenarioNumber);
			}
			else
			{
				this.flameWindow.nameSpace.text = this.characterName[this.speak[this.wordNum]];
				this.viewText(this.word[this.wordNum]);
				this.showCharacter();
			}
			// 台詞の最後またはイベント中（FADE...etc）ならnextButtonを消す
			if(this.buttonAlpha0 || this.wordNum == this.word.length - 1) this.flameWindow.next.alpha = 0;
		}
	}
	
	// キャラクターを表示
	private function showCharacter()
	{
		// しゃべっていないのは半透明、話す相手が変わったらAlphaを0に
		if(this.speak[this.wordNum] != this.speak[this.wordNum - 1])
		{
			if(this.checkNum(this.speak[this.wordNum - 1]) && this.wordNum != 0)
			{
				stg.getChildByName(""+(this.speak[this.wordNum - 1] - this.START_NUMBER)).alpha = 0.5;
			}
			if(this.showRightCharacterNow != -1 && this.checkNum(this.speak[this.wordNum])
			  && this.speak[this.wordNum] != this.START_NUMBER && (this.speak[this.wordNum] - this.START_NUMBER)  != this.showRightCharacterNow)
			{
				this.img[this.showRightCharacterNow].gotoAndPlay("Out");
			}
		}
		
		// 表示する前にalphaが0ならフェードインさせる
      	if(this.checkNum(this.speak[this.wordNum]) && stg.getChildByName(""+(this.speak[this.wordNum] - this.START_NUMBER)).alpha == 0)
		{
			this.img[(this.speak[this.wordNum] - this.START_NUMBER)].gotoAndPlay("In");
		}
		// 画像がある番号ならば話しているキャラクターを表示
		if(this.checkNum(this.speak[this.wordNum]))
		{
			stg.getChildByName(""+(this.speak[this.wordNum] - this.START_NUMBER)).alpha = 1;
			
			// 表示されているキャラクターを保存(主人公は対象外)
			if((this.speak[this.wordNum] - this.START_NUMBER) != 0)
			{
				this.showRightCharacterNow = (this.speak[this.wordNum] - this.START_NUMBER);
			}
		}
	}
	
	// テキストを1文字ずつ表示する
	function viewText(str:String):void
	{
		var view:String = str;
		var count:int = 0;
		
		flameWindow.next.alpha = 0;
		nextFlag = false;

		var Timer = setInterval(go,20);
		function go():void
		{
			var nowText:String = view.substr(0,count);
			flameWindow.textFieldOfWords.text = nowText;
			count++;
			if(view.length < count)
			{
				nextFlag = true;
				flameWindow.next.alpha = 1;
				clearInterval(Timer);
			}
		};
	}

	/* ---------------------------------------- */
	// イベント処理
	
	// フェードアウト処理
	private function fadeOut()
	{
		stg.addChildAt(this.fadeOut_B,stg.numChildren-1);
		this.fadeOut_B.gotoAndPlay(2);
		
		buttonAlpha0 = true;
		nextFlag = false;
		
		// フェード用
		var timer:Timer = new Timer(2800,1);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE,
		// タイマー終了後会話を続けられるようにする
		function (e:TimerEvent):void
		{
			stg.removeChildAt(stg.numChildren-2);
			
			nextFlag = true;
			buttonAlpha0 = false;
			
			timer = null;
			nextEvent();
		});
		timer.start();
		

		// 表示されているキャラを消す
		var timer2:Timer = new Timer(1200,1);
		timer2.addEventListener(TimerEvent.TIMER_COMPLETE,
		// タイマー終了後会話を続けられるようにする
		function (e:TimerEvent):void
		{
			allAlpha0();
			timer2 = null;
		});
		timer2.start();
	}
	
	// フェードイン
	private function fadeIn()
	{
		stg.addChildAt(this.fadeIn_B,stg.numChildren-1);
		this.fadeIn_B.gotoAndPlay(2);
		
		buttonAlpha0 = true;
		nextFlag = false;
		
		// フェード用
		var timer:Timer = new Timer(1700,1);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE,
		// タイマー終了後会話を続けられるようにする
		function (e:TimerEvent):void
		{
			stg.removeChildAt(stg.numChildren-2);
			
			nextFlag = true;
			buttonAlpha0 = false;
			
			nextEvent();
			timer = null;
		});
		timer.start();
	}
	
	// フェードアウト処理
	private function fadeOut_WH()
	{
		stg.addChildAt(this.fadeOut_W,stg.numChildren-1);
		this.fadeOut_W.gotoAndPlay(2);
		
		buttonAlpha0 = true;
		nextFlag = false;
		
		// フェード用
		var timer:Timer = new Timer(2800,1);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE,
		// タイマー終了後会話を続けられるようにする
		function (e:TimerEvent):void
		{
			stg.removeChildAt(stg.numChildren-2);
			
			nextFlag = true;
			buttonAlpha0 = false;
			
			timer = null;
			nextEvent();
		});
		timer.start();
	}
	
	// 最後に半透明になったのを消す
	private function semitransparentAlpha0()
	{
		this.img[(this.speak[this.wordNum - 1] - this.START_NUMBER)].gotoAndPlay(11);
		nextEvent();
	}
	
	// 会話が全て終了したときのイベント
	private function endEvent(num:int)
	{
		switch(num)
		{
			case 1 : trace("chapter1-1end"); fscommand("chapter1-1end"); break;
			case 2 : trace("chapter1-2end"); fscommand("chapter1-2end"); break;
			case 3 : trace("chapter1-3end"); break;
			case 4 : trace("chapter2-1end"); break;
			case 5 : trace("chapter2-2end"); break;
		}
	}
	
	/* ---------------------------------------- */
	
	// 今表示されているキャラクターを全て消す
	private function allAlpha0()
	{
		for(var i:int = 0; i < this.img.length; i++)
		{
			this.img[i].gotoAndPlay(11);				
			this.img[i].alpha = 0;
		}
	}
	
	/* ---------------------------------------- */
	// 以下スキップ用のメソッド群
	
	public function setskipButton(bt:SimpleButton)
	{
		this.skipButton = bt;
		this.skipButton.addEventListener(MouseEvent.CLICK,skipEvent);
		this.skipButton.x = 1150;
		this.skipButton.y = 5;
		stg.addChildAt(this.skipButton,0);
	}
	
	// スキップボタンを押したら
	public function skipEvent(e:MouseEvent)
	{
		if(nextFlag)
		{
			this.flameWindow.nameSpace.text = "";
			this.flameWindow.textFieldOfWords.text = "";
			buttonAlpha0 = true;
			this.wordNum = this.word.length - 2;
			
			//this.fadeOut();
			/*var timer:Timer = new Timer(1200,1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,
			// タイマー終了後会話を続けられるようにする
			function (e:TimerEvent):void
			{
				this.nextFlag = false;
				while((stg.numChildren - 2) > 0)
				{  
        			stg.removeChildAt(0); 
				}  
			});
			timer.start();
			*/
			endEvent(this.scenarioNumber);
				
		}
	}
}
}

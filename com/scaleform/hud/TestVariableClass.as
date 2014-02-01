package com.scaleform.hud
{
    import flash.display.MovieClip;
    import flashx.textLayout.formats.Float;
	
    public class TestVariableClass extends MovieClip
	{
		public var AS_SomeInt:int = 5;
		public var AS_SomeBool:Boolean = false;
		public var AS_SomeString:String = 'geko funkar';
		public var AS_OpenText:String = '';
			
			
			

		public function MySampleHudClass()
		{
			//super();
			/*
			AS_SomeInt = 5;
			AS_SomeBool = false;
			AS_SomeString = 'geko funkar';
			*/
			
			
			
			FlashInstance.intInstance.text = AS_SomeInt.toString();
			FlashInstance.boolInstance.text = AS_OpenText + AS_SomeBool;
			FlashInstance.stringInstance.text = AS_SomeString;
			
			/*
			trace("AS_SomeInt: " + AS_SomeInt);
			trace("AS_SomeBool: " + AS_SomeBool);
			trace("AS_SomeString: " + AS_SomeString);
			*/
		}

    }
	
}
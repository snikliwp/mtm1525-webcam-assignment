package  {
	
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.HTTPStatusEvent;
	
	
	public class timePreloader extends MovieClip {
		
		public var loader:Loader = new Loader();
		public var pct:Number = 0;
		
		public function timePreloader() {
			// constructor code
			var req:URLRequest = new URLRequest("big_image.jpg");
			loader.contentLoaderInfo.addEventListener(Event.INIT, infoReady);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loading);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, fileRead);
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpReady);
			//go get the image
			loader.load(req);
			//start adding clouds
//			this.addEventListener(Event.ENTER_FRAME, goLoopy);
			
		} // end function timePreloader
		
		public function infoReady(ev:Event):void{
			//event.init
			trace("Image info is ready. width:" + ev.target.width);
		} // end function infoReady
		
		public function imageLoaded(ev:Event):void{
			//event.complete
			addChild( loader );
			//add what you loaded to the stage
			loader.scaleX = loader.scaleY = .9;
			
			clock.visible = false;
			//hide your preloader
			trace("Image could be added to the stage now.");
		} // end function imageLoaded
		
		public function loading(ev:ProgressEvent):void{
trace("In function loading: ");
			//ProgressEvent.PROGRESS
			pct = ev.bytesLoaded/ev.bytesTotal;
			trace( ev.bytesLoaded + " / " + ev.bytesTotal + " = " + pct);
			/**
			We want to have the rocket rotate from 0degrees to -90degrees. 
			A range of 90degrees in the negative direction
			**/
			/**/
//			mc_hourHand.rotation=(num_hour+(dte_currentDate.minutes/60)+(dte_currentDate.seconds/3600))*30;
//
//			mc_minHand.rotation=(dte_currentDate.minutes+(dte_currentDate.seconds/60))*6;
//
//			mc_secHand.rotation=dte_currentDate.seconds*6;

			clock.littleHand_mc.rotation = pct * 360;
trace("In function loading: 1");
			clock.bigHand_mc.rotation = pct * 360 * 10;
trace("In function loading: 2");
			var strPct:String = Math.round( pct * 100).toString();
trace("In function loading: 3");
			clock.pct_txt.text = strPct + "%";
trace("In function loading: 4");
			
			
			
			
			/*var newPos:Number = pct * stage.stageWidth;
			launcher_mc.x = newPos;
			*/
			/*var flip:Number = (pct * 2) - 1;		//start with a value of 1 and end with -1
			launcher_mc.scaleX = flip;
			
			var a:Number = pct;				//we want the inverse of this.
			launcher_mc.alpha = a;*/
			
//			var fr:Number = Math.round(pct * pink_square_mc.totalFrames);
//			pink_square_mc.gotoAndStop(fr);
			//rounding off the frame number is necessary for this to work
			
			//write out the percentage loaded
			//get rid of the decimal places
			//make the number between 0 and 100 instead of 0 and 1.
			
			
			//When we get to 95% loaded... stop adding clouds
//			if( pct >= .95){
//				this.removeEventListener(Event.ENTER_FRAME, goLoopy);
//			} // end if
		} // end function loading
		
		public function fileRead(ev:IOErrorEvent):void{
			//IOErrorEvent.IO_ERROR
			trace("Could not open file. " + ev.text );
			loader.removeEventListener(ProgressEvent.PROGRESS, loading);
				clock.text = "404 ERROR!!!!";
		} // end function fileRead
		
		public function httpReady(ev:HTTPStatusEvent):void{
			//HTTPStatusEvent.HTTP_STATUS
			trace("HTTP status code is " + ev.status);
			if( ev.status != 0){
				trace(" from " + ev.responseURL);
			} // end if
			
			if( ev.status == 404){
				//write a message to the user
				loader.removeEventListener(ProgressEvent.PROGRESS, loading);
				clock.text = "404 ERROR!!!!";
			} // end if
		} // end function httpReady
		
//		public function goLoopy(ev:Event):void{
//			//add clouds at the base of the rocket
//			var _x:Number = launcher_mc.x + Math.random() * 20 - 10;	// 10 to 20
//			var _y:Number = launcher_mc.y + Math.random() * 20 - 10;	// 10 to 20
//			//var _x:Number = Math.random() * 20 - 10;	// 10 to 20
//			//var _y:Number = Math.random() * 20 - 10;	// 10 to 20
//			var _rot:Number = Math.random() * 360;							// 0 to 360
//			var _scale:Number = Math.random() * 0.8 + 0.2;  //between 20% and 100%
//			var c:MovieClip;
//			//if( Math.round(Math.random()) == 1){
//			if( pct < 0.50){
//				 c = new Cloud();
//			}else{
//				c = new CloudB();
//			}  // end else
//			c.rotation = _rot;
//			c.scaleX = c.scaleY = _scale;
//			c.x = _x;
//			c.y = _y;
//			addChild(c);
//			
//		} // end if
//	} // end function timePreloader
	
	} // end class timePreloader
} // end package timePreloader
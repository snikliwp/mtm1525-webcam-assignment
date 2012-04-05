package  {
	
	import flash.display.MovieClip;
	import flash.media.Camera;
	import flash.media.Video;
	
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flash.utils.Timer;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.media.Camera;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ActivityEvent;
	import flash.media.Sound;

	
	public class webcam extends MovieClip {
		public var camera:Camera;
		public var imgData:BitmapData;
		public var img:Bitmap;
		public var clockTimer:Timer = new Timer(50, 1);
		public var shutterTimer:Timer = new Timer(1000, 1);
//		public var speed:Number = -4;
//		public var rotSpeed:Number = 2;
		public var time:Date;
		
		public function webcam() {
trace('In function webcam: ');
			// constructor code
//			clockTimer = new Timer(1000);
//			clockTimer.addEventListener(TimerEvent.TIMER, runClock);
//			clockTimer.start();

			clock_mc.visible = false;
			selector_mc.visible = false;
			selectorText_mc.visible = false;
			selectorButton_mc.visible = false;
//			picTaker_mc.visible = false;
//			camera_mc.visible = false;
//			myVideo.visible = false;
			Security.showSettings(SecurityPanel.CAMERA);
			// Security.showSettings(SecurityPanel.MICROPHONE);
			// Security.showSettings(SecurityPanel.PRIVACY);
			camera = Camera.getCamera();
//			trace(Camera.names.length);
//			trace(Camera.names[0]);
			camera.setMode(640, 480, this.stage.frameRate);
			camera.setMotionLevel(10, 1500);	
			if(camera != null){
				myVideo.attachCamera(camera);
				picTaker_mc.shutter_mc.buttonMode = true;
				picTaker_mc.shutter_mc.addEventListener(MouseEvent.CLICK, capture);
//				create an image that matches the size of the video object
				imgData = new BitmapData(myVideo.width, myVideo.height);
				img = new Bitmap(imgData);
				
				selector_mc.handles_mc.start();
				selector_mc.img_mc.mask = selector_mc.handles_mc.fMask;
//				save_mc.addEventListener(MouseEvent.CLICK, saveImg);
			}else{
//				trace("You need a camera");
			} // end if
//			runClock();
		} // end Function webcam
		
		
		public function runClock(ev) {
trace('In function runClock: ');
			
			time=new Date(); // time object
			clock_mc.visible = true;
			var seconds = time.getSeconds()
			var minutes = time.getMinutes()
			var hours = time.getHours()
			
			clock_mc.secondHand_mc.rotation = 6 * seconds; // giving rotation property
			clock_mc.smallHand_mc.rotation = 30 * hours + minutes / 2; // giving rotation property
			clock_mc.bigHand_mc.rotation = 6 * minutes; // giving rotation property
		}  // end class runClock
		
		public function capture(ev:MouseEvent) {
trace('In function capture: ');
			// play a shutter sound
			var shutterRelease:Sound = new cameraClick();
			shutterRelease.play();
			// close the shutter
			myVideo.visible = false;
			imgData.draw(myVideo);
			img.smoothing = true;	//to help with the scale
			img.scaleX = img.scaleY = 2;	//make it double the size of the video.
///			myVideo.visible = false;
			//place the image captured from the webcam into the mask creator
			selector_mc.img_mc.addChild(img);
			shutterTimer = new Timer(1000, 1);
			shutterTimer.addEventListener(TimerEvent.TIMER, setUp);
			shutterTimer.start();
		}
		
		public function setUp(ev) {
trace('In function setUp: ');
			picTaker_mc.visible = false;
			selector_mc.visible = true;
			selectorText_mc.visible = true;
			selectorButton_mc.visible = true;
			selectorButton_mc.addEventListener(MouseEvent.CLICK, saveImg);
					
			}

		public function saveImg(ev:MouseEvent):void{
trace('In function saveImg: ');
			//hide handles
			selector_mc.handles_mc.toggleHandles(false); //?
			
			//get bounding box as an array of min and max x and y values
			var r:Object = selector_mc.handles_mc.getPicBounds();
//			trace("(",r.minX, r.minY,") (", r.maxX, r.maxY, ")");
			
			//get handles and control points
			var p:Object = selector_mc.handles_mc.getPoints();
			//convert to global points
			//example: handles_mc.localToGlobal( aPoint );
			var p1:Point = selector_mc.handles_mc.localToGlobal( new Point(r.minX, r.minY) );
trace('p1 = : ', p1);			
			var p2:Point = selector_mc.handles_mc.localToGlobal( new Point(r.maxX, r.maxY) );
trace('p2 = : ', p2);			
			var tempW:Number = p2.x - p1.x;
			var tempH:Number = p2.y - p1.y;
			var rct:Rectangle = new Rectangle(p1.x, p1.y, tempW, tempH); 
trace('p1.x, p1.y, tempW, tempH: ', p1.x, p1.y, tempW, tempH); 
trace('rct = : ', rct);			
							
			
			var imgDataSource:BitmapData = new BitmapData(selector_mc.width, selector_mc.height, true, 0x00FF0000);
			imgDataSource.draw(selector_mc);
			//now trim the image
			imgData = new BitmapData(rct.width, rct.height);
			imgData.copyPixels(imgDataSource, rct, new Point(0,0));
			img = new Bitmap(imgData, "always", true);
			img.smoothing = true;
			
			var mc:MovieClip = new MovieClip();
			mc.cacheAsBitmap = true;
			
			mc.addChild( img );
			addChild(mc);
			selector_mc.visible = false;
			selectorButton_mc.visible = false;
			selectorText_mc.visible = false;
			clock_mc.visible = true;
			
			
			//get the target size BEFORE adding the image
			var smallWidth:Number = clock_mc.clockFace_mc.width;
			var smallHeight:Number = clock_mc.clockFace_mc.height;
trace('smallWidth, mc.Width: ', smallWidth, mc.width);
trace('smallHeight, mc_Height: ', smallHeight, mc.height);
			//place head on character
			clock_mc.addChild(mc);
			//size and position the head
			var xratio:Number = 1;
			var yratio:Number = 1;
			//calculate the ratio between the sizes in order to resize the image to match the oval
			if( mc.width > smallWidth ){
trace('mc.width is greater than smallWidth');
				xratio = smallWidth/mc.width;
				yratio = smallHeight/mc.height;
			}else{
trace('mc.width is less than smallWidth');
				xratio = mc.width/smallWidth;
				yratio = mc.height/smallHeight;
trace('xratio, y ratio: ', xratio, yratio);

}
			mc.scaleX = xratio;	//make it slightly bigger for bobble head effect
			mc.scaleY = yratio;
trace('mc.width * xratio = ', mc.width * xratio);
trace('mc.height * yratio = ', mc.height * yratio);
trace('clock_mc.mc, clock_mc.mc = ', clock_mc.mc, clock_mc.mc);
//trace('clock_mc.mc.width, clock_mc.mc.height = ', clock_mc.mc.width, clock_mc.mc.height);
			//hide the oval after adding the real image head
			clock_mc.clockFace_mc.visible = false;
			//move the head to the center of the head_mc registration point
			mc.x = -(mc.width/2);
			mc.y = -(mc.height/2);
//			
//			character_mc.addEventListener(Event.ENTER_FRAME, move);
		}
		
		
		
	} // end class webcam
	
} // end Package

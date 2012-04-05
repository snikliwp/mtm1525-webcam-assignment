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
		public var mc:MovieClip;
		
		public function webcam() {
trace('In function webcam: ');
			// constructor code

			clock_mc.visible = false;
			selector_mc.visible = false;
			selectorText_mc.visible = false;
			selectorButton_mc.visible = false;
//			picTaker_mc.visible = false;
//			camera_mc.visible = false;
//			myVideo.visible = false;
			// Security.showSettings(SecurityPanel.CAMERA);
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
				selector_mc.img_mc.mask = selector_mc.handles_mc.fMask; // ? fmask is not set anywhere and is not a selected word? what is this for
//				save_mc.addEventListener(MouseEvent.CLICK, saveImg);
			}else{
//				trace("You need a camera");
			} // end if
//			runClock();
		} // end Function webcam
		
		
		public function runClock(ev) {
trace('In function runClock: ');
			
			time=new Date(); // time object
//			clock_mc.visible = true;
			var seconds = time.getSeconds()
			var minutes = time.getMinutes()
			var hours = time.getHours()
			
			clock_mc.secondHand_mc.rotation = 6 * seconds; // giving rotation property
trace('In function runClock: 1');
			mc.rotation = (-6 * seconds); // giving rotation property
			// clock_mc.secondHand_mc.mc.rotation = (-6 * seconds);
trace('In function runClock: 2');
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
			shutterTimer = new Timer(500, 1);
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
			selector_mc.handles_mc.visible=false;
			var rct:Rectangle = selector_mc.handles_mc.fMask.getBounds(selector_mc);	//get the bounding box around the Sprite which is being used as a mask
			trace(rct.left, rct.top, rct.width, rct.height);

			var imgDataSource:BitmapData = new BitmapData(selector_mc.width, selector_mc.height, true, 0x00FF0000);
			imgDataSource.draw(selector_mc); // ? why selector ?
			//now trim the image
			imgData = new BitmapData(rct.width, rct.height);
			imgData.copyPixels(imgDataSource, rct, new Point(0,0));
			img = new Bitmap(imgData, "always", true);
			img.smoothing = true;
			
			mc = new MovieClip();
			mc.name = "mc";
			mc.cacheAsBitmap = true;
			
			mc.addChild( img );
			img.x = -img.width/2;
			img.y = -img.height/2;
//			addChild(mc);
			selector_mc.visible = false;
			selectorButton_mc.visible = false;
			selectorText_mc.visible = false;
			
			
			//get the target size BEFORE adding the image
			var smallWidth:Number = clock_mc.secondHand_mc.landing_mc.width;
			var smallHeight:Number = clock_mc.secondHand_mc.landing_mc.height;
trace('smallWidth, mc.Width: ', smallWidth, mc.width);
trace('smallHeight, mc_Height: ', smallHeight, mc.height);
			//place head on character
			clock_mc.secondHand_mc.addChild(mc);
			//size and position the head
			var xratio:Number = 1;
			var yratio:Number = 1;
			//calculate the ratio between the sizes in order to resize the image to match the oval
				xratio = smallWidth/mc.width;
				yratio = smallHeight/mc.height;

			mc.scaleX = xratio;	//make it slightly bigger for bobble head effect
			mc.scaleY = yratio;
trace('mc.width * xratio = ', mc.width * xratio);
trace('mc.height * yratio = ', mc.height * yratio);
trace('mc.width / xratio = ', mc.width / xratio);
trace('mc.height / yratio = ', mc.height / yratio);
//trace('clock_mc.mc, clock_mc.mc = ', clock_mc.mc, clock_mc.mc);
//trace('clock_mc.mc.width, clock_mc.mc.height = ', clock_mc.mc.width, clock_mc.mc.height);
			//hide the oval after adding the real image head
			clock_mc.secondHand_mc.landing_mc.visible = false;
			//move the head to the center of the head_mc registration point
			mc.x = 0; //-(mc.width/2);
			mc.y = -100; //-(mc.height/2)+ (clock_mc.secondHand_mc.landing_mc.y);
			clock_mc.visible = true;
			clockTimer = new Timer(1000);
			clockTimer.addEventListener(TimerEvent.TIMER, runClock);
			clockTimer.start();
//			runClock();
//			character_mc.addEventListener(Event.ENTER_FRAME, move);
		}
		
		
		
	} // end class webcam
	
} // end Package

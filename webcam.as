package  {
	
	import flash.media.Camera;
	import flash.media.Video;
	
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flash.utils.Timer;
	
	import flash.system.Security;
	import flash.system.SecurityPanel;
	
	import flash.media.Camera;
	import flash.media.Sound;
	
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ActivityEvent;
	
	public class webcam extends MovieClip {
		// set up the class variables
		public var camera:Camera;
		public var imgData:BitmapData;
		public var img:Bitmap;
		public var clockTimer:Timer = new Timer(50, 1);
		public var shutterTimer:Timer = new Timer(1000, 1);
		public var time:Date;
		public var mc:MovieClip;
		
		public function webcam() {
			// constructor code
			stage.addEventListener(MouseEvent.CLICK, giveHelp);

			help_mc.visible = false;
			errorTxt_mc.visible = false;
			clock_mc.visible = false;
			selector_mc.visible = false;
			selectorText_mc.visible = false;
			selectorButton_mc.visible = false;
			// Security.showSettings(SecurityPanel.CAMERA); // uncomment this line if the program does not recognize the webcam
			// Security.showSettings(SecurityPanel.MICROPHONE);
			// Security.showSettings(SecurityPanel.PRIVACY);
			// set up the camera to capture imgaes from the webcam
			camera = Camera.getCamera();
			camera.setMode(640, 480, this.stage.frameRate);
//			camera.setMotionLevel(10, 1500);	// don't think i need this
			if(camera != null){
				myVideo.attachCamera(camera);
				picTaker_mc.shutter_mc.buttonMode = true;
				picTaker_mc.shutter_mc.addEventListener(MouseEvent.CLICK, capture);
				// create an image that matches the size of the video object
				imgData = new BitmapData(myVideo.width, myVideo.height);
				img = new Bitmap(imgData);
				// fire up the handles class
				selector_mc.handles_mc.start();
				selector_mc.img_mc.mask = selector_mc.handles_mc.fMask; // 
				}else{
				errorTxt_mc.visible = true;
			} // end if
		} // end Function webcam
		
		
		public function runClock(ev) {
trace('In function runClock: ');
			
			time=new Date(); // time object
			var seconds = time.getSeconds()
			var minutes = time.getMinutes()
			var hours = time.getHours()
			
			clock_mc.secondHand_mc.rotation = 6 * seconds; // giving rotation property
			mc.rotation = (-6 * seconds); // giving rotation property
			clock_mc.smallHand_mc.rotation = 30 * hours + minutes / 2; // giving rotation property
			clock_mc.bigHand_mc.rotation = 6 * minutes; // giving rotation property
		}  // end Function runClock
		
		public function capture(ev:MouseEvent) {
			// play a shutter sound
			var shutterRelease:Sound = new cameraClick();
			shutterRelease.play();
			// close the shutter
			myVideo.visible = false;
			// save the picture
			imgData.draw(myVideo);
			img.smoothing = true;	//to help with the scale
			img.scaleX = img.scaleY = 2;	//make it double the size of the video.
			//place the image captured from the webcam into the mask creator
			selector_mc.img_mc.addChild(img);
			// wait half a second so the user an appreciate the shutter closing
			shutterTimer = new Timer(500, 1);
			shutterTimer.addEventListener(TimerEvent.TIMER, setUp);
			shutterTimer.start();
		}  // end Function capture
		
		public function setUp(ev) {
			// turn off the picture taker screen elements
			picTaker_mc.visible = false;
			help_mc.visible = false;
			// Turn on the image mask elements
			selector_mc.visible = true;
			selectorText_mc.visible = true;
			selectorButton_mc.visible = true;
			// wait for the user to click OK
			selectorButton_mc.addEventListener(MouseEvent.CLICK, saveImg);
		}  // end Function setUp
			
		public function giveHelp(ev:MouseEvent):void{
			// The user can't find the shutter
			help_mc.visible = true;
			stage.removeEventListener(MouseEvent.CLICK, giveHelp);
		}  // end Function giveHelp

		public function saveImg(ev:MouseEvent):void{
			//get the bounding box around the Sprite which is being used as a mask
			var rct:Rectangle = selector_mc.handles_mc.fMask.getBounds(selector_mc);
			// take the image and store it in a bitmap
			var imgDataSource:BitmapData = new BitmapData(selector_mc.width, selector_mc.height, true, 0x00FF0000);
			imgDataSource.draw(selector_mc);
			//now trim the image
			imgData = new BitmapData(rct.width, rct.height);
			imgData.copyPixels(imgDataSource, rct, new Point(0,0));
			img = new Bitmap(imgData, "always", true);
			img.smoothing = true;
			// put the trimmed image into a movie clip
			mc = new MovieClip();
			mc.name = "mc"; // in case you want to call it by a name
//			mc.cacheAsBitmap = true;
			mc.addChild( img );
			// change the image's registration point to center on the movie clipc' registration point
			img.x = -img.width/2;
			img.y = -img.height/2;
			// turn off the image mask elements
			selector_mc.handles_mc.visible=false;
			selector_mc.visible = false;
			selectorButton_mc.visible = false;
			selectorText_mc.visible = false;
			
			//get the target size BEFORE adding the image
			var smallWidth:Number = clock_mc.secondHand_mc.landing_mc.width;
			var smallHeight:Number = clock_mc.secondHand_mc.landing_mc.height;
			//place image on the second hand 
			clock_mc.secondHand_mc.addChild(mc);
			//size and position the head
			var xratio:Number = 1;
			var yratio:Number = 1;
			//calculate the ratio between the sizes in order to resize the image to match the landing
			xratio = smallWidth/mc.width;
			yratio = smallHeight/mc.height;
			mc.scaleX = xratio;	//scale it so it occupies the same space as the landing
			mc.scaleY = yratio;
			//hide the landing after adding the real image
			clock_mc.secondHand_mc.landing_mc.visible = false;
			//move the image to the same center as the landing 
			mc.x = 0; //-(mc.width/2);
			mc.y = -100; //-(mc.height/2)+ (clock_mc.secondHand_mc.landing_mc.y);
			// make the clock visible
			clock_mc.visible = true;
			// set up a timer to trip every minute forever
			clockTimer = new Timer(1000);
			// give it a listener to run the clock
			clockTimer.addEventListener(TimerEvent.TIMER, runClock);
			// sart the timer
			clockTimer.start();
		}  // end Function saveImg

		
		
		
	} // end class webcam
	
} // end Package

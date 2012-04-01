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

	
	public class webcam extends MovieClip {
		public var camera:Camera;
		public var imgData:BitmapData;
		public var img:Bitmap;
		public var clockTimer:Timer = new Timer(50, 1);
		public var speed:Number = -4;
		public var rotSpeed:Number = 2;
		public var time:Date;
		
		public function webcam() {
trace('In function webcam: ');
			// constructor code
			clockTimer = new Timer(1000);
			clockTimer.addEventListener(TimerEvent.TIMER, runClock);
			clockTimer.start();

//			clock_mc.visible = false;
//			imgFilter_mc.visible = false;
			//  Security.showSettings(SecurityPanel.CAMERA);
			// Security.showSettings(SecurityPanel.MICROPHONE);
			// Security.showSettings(SecurityPanel.PRIVACY);
			// camera = Camera.getCamera();
//			trace(Camera.names.length);
//			trace(Camera.names[0]);
			// camera.setMode(640, 480, this.stage.frameRate);
			// camera.setMotionLevel(10, 1500);	
			// if(camera != null){
				// myVideo.attachCamera(camera);
	//			takePic_btn.addEventListener(MouseEvent.CLICK, capture);
				//create an image that matches the size of the video object
	//			imgData = new BitmapData(myVideo.width, myVideo.height);
//				img = new Bitmap(imgData);
				
//				imgFilter_mc.handles_mc.start();
//				imgFilter_mc.img_mc.mask = imgFilter_mc.handles_mc.fMask;
//				save_mc.addEventListener(MouseEvent.CLICK, saveImg);
//			}else{
//				trace("You need a camera");
//			} // end if
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
		
		
	} // end class webcam
	
} // end Package

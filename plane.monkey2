Namespace plane

#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"

#Import "source/LoadScene"
#Import "source/LoadingScreen"
#Import "source/VehicleControl"
#Import "source/CameraControl"
#Import "source/Noise3D"
#Import "source/Airplane"
#Import "source/Smooth"
#Import "source/Echo"
#Import "source/Util"

#Import "extensions/Model"

#Import "textures/"
#Import "models/"
#Import "audio/"

Using std..
Using mojo..
Using mojo3d..
Using util..

Class PlaneDemo Extends Window
	
	Protected

	Field _scene:Scene
	
	Field _camBase:Entity
	Field _camTarget:Entity
	Field _camOrbit:Entity
	Field _camPan:Entity
	
	Field _camera1:Camera
	Field _camera2:Camera
	Field _activeCamera:Camera
	
	Field _light:Light
	Field _water:Model
	Field _plane:Model
	Field _pivot:Entity
	Field _monkey:Model
	
	Field _channelMusic:Channel
	Field _channelSfx0:Channel
	Field _sfxEngine:Sound

	Field _drawInfo:= False 	
	Field _init := False
	Field _firstFrame := True
	Field _res :Vec2i
	
	Field _fade := 0.0
	Field _fadeStart := 0.0
	Field _fadeLength := 4.0
	
	Field _loadingScreen :Image
	
	Public
	
	Method New()
		Super.New( "Flying Monkey", 1440, 720, WindowFlags.Resizable | WindowFlags.HighDPI  )
		_res = New Vec2i( Width, Height )
		Print _res
		Layout = "letterbox"
		
		'We need to create a scene before loading any models
		_scene=New Scene
		
		'The first thing we load is the loading screen itself.
		_loadingScreen = Image.Load( "asset::loading.png", Null, TextureFlags.FilterMipmap )
	End
	
	
	Method OnRender( canvas:Canvas ) Override
		
		RequestRender()
		
		'Loading screen + load assets.
		If Not _init
			If _firstFrame
				DrawLoadingScreen( canvas )
				_firstFrame = False
				Return
			End
			LoadScene()
			_fadeStart = Now()
			_init = True
			Print"~nAssets Loaded...~n"
			Return
		End
		
		'If _init is over and all assets are loaded, we simply update and render each frame
		_water.Position=New Vec3f( Round(_pivot.Position.x/2000)*2000,0,Round(_pivot.Position.z/2000)*2000 )
		
		If Keyboard.KeyHit( Key.Key1 ) _activeCamera = _camera1
		If Keyboard.KeyHit( Key.Key2 ) _activeCamera = _camera2
		
		If Keyboard.KeyHit( Key.Tab )
			_drawInfo = Not _drawInfo
		End
		
		Select _activeCamera
			Case _camera1
				_camBase.PointAt( _camTarget.Position )
			Case _camera2
				_camera2.PointAt( _plane.Position )
		End
		
		Echo( "Width="+Width+", Height="+Height )
		Echo( "FPS="+App.FPS )
		Echo( "Aspect=" + Format(_activeCamera.Aspect) )
		Echo( _scene )
		
		_scene.Update()
		_activeCamera.Render( canvas )
		
		If _fade < 1.0
			_fade = ( Now() - _fadeStart ) / _fadeLength
			canvas.Color = Color.Black
			canvas.Alpha = 1.0 - _fade
			canvas.DrawRect( 0, 0, Width, Height )
			_fade = Clamp( _fade, 0.0, 1.0 )
		End
		
		If _drawInfo
			DrawEcho( canvas, 10, 8, 0.25 )
		Else
			_echoStack.Clear()
			_colorStack.Clear()	
		End
	End
	
	
	Method OnMeasure:Vec2i() Override
		Return _res
	End
	
End

Function Main()
	New AppInstance
	New PlaneDemo
	App.Run()
End







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
	Field _light:Light
	Field _water:Model
	Field _camera1:Camera
	Field _camera2:Camera
	
	Field _activeCamera:Camera
	Field _camDolly:Entity
	Field _camTarget:Entity
	Field _camOrbit:Entity
	Field _camPan:Entity
	Field _camNoise:Entity
	
	Field _pivot:Entity
	Field _plane:Model
	Field _monkey:Model

	Field _channelMusic:Channel
	Field _channelSfx0:Channel
	Field _sfxEngine:Sound

	Field _drawInfo:= False 	
	Field _init := False
	Field _firstFrame := True
	Field _res :Vec2i
	Field _showHelp := True
	Field _sampling := 1.0
	
	Field _fade := 0.0
	Field _fadeStart := 0.0
	Field _fadeLength := 4.0
	
	Field _loadingScreen :Image
	Field _helpScreen :Image
	Field _textureTarget:Image
	Field _textureCanvas:Canvas
	
	Public
	
	Method New()
		Super.New( "Flying Monkey", 1440, 720, WindowFlags.Resizable | WindowFlags.HighDPI  )
		_res = New Vec2i( Width, Height )
		Layout = "letterbox"
		Print "Canvas size: " + _res.X + "," + _res.Y
		
		'We need to create a scene before loading any models
		_scene=New Scene
		
		'The first thing we load is the loading screen itself.
		_loadingScreen = Image.Load( "asset::loading.png", Null, TextureFlags.FilterMipmap )
	End
	
	
	Method OnRender( canvas:Canvas ) Override
		
		RequestRender()
		
		'Loading screen + load assets. If all assets are loaded, we skip this and update and render each frame
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
		
		'Water placement.Simply follows the plane around!
		_water.Position=New Vec3f( Round(_pivot.Position.x/2000)*2000,0,Round(_pivot.Position.z/2000)*2000 )
		
		'Input
		If Keyboard.KeyHit( Key.Key1 )
			_activeCamera = _camera1
			_monkey.Visible = True
		End
		
		If Keyboard.KeyHit( Key.Key2 )
			_activeCamera = _camera2
			_monkey.Visible = False
		End
		
		If Keyboard.KeyHit( Key.Tab )
			_drawInfo = Not _drawInfo
		End
		
		If Keyboard.KeyHit( Key.Escape )
			_showHelp = Not _showHelp
		End
		
		If Keyboard.KeyHit( Key.Slash )
			_sampling *= 2.0
			If _sampling > 2.0 Then _sampling = 0.5
			
			_textureTarget = New Image( Width * _sampling, Height * _sampling, TextureFlags.Filter | TextureFlags.Dynamic )
			_textureCanvas = New Canvas( _textureTarget )
		End
		
		'Draw stuff
		canvas.Alpha = 1.0
		canvas.Color = Color.White
		
		_textureCanvas.Flush()
		canvas.DrawImage( _textureTarget, 0, Height, 0.0, 1.0/_sampling, -1.0/_sampling ) 
		
		_scene.Update()
		_activeCamera.Render( _textureCanvas )
		
		Echo( "Width="+Width+", Height="+Height )
		Echo( "FPS="+App.FPS )
		Echo( "Aspect=" + Format(_activeCamera.Aspect) )
		Echo( _scene )
		
		If _showHelp
			canvas.DrawRect(0, 0, Width, Height, _helpScreen )
		End
		
		If _drawInfo And Not _showHelp
			DrawEcho( canvas, 10, 8, 0.75 )
		Else
			_echoStack.Clear()
			_colorStack.Clear()	
		End
		
		If _fade < 1.0
			_fade = ( Now() - _fadeStart ) / _fadeLength
			canvas.Color = Color.Black
			canvas.Alpha = 1.0 - _fade
			canvas.DrawRect( 0, 0, Width, Height )
			_fade = Clamp( _fade, 0.0, 1.0 )
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







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
#Import "source/Fader"
#Import "source/SmoothDelta"
#Import "source/Graph"

#Import "extensions/Model"
#Import "extensions/Canvas"

#Import "textures/"
#Import "gui/"
#Import "models/"
#Import "audio/"
#Import "fonts/"

Using std..
Using mojo..
Using mojo3d..
Using util..

Class PlaneDemo Extends Window
	
	Protected

	Field _scene:Scene
	Field _light:Light
	Field _water:Model

	Field _activeCamera:Camera
	Field _camera1:Camera
	Field _camera2:Camera
	
	Field _pivot:Entity
	Field _plane:Model
	Field _monkey:Model

	Field _channelMusic:Channel
	Field _channelSfx0:Channel
	Field _sfxEngine:Sound

	Field _drawInfo:= False 
	Field _drawGraph:= False 	
	Field _init := False
	Field _firstFrame := True
	Field _res :Vec2f
	Field _showHelp := False
	Field _originalAspect: Float
	Field _sampling := 1.0
	
	Field _fade := 0.0
	Field _fadeStart := 0.0
	Field _fadeLength := 4.0
	
	Field _fadeScreen: Image
	Field _loadingScreen :Image
	Field _helpScreen :Image
	Field _renderTarget:Image
	Field _renderCanvas:Canvas
	
	Public
	
	Method New()
		Super.New( "Flying Monkey", 1440, 720, WindowFlags.Resizable | WindowFlags.HighDPI  )
		_res = New Vec2f( Width, Height )
		_originalAspect = _res.x / _res.y
		Layout = "letterbox"
		
		'We need to create a scene before loading any models
		_scene=New Scene
		
		'Setup image as a render target
		CreateImageCanvas()
		
		'The first thing we load is the loading screen itself.
		_loadingScreen = Image.Load( "asset::loading.png", Null, TextureFlags.FilterMipmap )
		_fadeScreen = Image.Load( "asset::fader.png", Null, TextureFlags.FilterMipmap )
		
		
		Local test:= 1/Double(2)
		Print Typeof( test )
		
	End
	
	
	Method OnRender( canvas:Canvas ) Override
		
		'We want to render every time the app is updated.
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
			New StackedMessage( "Third person camera" )
		End
		
		If Keyboard.KeyHit( Key.Key2 )
			_activeCamera = _camera2
			_monkey.Visible = False
			New StackedMessage( "First person camera" )
		End
		
		If Keyboard.KeyHit( Key.Tab )
			_drawInfo = Not _drawInfo
			New StackedMessage( "Toggle debug info")
		End
		
		If Keyboard.KeyHit( Key.G )
			_drawGraph = Not _drawGraph
			New StackedMessage( "Toggle debug graph")
		End
		
		If Keyboard.KeyHit( Key.Escape )
			_showHelp = Not _showHelp
			Message.ClearAll()
		End
		
		If Keyboard.KeyHit( Key.Slash )
			_sampling *= 2.0
			If _sampling > 2.0 Then _sampling = 0.25
			New StackedMessage( "Render quality set to " + Format(_sampling, 2) )
			CreateImageCanvas()
		End
		
		'Draw stuff
		_scene.Update()
		_activeCamera.Render( _renderCanvas )
		_renderCanvas.Flush()
		
		canvas.Alpha = 1.0
		canvas.Color = Color.White
		
		'Camera renders upside down, for some reason?
		canvas.PushMatrix()
		canvas.Scale( 1.0, -1.0 )
		canvas.Translate( 0, -Height )
		canvas.DrawImage( _renderTarget, 0, 0, 0.0, 1.0/_sampling, 1.0/_sampling )
		canvas.PopMatrix()
		
		'Debug messages and miscellaneous view options.
		Echo.Add( "Window Resolution: " + Frame.Width + "," + Frame.Height )
		Echo.Add( "Image target="+_renderTarget.Width+","+_renderTarget.Height )
		Echo.Add( "FPS="+App.FPS, Color.Green )
		Echo.Add( "Aspect=" + Format(_activeCamera.Aspect) )
		Echo.Add( "Pivot Ry:" + _pivot.Ry, Color.Yellow )
		Echo.Add( _scene )
		
		'Miscellaneous helpers
		If _showHelp
			canvas.DrawRect(0, 0, Width, Height, _helpScreen )
		End
		
		If _drawInfo And Not _showHelp
			Echo.Draw( canvas, 10, 8, 0.75 )
		Else
			Echo.Clear()
		End
		
		If _drawGraph And Not _drawInfo And Not _showHelp
			Graph.DrawAll( canvas, Height * 0.3, 45 )
		End
		
		'Draws all "fader" objects (messages, fadeIn/Out, etc.)
		Fader.DrawAll( canvas )
		
	End
	
	
	'This method is called whenever the window changes size or is created. The "letterbox" layout  depends on it.
	Method OnMeasure:Vec2i() Override
'		_res = New Vec2f( Frame.Width, Frame.Width / _originalAspect )
		Return _res
	End
	
	
	Method CreateImageCanvas()
		'Image uses "Dynamic" flags because it is updated on every frame.
		_renderTarget = New Image( _res.X * _sampling, _res.Y * _sampling, TextureFlags.FilterMipmap | TextureFlags.Dynamic, Null )
		_renderCanvas = New Canvas( _renderTarget )
		Print ( "New Texture Canvas: " + _renderTarget.Width + "," + _renderTarget.Height )
	End
	
End

Function Main()
	New AppInstance
	New PlaneDemo
	App.Run()
End







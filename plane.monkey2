
Namespace plane

#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"
'#Import "<mojo3d-loaders>"

#Import "source/PlaneControl"
#Import "source/Noise3D"

#Import "textures/"
#Import "assets/"

Using std..
Using mojo..
Using mojo3d..

Class MyWindow Extends Window
	
	Field _res :Vec2i
	
	Field _scene:Scene
	
	Field _camera1:Camera
	Field _camera2:Camera
	Field _camera3:Camera
	Field _activeCamera:Camera
	
	Field _light:Light
'	Field _fog:FogEffect
	
	Field _water:Model
	Field _plane:Model
	Field _pivot:Model		'Needs to be a Model instead of Entity otherwise the plane isn't rendered!
		
	Field _camTarget:Entity
	Field test:Model
	
	
	Method New()
		Super.New( "Toy Plane", 1280, 720, WindowFlags.Resizable )'| WindowFlags.HighDPI  )
		_res = New Vec2i( Width, Height )
		Print _res
		Layout = "fill"
		
'		SetConfig( "MOJO3D_RENDERER","forward" )
		
		_scene=New Scene
		_scene.SkyTexture=Texture.Load( "asset::miramar-skybox.jpg",TextureFlags.FilterMipmap|TextureFlags.Cubemap )
		_scene.EnvTexture = _scene.SkyTexture
		_scene.FogColor = New Color(1.0, 0.9, 0.8, 0.2 )
		_scene.AmbientLight = New Color( 0.4, 0.6, 0.8, 1.0 )
		_scene.FogFar = 10000
		_scene.FogNear = 1
		
		'create light
		_light=New Light
		_light.Rotate( 45, 45, 0 )
		_light.CastsShadow = True
		_light.Color = New Color( 1.2, 1.0, 0.8, 1.0 )
		
		'create water material
		Local waterMaterial:=New WaterMaterial
		
		waterMaterial.ScaleTextureMatrix( 300,300 )
		waterMaterial.ColorFactor=New Color( 0.025, 0.125, 0.15 )
		waterMaterial.Roughness=0
		
		waterMaterial.NormalTextures=New Texture[]( 
			Texture.Load( "asset::water_normal0.png",TextureFlags.WrapST | TextureFlags.FilterMipmap ),
			Texture.Load( "asset::water_normal1.png",TextureFlags.WrapST | TextureFlags.FilterMipmap ) )
		
		waterMaterial.Velocities=New Vec2f[]( 
			New Vec2f( .01,.03 ),
			New Vec2f( .02,.05 ) )
		
		'create water
		_water=Model.CreateBox( New Boxf( -10000,-1,-10000,10000,0,10000 ),1,1,1,waterMaterial )
		
		'create bloom
		Local _bloom := New BloomEffect
		_scene.AddPostEffect( _bloom )
		
		'create main pivot
		_pivot = New Model
		
		'create airplane
		_plane = Model.LoadBoned( "asset::plane/plane.gltf" )
'		_plane = Model.LoadBoned( "asset::plane.fbx" )
		_plane.Animator.Animate( 0 )
		_plane.Parent = _pivot
		
		'Replace Pbr material with textures exported from Substance Painter
		Local mat := PbrMaterial.Load( "asset::plane.pbr", TextureFlags.FilterMipmap )
		_plane.AssignMaterialToHierarchy( mat )

		'create camera target
		_camTarget = New Entity( _pivot )
		
		Local camShake := _camTarget.AddComponent< Noise3D >()
		camShake.AddCurve( Axis.X, 1.0, 0.2, SINE, 0.0 )
		camShake.AddCurve( Axis.X, 0.1, 1.5, SMOOTH, 0.0 )
		
		camShake.AddCurve( Axis.Y, 0.5, 0.5, SINE, 100.0 )
		camShake.AddCurve( Axis.Y, 0.1, 2.5, SMOOTH, 100.0 )
		
		camShake.AddCurve( Axis.Z, 1.0, 0.1, SINE, 200.0 )
		camShake.AddCurve( Axis.Z, 0.1, 0.2, SMOOTH, 200.0 )
		
		camShake.Y = -1.0	'base value added to the curve generators. Acts like a parent transform.
		camShake.Z = -10.0

		'create camera
		_camera1=New Camera( _pivot )
		_camera1.View = Self
		_camera1.Near=.1
		_camera1.Far=10000
		_camera1.FOV = 75
		_camera1.Move( 0,4,8 )
		_activeCamera = _camera1
		
		'create camera
		_camera2=New Camera( _pivot )
		_camera2.View = Self
		_camera2.Near=.1
		_camera2.Far=10000
		_camera2.FOV = 60
		_camera2.Move( 0,3,-8 )
		
		'create camera
		_camera3=New Camera( _pivot )
		_camera3.View = Self
		_camera3.Near=.1
		_camera3.Far=10000
		_camera3.FOV = 75
		_camera3.Move( 8,8,8 )
		
		'Control component
		Local control := _pivot.AddComponent< PlaneControl >()
		control.plane = _plane
		control.camera = _camera1
		control.target = _camTarget

		_pivot.Position = New Vec3f( 0, 6, 0 )
	End
	
	
	Method OnRender( canvas:Canvas ) Override
		RequestRender()
		_water.Position=New Vec3f( Round(_pivot.Position.x/2000)*2000,0,Round(_pivot.Position.z/2000)*2000 )
		
		If Keyboard.KeyHit( Key.Key1 ) _activeCamera = _camera1
		If Keyboard.KeyHit( Key.Key2 ) _activeCamera = _camera2
		If Keyboard.KeyHit( Key.Key3 ) _activeCamera = _camera3
		
		Select _activeCamera
			Case _camera1
				_camera1.PointAt( _camTarget.Position )
			Case _camera2
				_camera2.PointAt( _plane.Position )
			Case _camera3
				_camera3.PointAt( _plane.Position )
		End
		
		_scene.Update()
		_activeCamera.Render( canvas )
		canvas.DrawText( "Width="+Width+", Height="+Height+", FPS="+App.FPS + "    Aspect=" + _activeCamera.Aspect,0,0 )
	End
	
	
	Method OnMeasure:Vec2i() Override
		Return _res
	End
	
End

Function Main()
	New AppInstance
	New MyWindow
	App.Run()
End


Class Model Extension
	
	Method AssignMaterialToHierarchy( mat:Material )
		
		Local matArray := New Material[ Materials.Length ]
		For Local n := 0 Until matArray.Length
			matArray[n] = mat
			
		Next
		
		Print ( "Replacing " + Materials.Length + " materials." )
		Materials = matArray
		
		For Local c := Eachin Children
			Local model := Cast<Model>(c)
			If model
				model.AssignMaterialToHierarchy( mat )
			End
		Next
	End
	
End	




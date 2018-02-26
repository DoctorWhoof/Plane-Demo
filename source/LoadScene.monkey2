Namespace plane

Class PlaneDemo Extension
	
	Method LoadScene()
		
		_scene.SkyTexture = Texture.Load( "asset::miramar-skybox.jpg", TextureFlags.Cubemap | TextureFlags.FilterMipmap )
		_scene.EnvTexture = _scene.SkyTexture
		_scene.FogColor = New Color( 1.0, 0.9, 0.8, 0.2 )
		_scene.AmbientLight = New Color( 0.3, 0.5, 0.65, 1.0 )
		_scene.FogFar = 10000
		_scene.FogNear = 1
		_scene.CSMSplits = New Float[]( 2.0, 4.0, 16.0, 32.0 )
		
		'create light
		_light=New Light
		_light.Rotate( 45, 45, 0 )
		_light.CastsShadow = True
		_light.Color = New Color( 1.2, 1.0, 0.8, 1.0 )
		_light.Name = "Light"

		
		'create water material
		Local waterMaterial:=New WaterMaterial
		
		waterMaterial.ScaleTextureMatrix( 300,300 )
		waterMaterial.ColorFactor=New Color( 0.025, 0.125, 0.15 )
		waterMaterial.Roughness=0
		waterMaterial.NormalTextures=New Texture[](	Texture.Load( "asset::water_normal0.png", TextureFlags.WrapST | TextureFlags.FilterMipmap ),
													Texture.Load( "asset::water_normal1.png", TextureFlags.WrapST | TextureFlags.FilterMipmap ) )
		
		waterMaterial.Velocities=New Vec2f[]( 
			New Vec2f( .01,.03 ),
			New Vec2f( .02,.05 ) )
		
		'create water
		_water=Model.CreateBox( New Boxf( -10000,-1,-10000,10000,0,10000 ),1,1,1,waterMaterial )
		_water.Name = "Water"
		
		'Bloom - A little slow on my laptop, turning it off for now. Will make an option for it later, should be fine on desktop.
'		Local _bloom := New BloomEffect
'		_scene.AddPostEffect( _bloom )
		
		'create main pivot
		_pivot = New Entity
		_pivot.Visible = True
		_pivot.Name = "Pivot"

'		'create airplane
		_plane = Model.LoadBoned( "asset::plane.glb" )
		_plane.AssignMaterialToHierarchy( PbrMaterial.Load( "asset::plane.pbr", TextureFlags.FilterMipmap ) )
		_plane.Parent = _pivot
		_plane.Name = "Plane"
		
		Local cockpit := _plane.GetChild( "cockpit" )
		cockpit.AssignMaterialToHierarchy( PbrMaterial.Load( "asset::cockpit.pbr", TextureFlags.FilterMipmap ) )
		
		Local canopi := _plane.GetChild( "canopi" )
		canopi.Alpha = 0.9
		
		Local planeAnim := _plane.AddComponent< Airplane >()

		'The pilot!
		_monkey = Model.LoadBoned( "asset::monkey.glb" )
		_monkey.AssignMaterialToHierarchy( PbrMaterial.Load( "asset::monkey.pbr", TextureFlags.FilterMipmap ) )
		_monkey.Parent = _plane.GetChild( "cockpit" )
		_monkey.Name = "Monkey"
		_monkey.Scale = New Vec3f( 1.7 )
		_monkey.RotateX( 20 )
		_monkey.MoveY( 0.1 )

		'camera rotator
		_camOrbit = New Entity( _pivot )
		_camOrbit.Name = "CameraOrbit"
		
		'camera pan&tilt
		_camPan = New Entity( _camOrbit )
		_camPan.Name = "CameraPan"
		
		'camera base
		_camBase = New Entity( _camOrbit )
		_camBase.Move( 0,4,8 )
		_camBase.Name = "CameraBase"
		
		'create camera 1
		_camera1=New Camera( _camBase )
		_camera1.View = Self
		_camera1.Near=.1
		_camera1.Far=10000
		_camera1.FOV = 70
		_camera1.Name = "Camera1"
		_activeCamera = _camera1
		
		'create camera 2
		_camera2=New Camera( _camOrbit )
		_camera2.View = Self
		_camera2.Near=.1
		_camera2.Far=10000
		_camera2.FOV = 60
		_camera2.Move( 0,3,-8 )
		_camera2.Name = "Camera2"
		
		_pivot.Position = New Vec3f( 0, 20, 0 )
		
		'create camera target
		_camTarget = New Entity( _camPan )
		_camTarget.Name = "CameraTarget"
		Local shakeMult := 2.0
		Local camShake := _camTarget.AddComponent< Noise3D >()
		camShake.AddCurve( Axis.X, 0.5 * shakeMult, 0.1, SINE, 0.0 )
		camShake.AddCurve( Axis.X, 0.1 * shakeMult, 1.0, SMOOTH, 0.0 )
		
		camShake.AddCurve( Axis.Y, 0.5 * shakeMult, 0.25, SINE, 100.0 )
		camShake.AddCurve( Axis.Y, 0.1 * shakeMult, 1.25, SMOOTH, 100.0 )
		
		camShake.AddCurve( Axis.Z, 0.25 * shakeMult, 0.05, SINE, 200.0 )
		camShake.AddCurve( Axis.Z, 0.1 * shakeMult, 0.1, SMOOTH, 200.0 )
		
'		camShake.Y = -3.0	'base value added to the curve generators. Acts like a parent transform.
'		camShake.Z = -10.0
		
		'Control component
		Local control := _pivot.AddComponent< VehicleControl >()
'		control.cameraBase = _camera1
'		control.cameraTarget = _camTarget		
		control.vehicle = _plane.GetChild( "body" )
		
		'Camera control
		Local camControl := _camOrbit.AddComponent< CameraControl >()
		camControl.target = _camPan
		camControl.camera = _camBase
		
		'Audio
		_channelMusic = Audio.PlayMusic( "asset::MagicForest.ogg")
		_sfxEngine = Sound.Load( "asset::planeLoop_01.ogg" )
		_channelSfx0 = _sfxEngine.Play( True )
		_channelSfx0.Volume = 0.5
	End	
	
	
End 
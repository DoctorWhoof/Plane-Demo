Namespace plane

Class PlaneDemo Extension
	
	Method LoadScene()
		
		'Load help screen
		_helpScreen = Image.Load( "asset::help.png", Null, TextureFlags.FilterMipmap )
		
		'Setup texture as a render target
		_textureTarget = New Image( Width, Height, TextureFlags.FilterMipmap | TextureFlags.Dynamic )
		_textureCanvas = New Canvas( _textureTarget )
		
		'Setup 3D scene
		_scene.SkyTexture = Texture.Load( "asset::miramar-skybox.jpg", TextureFlags.Cubemap | TextureFlags.FilterMipmap )
		_scene.EnvTexture = _scene.SkyTexture
		_scene.FogColor = New Color( 1.0, 0.9, 0.8, 0.2 )
		_scene.AmbientLight = New Color( 0.3, 0.45, 0.6, 1.0 )
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
		_pivot.Position = New Vec3f( 0, 20, 0 )

'		'create airplane
		_plane = Model.LoadBoned( "asset::plane.glb" )
		_plane.AssignMaterialToHierarchy( PbrMaterial.Load( "asset::plane.pbr", TextureFlags.FilterMipmap ) )
		_plane.Parent = _pivot
		_plane.Name = "Plane"
		
		Local cockpit := _plane.GetChild( "cockpit" )
		cockpit.AssignMaterialToHierarchy( PbrMaterial.Load( "asset::cockpit.pbr", TextureFlags.FilterMipmap ) )
		
		Local canopi := _plane.GetChild( "canopi" )
		canopi.AssignMaterialToHierarchy( New PbrMaterial( New Color(0, 0.1, 0, 0.4 ), 0.05, 0.1 ) )
		canopi.Alpha = 0.5
		
		'Plane animation controller
		Local planeAnim := _plane.AddComponent< Airplane >()
		
		'vehicleControl component
		Local control := _pivot.AddComponent< VehicleControl >()		

		'The pilot!
		_monkey = Model.LoadBoned( "asset::monkey.glb" )
		_monkey.AssignMaterialToHierarchy( PbrMaterial.Load( "asset::monkey.pbr", TextureFlags.FilterMipmap ) )
		_monkey.Parent = _plane.GetChild( "cockpit" )
		_monkey.Name = "Monkey"
		_monkey.Scale = New Vec3f( 1.7 )
		_monkey.RotateX( 20 )
		_monkey.MoveY( 0.1 )
		
		Local helmet := Model.LoadBoned( "asset::helmet.glb" )
		helmet.AssignMaterialToHierarchy( PbrMaterial.Load( "asset::helmet.pbr", TextureFlags.FilterMipmap ) )
		helmet.Parent = _monkey
		helmet.Name = "helmet"
		helmet.GetChild( "helmet_glass_low").Alpha = 0.5

		'camera orbit pivot
		_camOrbit = New Entity( _pivot )
		_camOrbit.Name = "CameraOrbit"
		
		'camera dolly
		_camDolly = New Entity( _camOrbit )
		_camDolly.Move( 0,4,8 )
		_camDolly.Name = "CameraDolly"
		
		'create camera target
		_camTarget = New Entity( _camOrbit )
		_camTarget.Name = "CameraTarget"
		
		'Camera noise
		_camNoise = New Entity( _camDolly )
		_camNoise.Name = "CamNoise"
		
		Local camShake := _camNoise.AddComponent< Noise3D >()
		Local shakeMult := 5.0
		Local freqMult := 2.5
		
		camShake.AddCurve( Axis.X, 0.5 * shakeMult, 0.1 * freqMult, SINE, 0.0 )
		camShake.AddCurve( Axis.X, 0.1 * shakeMult, 1.0 * freqMult, SMOOTH, 0.0 )
		
		camShake.AddCurve( Axis.Y, 0.5 * shakeMult, 0.25 * freqMult, SINE, 100.0 )
		camShake.AddCurve( Axis.Y, 0.1 * shakeMult, 1.25 * freqMult, SMOOTH, 100.0 )
		
		camShake.AddCurve( Axis.Z, 0.25 * shakeMult, 0.05 * freqMult, SINE, 200.0 )
		camShake.AddCurve( Axis.Z, 0.1 * shakeMult, 0.1 * freqMult, SMOOTH, 200.0 )
		
		'create camera 1
		_camera1=New Camera( _camNoise )
		_camera1.View = Self
		_camera1.Near=.1
		_camera1.Far=10000
		_camera1.FOV = 70
		_camera1.Name = "Camera1"
		_activeCamera = _camera1
		
		'create camera 2
		_camera2=New Camera( helmet )
		_camera2.View = Self
		_camera2.Near=.1
		_camera2.Far=10000
		_camera2.FOV = 70
		_camera2.Move( 0,1.3,0.2 )
		_camera2.LocalRotation = New Vec3f( 15,180,0 )
		_camera2.Name = "Camera2"
		
		'Camera control
		Local camControl := _camera1.AddComponent< CameraControl >()
		camControl.shaker = _camNoise
		camControl.dolly = _camDolly
		camControl.orbiter = _camOrbit
		
		'Audio
'		_channelMusic = Audio.PlayMusic( "asset::MagicForest.ogg")
		_sfxEngine = Sound.Load( "asset::planeLoop_01.ogg" )
		_channelSfx0 = _sfxEngine.Play( True )
		_channelSfx0.Volume = 0.5
	End	
	
	
End 
Namespace plane

Class PlaneDemo Extension
	
	Method CreateScene()
		
		_scene.SkyTexture = _assets.Get<Texture>( "skybox" )
		_scene.EnvTexture = _scene.SkyTexture
		_scene.FogColor = New Color( 1.0, 0.9, 0.8, 0.2 )
		_scene.AmbientLight = New Color( 0.4, 0.6, 0.8, 1.0 )
		_scene.FogFar = 10000
		_scene.FogNear = 1
		
		'Audio
'		_channelMusic = Audio.PlayMusic( "asset::MagicForest.ogg")
		_sfxEngine = _assets.Get<Sound>( "engineSound" )
		_channelSfx0 = _sfxEngine.Play( True )
		_channelSfx0.Volume = 0.5
		
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
		waterMaterial.NormalTextures=New Texture[]( _assets.Get<Texture>( "waterTexture0" ), _assets.Get<Texture>( "waterTexture1" ) )
		
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
		
		'Control component
		Local control := _pivot.AddComponent< VehicleControl >()
		control.cameraBase = _camera1
		control.cameraTarget = _camTarget		
		control.vehicle = _plane		

'		'create airplane
		_plane = _assets.Get<Model>( "plane" )
		_plane.Parent = _pivot
		_plane.Animator.Animate( 0 )
		_plane.Name = "Plane"
		
		Local planeAnim := _plane.AddComponent< Airplane >()

		'create camera target
		_camTarget = New Entity( _pivot )
		_camTarget.Name = "CameraTarget"
		
		Local camShake := _camTarget.AddComponent< Noise3D >()
		camShake.AddCurve( Axis.X, 1.5, 0.1, SINE, 0.0 )
		camShake.AddCurve( Axis.X, 0.1, 1.0, SMOOTH, 0.0 )
		
		camShake.AddCurve( Axis.Y, 1.0, 0.25, SINE, 100.0 )
		camShake.AddCurve( Axis.Y, 0.1, 1.25, SMOOTH, 100.0 )
		
		camShake.AddCurve( Axis.Z, 1.5, 0.05, SINE, 200.0 )
		camShake.AddCurve( Axis.Z, 0.1, 0.1, SMOOTH, 200.0 )
		
		camShake.Y = -3.0	'base value added to the curve generators. Acts like a parent transform.
		camShake.Z = -10.0
		
		'camera base
		_camBase = New Entity( _pivot )
		_camBase.Move( 0,4,8 )
		_camBase.Name = "CameraBase"
		
		'create camera 1
		_camera1=New Camera( _camBase )
		_camera1.View = Self
		_camera1.Near=.1
		_camera1.Far=10000
		_camera1.FOV = 75
		_camera1.Name = "Camera1"
		_activeCamera = _camera1
		
		'create camera 2
		_camera2=New Camera( _pivot )
		_camera2.View = Self
		_camera2.Near=.1
		_camera2.Far=10000
		_camera2.FOV = 60
		_camera2.Move( 0,3,-8 )
		_camera2.Name = "Camera2"
		
		'create camera 3
		_camera3=New Camera( _pivot )
		_camera3.View = Self
		_camera3.Near=.1
		_camera3.Far=10000
		_camera3.FOV = 75
		_camera3.Move( 8,8,8 )
		_camera3.Name = "Camera3"
		
		_pivot.Position = New Vec3f( 0, 20, 0 )	
	End	
	
	
End 
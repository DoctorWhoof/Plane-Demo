
Namespace plane

#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"

#Import "source/PlaneControl"

#Import "textures/"
#Import "models/plane.glb"

Using std..
Using mojo..
Using mojo3d..

Class MyWindow Extends Window
	
	Global _res :Vec2i
	
	Field _scene:Scene
	Field _camera:Camera
	Field _light:Light
	Field _fog:FogEffect
	
	Field _water:Model
	Field _plane:Model
	Field _pivot:Model		'Needs to be a Model instead of Entity otherwise the plane isn't rendered!
		
	Field _camTarget:Entity
	Field test:Model
	
	
	Method New()
		Super.New( "Toy Plane", 1280, 720, WindowFlags.Resizable )' | WindowFlags.HighDPI  )
		_res = New Vec2i( Width, Height )
		Layout = "letterbox"
		
		_scene=Scene.GetCurrent()
		_scene.SkyTexture=Texture.Load( "asset::miramar-skybox.jpg",TextureFlags.FilterMipmap|TextureFlags.Cubemap )
		_scene.EnvTexture = _scene.SkyTexture
		
		'create light
		_light=New Light
		_light.Rotate( 45, 45, 0 )
		_light.CastsShadow = True
		
		'create water material
		Local waterMaterial:=New WaterMaterial
		
		waterMaterial.ScaleTextureMatrix( 100,100 )
		waterMaterial.ColorFactor=New Color( 0.05, 0.25, 0.3 )
		waterMaterial.Roughness=0
		
		waterMaterial.NormalTextures=New Texture[]( 
			Texture.Load( "asset::water_normal0.png",TextureFlags.WrapST | TextureFlags.FilterMipmap ),
			Texture.Load( "asset::water_normal1.png",TextureFlags.WrapST | TextureFlags.FilterMipmap ) )
		
		waterMaterial.Velocities=New Vec2f[]( 
			New Vec2f( .01,.03 ),
			New Vec2f( .02,.05 ) )
		
		'create water
		_water=Model.CreateBox( New Boxf( -2000,-1,-2000,2000,0,2000 ),1,1,1,waterMaterial )
		
		'create fog
		_fog = New FogEffect( New Color(0.69, 0.78, 0.82, 0.75 ), 1, 1000 )
		_scene.AddPostEffect( _fog )
		
		'create bloom
		Local _bloom := New BloomEffect( 2 )
		_scene.AddPostEffect( _bloom )
		
		'create main pivot
		_pivot = New Model
		
		'create airplane
		_plane = Model.LoadBoned( "asset::plane.glb" )
		_plane.Animator.Animate( 0 )
		_plane.Parent = _pivot
		_plane.Position = New Vec3f

		'create camera target
		_camTarget = New Entity( _plane )
'		_camTarget = Model.CreateSphere( 0.25, 12, 12, New PbrMaterial( Color.Red ) )
		_camTarget.Parent = _plane
		_camTarget.Position = New Vec3f( 0, 0, 10 )

		'create camera
		_camera=New Camera( _pivot )
		_camera.Near=.1
		_camera.Far=1000
		_camera.FOV = 60
		_camera.Move( 0,3,-12 )
		
		'Control component
		Local control := _pivot.AddComponent<PlaneControl>()
		control.plane = _plane
		control.camera = _camera
		control.target = _camTarget

		_pivot.Position = New Vec3f( 0, 6, 0 )
	End
	
	
	Method OnRender( canvas:Canvas ) Override
		RequestRender()
		
		_water.Position=New Vec3f( Round(_camera.Position.x/2000)*2000,0,Round(_camera.Position.z/2000)*2000 )

		_camera.WorldPointAt( _camTarget.Position )
		
		_scene.Update()
		_scene.Render( canvas,_camera )
		
		canvas.DrawText( "Width="+Width+", Height="+Height+", FPS="+App.FPS,0,0 )
'		canvas.DrawText( _plane.Rotation,0,15 )
'		canvas.DrawText( _plane.LocalRotation,0,30 )
	End
	
'	
	Method OnMeasure:Vec2i() Override
		Return _res
	End
	
End

Function Main()
	New AppInstance
	New MyWindow
	App.Run()
End


Class Entity Extension
	
	Method WorldPointAt( target:Vec3f,up:Vec3f=New Vec3f( 0,1,0 ) )
		Local k:=(target-Position).Normalize()
		Local i:=up.Cross( k ).Normalize()
		Local j:=k.Cross( i )
		Basis=New Mat3f( i,j,k )
	End

End


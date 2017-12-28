
Namespace plane

#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"

#Import "textures/"
#Import "models/plane.glb"

Using std..
Using mojo..
Using mojo3d..

Class MyWindow Extends Window
	
	Const _res := New Vec2i( 1280, 720 )
	
	Field _scene:Scene
	Field _camera:Camera
	Field _light:Light
	Field _fog:FogEffect
	
	Field _water:Model
	Field _plane:Model
	Field _camTarget:Entity
	
	Method New()

		Super.New( "Toy Plane",_res.X,_res.Y,WindowFlags.Resizable | WindowFlags.HighDPI  )
		Layout = "letterbox"
		
		_scene=Scene.GetCurrent()
		_scene.SkyTexture=Texture.Load( "asset::miramar-skybox.jpg",TextureFlags.FilterMipmap|TextureFlags.Cubemap )
		_scene.EnvTexture = _scene.SkyTexture
		
		'create light
		_light=New Light
		_light.RotateX( 45 )
		_light.RotateY( 45 )
		_light.CastsShadow = True
		
		'create water material
		Local waterMaterial:=New WaterMaterial
		
		waterMaterial.ScaleTextureMatrix( 100,100 )
		waterMaterial.ColorFactor=New Color( 0.05, 0.25, 0.3 )
		waterMaterial.Roughness=0
		
		waterMaterial.NormalTextures=New Texture[]( 
			Texture.Load( "asset::water_normal0.png",TextureFlags.WrapST|TextureFlags.FilterMipmap ),
			Texture.Load( "asset::water_normal1.png",TextureFlags.WrapST|TextureFlags.FilterMipmap ) )
		
		waterMaterial.Velocities=New Vec2f[]( 
			New Vec2f( .01,.03 ),
			New Vec2f( .02,.05 ) )
		
		'create water
		_water=Model.CreateBox( New Boxf( -2000,-1,-2000,2000,0,2000 ),1,1,1,waterMaterial )
		
		'create fog
		_fog = New FogEffect( New Color(0.69, 0.78, 0.82, 0.7 ), 1, 500 )
		_scene.AddPostEffect( _fog )
		
		'create airplane
		_plane = Model.Load( "asset::plane.glb" )
		_plane.Position = New Vec3f( 0, 6, 0 )
		
		'create camera
		_camera=New Camera
		_camera.Near=.1
		_camera.Far=1000
		_camera.FOV = 60
		_camera.Move( 0,4,-10 )
		
		_camTarget = New Entity( _plane )
		_camera.Parent = _camTarget
		_camera.PointAt( New Vec3f( 0 ) )
		
		
		For Local mat := Eachin _plane.Materials
			Local pbr := Cast<PbrMaterial>( mat )
			pbr.RoughnessFactor = 0.2
		Next
	End
	
	Method OnRender( canvas:Canvas ) Override
		RequestRender()
		
		_scene.Render( canvas,_camera )
		canvas.DrawText( "Width="+Width+", Height="+Height+", FPS="+App.FPS,0,0 )
		
		Local delta := 60.0 / App.FPS 
		Local dist := 15.0
		
		_plane.Move( 0, 0, 1.0 * delta )
		_camTarget.Rotate( 0, 0.2 * delta, 0 )
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

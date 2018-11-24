Namespace mojo3d

#Import "<mojo3d>"
#Import "<std>"
#Import "shaders/waterFow.glsl@/shaders/"

Using mojo3d..
Using std..

#rem monkeydoc A WaterMaterial class that works with the forward renderer.
#end

Class WaterFowMaterial Extends Material
	
	#rem monkeydoc Creates a new water material.
	#end
	Method New()
		ShaderName="waterFow"
		AttribMask=1|4|8|32
		BlendMode=BlendMode.Opaque
		CullMode=CullMode.None
		
		ColorTexture=Texture.ColorTexture( Color.White )
		ColorFactor=Color.SeaGreen
		Metalness=0
		Roughness=0
		NormalTextures=New Texture[]( Texture.FlatNormal(),Texture.FlatNormal() )
		Velocities=New Vec2f[]( New Vec2f( 0,0 ),New Vec2f( 0,0 ) )
	End
	
	Method New( material:WaterFowMaterial )
		Super.New( material )
	End
	
	#rem monkeydoc Creates a copy of the water material.
	#end
	Method Copy:WaterFowMaterial() Override
		Return New WaterFowMaterial( Self )
	End
	
	Property ColorTexture:Texture()
		Return Uniforms.GetTexture( "ColorTexture" )
	Setter( texture:Texture )
		Uniforms.SetTexture( "ColorTexture",texture )
	End

	Property ColorFactor:Color()
		Return Uniforms.GetColor( "ColorFactor" )
	Setter( color:Color )
		Uniforms.SetColor( "ColorFactor",color )
	End
	
	Property Metalness:Float()
		Return Uniforms.GetFloat( "Metalness" )
	Setter( metalness:Float )
		Uniforms.SetFloat( "Metalness",metalness )
	End
	
	Property Roughness:Float()
		Return Uniforms.GetFloat( "Roughness" )
	Setter( roughness:Float )
		Uniforms.SetFloat( "Roughness",roughness )
	End
	
	Property NormalTextures:Texture[]()
		Return New Texture[]( Uniforms.GetTexture( "NormalTexture0" ),Uniforms.GetTexture( "NormalTexture1" ) )
	Setter( textures:Texture[] )
		Assert( textures.Length=2,"NormalTextures array must have length 2" )
		Uniforms.SetTexture( "NormalTexture",textures[0] )
		Uniforms.SetTexture( "NormalTexture0",textures[0] )
		Uniforms.SetTexture( "NormalTexture1",textures[1] )
	End
	
	Property Velocities:Vec2f[]()
		Return New Vec2f[]( Uniforms.GetVec2f( "Velocity0" ),Uniforms.GetVec2f( "Velocity1" ) )
	Setter( velocities:Vec2f[] )
		Assert( velocities.Length=2,"Velocities array must have length 2" )
		Uniforms.SetVec2f( "Velocity0",velocities[0] )
		Uniforms.SetVec2f( "Velocity1",velocities[1] )
	End
	
End

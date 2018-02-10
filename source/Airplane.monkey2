
Namespace mojo3d


Class Airplane Extends Model
	
	Field body:Model

	Field rudder:Model	
	Field tail_L:Model
	Field tail_R:Model
	
	Field aileron_L:Model
	Field aileron_R:Model

	Field lightRing:Model
	Field light:Model
	
	Field propeller:Model
	Field engine:Model
	
	Field canopi:Model
	Field interior:Model
	Field floats:Model
	
	Method New( pivot:Entity )
		
		Local children := Model.LoadBoned( "asset::plane/plane.gltf" )
		children.Animator.Animate( 0 )
		children.Parent = Self
		Parent = pivot
		
		rudder = GetChild( "rudder" )
		aileron_L = GetChild( "aileron_L" )
		aileron_R = GetChild( "aileron_R" )
		tail_L = GetChild( "tail_L" )
		tail_R = GetChild( "tail_R" )
		
		'Replace Pbr material with textures exported from Substance Painter
		Local mat := PbrMaterial.Load( "asset::plane.pbr", TextureFlags.FilterMipmap )
		AssignMaterialToHierarchy( mat )
		
	End
	
	
	
	Method Update()
		
		If Keyboard.KeyDown( Key.Left )
			rudder.LocalRy = -10.0
			aileron_L.LocalRx = -15
			aileron_R.LocalRx = 15
		Elseif Keyboard.KeyDown( Key.Right )
			rudder.LocalRy = 10.0
			aileron_L.LocalRx = 15
			aileron_R.LocalRx = -15
		Else
			rudder.LocalRy = 0.0
			aileron_L.LocalRx = 0
			aileron_R.LocalRx = 0
		End
		
		If Keyboard.KeyDown( Key.Up )
			tail_L.LocalRx = 15
			tail_R.LocalRx = 15
		Elseif Keyboard.KeyDown( Key.Down )
			tail_L.LocalRx = -15
			tail_R.LocalRx = -15
		Else
			tail_L.LocalRx = 0
			tail_R.LocalRx = 0
		End
		
		
	End
	
	
	
End

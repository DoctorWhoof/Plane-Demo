
Namespace mojo3d


Class Airplane Extends Behaviour
	
	Field maxRoll := 45.0
	Field maxYaw := 30.0
	Field maxPitch := 15.0
	
	Field maxRudder := 20.0
	Field maxTail := 20.0
	Field maxAileron := 20.0
	
	Private
	
	Field model:Model
	
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
	
	Field time:Float
	
	Field roll:= New SmoothFloat( 1.5, 20.0 )
	Field yaw:= New SmoothFloat( 0.75, 20.0 )
	Field pitch:= New SmoothFloat( 0.5, 20.0 )
	
	Field rudderValue := New SmoothFloat( 0.25 )
	Field tailValue := New SmoothFloat( 0.25 )
	Field aileron_L_value := New SmoothFloat( 0.25 )
	Field aileron_R_value := New SmoothFloat( 0.25 )
	
	Field finalMaxYaw:Float
'	
	Public
	
	Method New( parent:Entity )
		
		Super.New( parent )
		
		model = Cast<Model>( Entity )
		body = model.GetChild( "body" )
		canopi = model.GetChild( "canopi" )
		rudder = model.GetChild( "rudder" )
		aileron_L = model.GetChild( "aileron_L" )
		aileron_R = model.GetChild( "aileron_R" )
		tail_L = model.GetChild( "tail_L" )
		tail_R = model.GetChild( "tail_R" )
		
		'Replace materials
		Local mat := PbrMaterial.Load( "asset::plane.pbr", TextureFlags.FilterMipmap )
		body.AssignMaterialToHierarchy( mat )
		
		Local canoMat := New PbrMaterial( New Color( 0, 0.1, 0.0 ), 0.05, 0.1 )
		canopi.AssignMaterialToHierarchy( canoMat )
		canopi.Alpha = 0.4
	End
	
	
	
	Method OnUpdate( elapsed:Float ) Override
		
		SmoothFloat.UpdateTime()
		
		Local delta := 60.0*elapsed

'		Echo( "elapsed:" + elapsed +"   delta: " + Format(delta,5) )
		
		If Keyboard.KeyHit( Key.Left ) Or Keyboard.KeyHit( Key.Right ) Or Keyboard.KeyReleased( Key.Left ) Or Keyboard.KeyReleased( Key.Right )
			
			roll.Reset( model.LocalRz )
			yaw.Reset( model.LocalRy )
			
			rudderValue.Reset( rudder.LocalRy )
			aileron_L_value.Reset( aileron_L.LocalRx )
			aileron_R_value.Reset( aileron_R.LocalRx )
			
		End
		
		If Keyboard.KeyHit( Key.Up ) Or Keyboard.KeyHit( Key.Down ) Or Keyboard.KeyReleased( Key.Up ) Or Keyboard.KeyReleased( Key.Down )
			
			pitch.Reset( model.LocalRx )
			yaw.Reset( model.LocalRy )
			tailValue.Reset( tail_L.LocalRx )
			finalMaxYaw = maxYaw
			
		End
		
		If Keyboard.KeyDown( Key.Up )
			
			tailValue.Goal = maxTail
			pitch.Goal = -maxPitch
			finalMaxYaw = maxYaw * 2.0
			
		Elseif Keyboard.KeyDown( Key.Down )
			
			tailValue.Goal = -maxTail
			pitch.Goal = maxPitch
			finalMaxYaw = maxYaw * 2.0
			
		Else
			
			tailValue.Goal = 0.0
			pitch.Goal = 0.0
			finalMaxYaw = maxYaw
			
		End
		
		If Keyboard.KeyDown( Key.Left )
			
			roll.Goal = -maxRoll
			yaw.Goal = finalMaxYaw
			
			rudderValue.Goal = -maxRudder
			aileron_L_value.Goal = -maxRudder
			aileron_R_value.Goal = maxRudder
			
		Elseif Keyboard.KeyDown( Key.Right )
			
			roll.Goal = maxRoll
			yaw.Goal = -finalMaxYaw
			
			rudderValue.Goal = maxRudder
			aileron_L_value.Goal = maxRudder
			aileron_R_value.Goal = -maxRudder
			
		Else
			
			roll.Goal = 0.0
			yaw.Goal = 0.0
			
			rudderValue.Goal = 0.0
			aileron_L_value.Goal = 0.0
			aileron_R_value.Goal = -0.0
			
		End
		
		model.LocalRx = pitch.Get( delta )
		model.LocalRy = yaw.Get( delta )
		model.LocalRz = roll.Get( delta )
		
		rudder.LocalRy = rudderValue.Get( delta )
		aileron_L.LocalRx = aileron_L_value.Get(delta )
		aileron_R.LocalRx = aileron_R_value.Get( delta )
		tail_L.LocalRx = tailValue.Get( delta )
		tail_R.LocalRx = tailValue.Get( delta )
	End
	
	
End

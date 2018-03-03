
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
	
	Field roll:= New SmoothDouble( 0, 2.0, 20.0, True )
	Field yaw:= New SmoothDouble( 0, 1.0, 20.0, True )
	Field pitch:= New SmoothDouble( 0, 2.0, 50.0, True)
	
	Field rudderValue := New SmoothDouble( 0, 3.0, 2.0, False )
	Field tailValue := New SmoothDouble( 0, 3.0, 2.0, False )
	Field aileron_L_value := New SmoothDouble( 0, 3.0, 2.0, False )
	Field aileron_R_value := New SmoothDouble( 0, 3.0, 2.0, False )
	
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
		propeller = model.GetChild( "propeller" )
	
	End
	
	
	
	Method OnUpdate( elapsed:Float ) Override
		
		Local delta := 60.0*elapsed
		
		If Keyboard.KeyHit( Key.Up ) Or Keyboard.KeyHit( Key.Down ) Or Keyboard.KeyReleased( Key.Up ) Or Keyboard.KeyReleased( Key.Down )
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
		

		model.LocalRz = roll.Get( delta )
		body.LocalRx = pitch.Get( delta )
		rudder.LocalRy = rudderValue.Get( delta )
		aileron_L.LocalRx = aileron_L_value.Get(delta )
		aileron_R.LocalRx = aileron_R_value.Get( delta )
		tail_L.LocalRx = tailValue.Get( delta )
		tail_R.LocalRx = tailValue.Get( delta )
		
		propeller.RotateZ( 396.0 )
		
	End
	
	
End

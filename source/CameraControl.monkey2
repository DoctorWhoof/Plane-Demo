Namespace mojo3d


Class CameraControl Extends Behaviour
	
	Field speed := 1.0
	
	Field fov := 60.0
	Field minFOV := 10.0
	Field maxFOV := 85.0
	
	'"Look ahead" adjusts
	Field maxPanAdjust := 10.0
	Field maxTiltAdjust := 10.0
	Field maxRollAdjust := 30.0
	Field adjustLag := 100.0
	
	Field smoothPan := New SmoothDouble( 0.0, 4.0, 5.0, False )
	Field smoothTilt := New SmoothDouble( 0.0, 4.0, 5.0, False )
	Field smoothRoll := New SmoothDouble( 0.0, 8.0, 1.0, False )
	
	Field shaker:Entity
	Field dolly:Entity
	Field orbiter:Entity
	Field lookAhead:Entity
	Field target:Entity
	
	Private
	Field _cam:Camera
	
	Public	
	Method New( entity:Entity )	
		Super.New( entity )
		Print( "New Camera Control!" )
		
		_cam = Cast<Camera>( entity )
		Assert( _cam, "CameraControl: Error, entity not a camera" )
		
		_cam.FOV = fov
	End
	
	Method OnUpdate( elapsed:Float ) Override
		
		Local delta := SmoothDelta( elapsed )
		
		dolly.PointAt( target.Position )
		
		If Keyboard.KeyDown( Key.LeftShift ) Or  Keyboard.KeyDown( Key.RightShift )

			If Keyboard.KeyDown( Key.A )
				Entity.Ry += (speed/2.0) * delta
			Else If Keyboard.KeyDown( Key.D )
				Entity.Ry -= (speed/2.0) * delta
			Endif
			
			If Keyboard.KeyDown( Key.W )
				Entity.Rx -= (speed/2.0) * delta
			Else If Keyboard.KeyDown( Key.S )
				Entity.Rx += (speed/2.0) * delta
			Endif
			
			If Keyboard.KeyDown( Key.Z )
				Entity.Rz += (speed/2.0) * delta
			Else If Keyboard.KeyDown( Key.X )
				Entity.Rz -= (speed/2.0) * delta
			Endif
			
			If Keyboard.KeyHit( Key.R )
				Entity.LocalRotation = New Vec3f
				New StackedMessage( "Reset camera rotation" )
			End

		Else
		
			If Keyboard.KeyDown( Key.A )
				orbiter.LocalRy -= speed * delta
			Else If Keyboard.KeyDown( Key.D )
				orbiter.LocalRy += speed * delta
			Endif
			
			If Keyboard.KeyDown( Key.W )
				orbiter.LocalRx -= speed * delta
			Else If Keyboard.KeyDown( Key.S )
				orbiter.LocalRx += speed * delta
			Endif
			
			If Keyboard.KeyDown( Key.Z )
				Entity.LocalZ += (speed/10.0) * delta
			Else If Keyboard.KeyDown( Key.X )
				Entity.LocalZ -= (speed/10.0) * delta
			Endif
			
			If Keyboard.KeyHit( Key.R )
				Entity.LocalPosition = New Vec3f
				orbiter.LocalRotation = New Vec3f
				_cam.FOV = fov
				New StackedMessage( "Reset camera translation and FOV" )
			End
			
		End
		
		'Look ahead: camera pans, tilts and rolls reacting to user input
		If lookAhead
			
			If Keyboard.KeyDown( Key.Left )
				smoothPan.Goal = maxPanAdjust
				smoothRoll.Goal = maxRollAdjust
			Else If Keyboard.KeyDown( Key.Right )
				smoothPan.Goal = -maxPanAdjust
				smoothRoll.Goal = -maxRollAdjust
			Else
				smoothPan.Goal = 0.0
				smoothRoll.Goal = 0.0
				
				'Only do tilt adjusts if no pan is happening
				If Keyboard.KeyDown( Key.Up )
					smoothTilt.Goal = maxTiltAdjust
				Else If Keyboard.KeyDown( Key.Down )
					smoothTilt.Goal = -maxTiltAdjust
				Else
					smoothTilt.Goal = 0.0
				Endif
				
			Endif
			
			lookAhead.LocalRx = smoothTilt.Get( elapsed )
			lookAhead.LocalRy = smoothPan.Get( elapsed )
			lookAhead.LocalRz = smoothRoll.Get( elapsed )
			
'			Graph.Add( "Camera Rx", lookAhead.LocalRx, Color.Red )
'			Graph.Add( "Camera Ry", lookAhead.LocalRy, Color.Green )
'			Graph.Add( "Camera Rz", lookAhead.LocalRz, Color.Blue )
			
		End
		
		If( Keyboard.KeyDown( Key.Minus ) )
			_cam.FOV += speed * delta
		Elseif( Keyboard.KeyDown( Key.Equals ) )
			_cam.FOV -= speed * delta
		End
		
		If( Keyboard.KeyHit( Key.Enter ) )
			If shaker
				Local noise := shaker.GetComponent<Noise3D>()
				If noise
					noise.enabled = Not noise.enabled
					New StackedMessage( "Toggle camera shake" )
				End
			End	
		End
		
		_cam.FOV = Clamp( _cam.FOV, minFOV, maxFOV )
		
	End
	
	
End

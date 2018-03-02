Namespace mojo3d


Class CameraControl Extends Behaviour
	
	Field speed := 1.5
	
	Field fov := 60.0
	Field minFOV := 10.0
	Field maxFOV := 85.0
	
	Field shaker:Entity
	Field dolly:Entity
	Field orbiter:Entity
	Field camera:Entity
	
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
		Local delta := elapsed * 60.0
		
		dolly.PointAt( orbiter.Position )
		
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
			
			If Keyboard.KeyHit( Key.Space )
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
			
			If Keyboard.KeyHit( Key.Space )
				Entity.LocalPosition = New Vec3f
				orbiter.LocalRotation = New Vec3f
				_cam.FOV = fov
				New StackedMessage( "Reset camera translation and FOV" )
			End
			
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

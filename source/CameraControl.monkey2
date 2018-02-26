Namespace mojo3d


Class CameraControl Extends Behaviour
	
	Field speed := 1.5
	
	Field target:Entity
	Field camera:Entity
	
	Public	
	Method New( entity:Entity )	
		Super.New( entity )
		Print( "New Camera Control!" )
	End
	
	Method OnUpdate( elapsed:Float ) Override
		Local delta := elapsed * 60.0
		
		If Keyboard.KeyDown( Key.LeftShift ) Or  Keyboard.KeyDown( Key.RightShift )
		
			If target
				
				If Keyboard.KeyDown( Key.A )
					target.LocalX += (speed/10.0) * delta
				Else If Keyboard.KeyDown( Key.D )
					target.LocalX -= (speed/10.0) * delta
				Endif
				
				If Keyboard.KeyDown( Key.W )
					target.LocalY += (speed/10.0) * delta
				Else If Keyboard.KeyDown( Key.S )
					target.LocalY -= (speed/10.0) * delta
				Endif
				
			End

		Else
		
			If Keyboard.KeyDown( Key.A )
				Entity.LocalRy -= speed * delta
			Else If Keyboard.KeyDown( Key.D )
				Entity.LocalRy += speed * delta
			Endif
			
			If Keyboard.KeyDown( Key.W )
				Entity.LocalRx -= speed * delta
			Else If Keyboard.KeyDown( Key.S )
				Entity.LocalRx += speed * delta
			Endif
			
			If Keyboard.KeyDown( Key.Z )
'				Entity.LocalScale -= (speed/200.0) * delta
				camera.LocalZ -= (speed/10.0) * delta
			Else If Keyboard.KeyDown( Key.X )
				camera.LocalZ += (speed/10.0) * delta
'				Entity.LocalScale += (speed/200.0) * delta
			Endif
			
		End
		
	End
	
	
End

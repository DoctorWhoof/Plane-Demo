Namespace mojo3d


Class VehicleControl Extends Behaviour
	
	Field speed:= 1.0
	Field turnRate := 0.35
	Field ascentionRate := 0.1	
	Field lag := 50.0
	
	Field minAltitude := 12.0
	Field maxAltitude := 80.0

'	Field cameraTarget:Entity			'The camera target, positioned ahead of the plane
'	Field cameraBase:Entity	
	Field vehicle:Entity
	
	Field camRotationMult:= New Vec3f( 0.5, 0.8, 0.5 )
	Field camPositionMult:= New Vec3f( 0.1, 0.1, 0.1 )
	Field cameraPositionLag := 20.0
	Field cameraRotationLag := 50.0
	
	Private
	Field _azimuth:Float
	Field _azimuthGoal:Float
	
	Field _pitch:Float
	Field _yaw:Float
	Field _roll:Float
	
	Field _throttle:Float = 1.0
	Field _zSpeed:Float
	Field _ySpeed:Float
	Field _ySpeedGoal:Float
	Field _finalTurnRate:Float
	
	Field n:= 0
	
	Public	
	Method New( entity:Entity )	
		Super.New( entity )
		Print( "New vehicle Control!" )
	End
	
	Method OnUpdate( elapsed:Float ) Override
		
		Local delta := elapsed * 60.0
		Local entity:=Entity
		Local previousPos := entity.Position
		
		Local time := ( Microsecs()/1000000.0 )
		

		If Keyboard.KeyDown( Key.Up ) And ( entity.Position.Y > minAltitude )
			_ySpeedGoal = -ascentionRate * 2.0
			_finalTurnRate = turnRate * 1.3
		Else If Keyboard.KeyDown( Key.Down ) And ( entity.Position.Y < maxAltitude )
			_ySpeedGoal = ascentionRate
			_finalTurnRate = turnRate * 1.3
		Else
			_ySpeedGoal = 0
			_pitch = 0
			_finalTurnRate = turnRate
		Endif

		
		Echo( entity.Position.Y, Color.Yellow )
		
		If Keyboard.KeyDown( Key.Left )
			_azimuthGoal += _finalTurnRate
			_ySpeedGoal *= 0.5						'lowers altitude change if turning (tail lift is split between two axis)
		Else If Keyboard.KeyDown( Key.Right )
			_azimuthGoal -= _finalTurnRate
			_ySpeedGoal *= 0.5
		Endif

		_zSpeed = -speed * _throttle * delta
		_ySpeed = Smooth( _ySpeed, _ySpeedGoal, lag, delta )
		
		entity.Move( 0, _ySpeed, _zSpeed )
		
		_azimuth = Smooth( _azimuth, _azimuthGoal, lag, delta )
		entity.Ry = _azimuth

'		If vehicle And cameraBase
'			cameraBase.LocalRx = Smooth( cameraBase.LocalRx, vehicle.LocalRx * -camRotationMult.X, cameraRotationLag, delta )
'			cameraBase.LocalRy = Smooth( cameraBase.LocalRy, vehicle.LocalRy * camRotationMult.Y, cameraRotationLag, delta )
'			cameraBase.LocalRz = Smooth( cameraBase.LocalRz, vehicle.LocalRz * -camRotationMult.Z, cameraRotationLag, delta )
'			
'			cameraBase.LocalX = Smooth( cameraBase.LocalX, vehicle.LocalRy * camPositionMult.X, cameraPositionLag, delta )
'			cameraBase.LocalY = Smooth( cameraBase.LocalY, -vehicle.LocalRx * camPositionMult.Y, cameraPositionLag, delta )
'		End
		
		Local spd := ( entity.Position.Distance( previousPos ) * (1.0/elapsed) ) * 3.6
		Echo( "Speed:" + Round(spd) + "Km/h" )
	End
	
	
End

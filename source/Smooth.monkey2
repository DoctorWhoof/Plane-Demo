
Namespace plane

Alias SmoothFloat:SmoothValue<Float>
Alias SmoothDouble:SmoothValue<Double>

Class SmoothValue<T>
	
	Field threshold :Double = 0.01
	
	Protected
	Field _value:T
	Field _goal:T
	Field _source:T
	
	Field _direction:Double
	Field _velocity:Double
	Field _mass:Double

	Field _overshootMultiplier:Double = 0.7
	Field _useEase:Bool
	Field _easeIn:Double
	
	Field _acc:Double
	Field _finalVel:Double
	Field _mult:Double
	
	Public
	
	'*************************** Public properties ***************************
		
	Property Goal:T()
		Return _goal
	Setter( newGoal:T )
		If ( newGoal > _goal + threshold ) Or ( newGoal < _goal - threshold )
			_source = _value
			_goal = newGoal
			_mult = 1.0
			
			Local distance := _goal - _value
			If distance > threshold
				_direction = 1.0
			Elseif distance < threshold
				_direction = -1.0
			Else
				_direction = 0
			End
		End
	End
	
	'*************************** Public methods ***************************
	
	Method New( value:T, velocity:Double, mass:Double, easeIn:Bool )
		_value = value
		_velocity = velocity
		_useEase = easeIn
		_mass = mass
	End
	
	
	Method Get:T( elapsed:Double )

		Local distance := _goal - _value
		Local sourceDistance := _goal - _source
		
		If _useEase
			_easeIn = Pow( 1.0 - Normalize( _source, _goal, _value ), 0.1 )
'			Graph.Add( "EaseIn", _easeIn, Color.White )
		Else
			_easeIn = 1.0	
		End		

		_mult = Clamp<Double>( _mult, 0.0, 8.0 )
		_acc = ( 1.0 / _mass ) * _mult
		
		If _direction > 0
			If distance > threshold
				_finalVel += _acc * _easeIn
				_finalVel *= _easeIn
				If _finalVel > _velocity Then _finalVel = _velocity
			Elseif distance < threshold
				'Invert!
				_mult *= _overshootMultiplier
				_finalVel *= _overshootMultiplier/1.5
				_finalVel -= _acc
				_direction = -1
'				_source = _value
			End
		Elseif _direction < 0
			If distance < threshold
				_finalVel -= _acc * _easeIn
				_finalVel *= _easeIn
				If _finalVel < -_velocity Then _finalVel = -_velocity
			ElseIf distance > threshold
				'Invert!
				_mult *= _overshootMultiplier
				_finalVel *= _overshootMultiplier/1.5
				_finalVel += _acc
				_direction = 1
'				_source = _value
			End
		End
		
'		Echo( "direction:" + _direction )
'		Echo( "value:" + _value )
'		Echo( "easein:" + easeIn )
		
		_value += _finalVel * elapsed
		Return _value
	End
	
End

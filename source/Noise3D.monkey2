Namespace mojo3d

#Import "NoiseCurve"
Using plane..
Using std.geom..

Class Noise3D Extends Behaviour
	
	Field affectRotation := True
	Field affectPosition := False
	Field enabled := True
	
	Private
	'Baseline values.
	Field _x:Float
	Field _y:Float
	Field _z:Float
	
	'Curve generators for each axis
	Field _curvesX:= New Stack<CurveGenerator>
	Field _curvesY:= New Stack<CurveGenerator>
	Field _curvesZ:= New Stack<CurveGenerator>
	
	'misc
	Field _time:Float
	Field _previousTime:Float
	
	Public
	'*********************************** Properties ***********************************
	
	Property X:Float()
		Local result:= _x
		For Local c := Eachin _curvesX
			result += NoiseCurve( _time, c.amplitude, c.frequency, c.style )
		End
		Return result
	Setter( value:Float )
		_x = value	
	End


	Property Y:Float()
		Local result:= _y
		For Local c := Eachin _curvesY
			result += NoiseCurve( _time, c.amplitude, c.frequency, c.style )
		End
		Return result
	Setter( value:Float )
		_y = value	
	End
	
	
	Property Z:Float()
		Local result:= _z
		For Local c := Eachin _curvesZ
			result += NoiseCurve( _time, c.amplitude, c.frequency, c.style )
		End
		Return result
	Setter( value:Float )
		_z = value	
	End
	
	
	Property Vector:Vec3f()
		Return New Vec3f( X, Y, Z )	
	Setter( value:Vec3f )
		_x = value.X
		_y = value.Y
		_z = value.Z
	End
	
	
	'*********************************** Methods ***********************************
	
		
	Method New( entity:Entity )	
		Super.New( entity )
	End
	
	
	Method OnUpdate( elapsed:Float ) Override
		_time += elapsed
		
		If enabled
			If affectPosition Then Entity.LocalPosition = Vector
			If affectRotation Then Entity.LocalRotation = Vector
		Else
			If affectPosition Then Entity.LocalPosition = New Vec3f
			If affectRotation Then Entity.LocalRotation = New Vec3f	
		End
	End
	
	
	Method AddCurve( axis:Axis, amp:Float, freq:Float, style:Int = SMOOTH, offset:Float = 0.0  )
		Local curve := New CurveGenerator
		curve.amplitude = amp
		curve.frequency = freq
		curve.style = style
		curve.offset = offset
		Select axis
			Case Axis.X
				_curvesX.Add( curve )
			Case Axis.Y
				_curvesY.Add( curve )
			Case Axis.Z
				_curvesZ.Add( curve )
		End
	End
	
End



Class CurveGenerator
	
	Field amplitude:= 1.0
	Field frequency:= 1.0
	Field offset:= 0.0
	Field style:= SMOOTH
	
End
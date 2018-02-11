
Namespace plane

Alias SmoothFloat:SmoothValue<Float>

Class SmoothValue<T>
	
	Field smoothLength :T = 0.5
	Field inertiaLag:= 0.0

	Private
	Field _v:T					'Current value
	
	Field _v0:T = 0.0
	Field _v1:T = 0.0
	Field _vi:T = 0.0
	
	Field _t0:T = 0.0
	Field _t1:T = 0.0
	
	Global _time:T = 0.0
	Global _all := New Stack<SmoothValue<T>>
	
	Public
	Property Goal:T()
		Return _v1
	Setter( value:T )
		_v1 = value
	End
	
	
	Method New( length:T, inertiaLag:Double= 0.0 )
		_all.Add( Self )
		Self.smoothLength = length
		Self.inertiaLag = inertiaLag
	End
	
	
	Method Get:T( delta:Double )
		
		Local mult := 1.0 - Normalize( _v0, _v1, _v )
		
		If inertiaLag > 1.0
			If _vi > _v1
				_vi -= ( smoothLength * mult )
			Elseif _vi < _v1
				_vi += ( smoothLength * mult )
			End
			_v = Smooth( _v, _vi, inertiaLag, delta )

'			Echo( "_v: "+Format(_v) + "    _v0: "+Format(_v0) + "    _v1: "+Format(_v1) + "    _vi: "+Format(_vi) )
		Else
			_v = SmoothMix( _v0, _v1, Normalize( _t0, _t1, _time ) )
		End
		
		Return _v
	End
	
	
	Method Reset( startValue:T )
		_v0 = startValue
		_t0 = _time
		_t1 = _time + smoothLength
	End
	
	
	Function UpdateTime()
		_time = Microsecs()/1000000.0
	End
	
End


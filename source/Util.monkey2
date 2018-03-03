
Namespace util

Const degToRad :Double = Pi / 180.0
Const radToDeg :Double = 180.0 / Pi
Const one :Double = 1.0					'This is just to ensure 1.0 is a double, not float

'*********************** Math functions ***********************

'Function DeltaMultiply:Double( value:Double, multiplier:Double, delta:Double )
'	Local attenuation := ( one - ( ( one - multiplier ) * delta ) )
'	Return( value * attenuation )
'End
'
'
'Function DeltaMultiply:Vec2<Double>( vec:Vec2<Double>, multiplier:Double, delta:Double )
'	Local attenuation := ( one - ( ( one - multiplier ) * delta ) )
'	Return( vec * attenuation )
'End

Function Normalize:Double( min:Double, max:Double, current:Double )
	Local range :Double = max - min
	If( range = 0 ) Return 0.0
	Return  Clamp<Double>( ( current - min )/range, 0.0, 1.0 )
End


Function Fractional:Float( x:Float )
	Return ( x - Floor(x) )
End


Function Mix:Float( value0:Float, value1:Float, mix:Float )
	Return ( value0 * ( 1 - mix ) ) + ( value1 * mix )
End


Function SmoothMix:Double( value0:Double, value1:Double, mix:Double )
	Local range :Double = value1 - value0
	If range < 0.000001 And range > -0.000001 Then Return 0.0
	Local x := mix * mix * mix * ( mix * ( ( mix * 6 ) - 15 ) + 10 )
	Return( x * range ) + value0
End


Function SmoothStep:Double( value0:Double, value1:Double, mix:Double )	'normalized
	Local range :Double = value1 - value0
	If range < 0.000001 And range > -0.000001 Then Return 0.0
	mix = Clamp<Double>( (mix - value0) / (value1 - value0), 0.0, 1.0 )
	Return mix * mix * mix * ( mix * ( ( mix * 6 ) - 15 ) + 10 )
End


Function Smooth:Double( source:Double, target:Double, rate:Double = 10.0, delta:Double = one )
	If rate <= 1.0 Then Return target
	Return source + ( (source - target) / (-rate/(delta*delta) ) )
End


Function Quantize:Double( number:Double, size:Double )
	If size Then Return Round( number / size ) * size
	Return number
End


Function QuantizeDown:Double( number:Double, size:Double )		'Snaps to nearest lower value multiple of size
	If size Then Return Floor( number / size ) * size
	Return number
End


Function QuantizeUp:Double( number:Double, size:Double )		'Snaps to nearest upper value multiple of size
	If size Then Return Ceil( number / size ) * size
	Return number
End


Function AngleBetween:Double(x1:Double, y1:Double, x2:Double, y2:Double)
	Return ATan2((y2 - y1), (x2 - x1)) * radToDeg
End


Function RadToDeg:Double ( rad:Double )
	Return rad * radToDeg	'( 180.0 / Pi )
End


Function DegToRad:Double( deg:Double )
	Return deg * degToRad	'( Pi / 180.0 )
End


Function NearestPow:Int( number:Int )
	Return Pow( 2, Ceil( Log( number )/Log( 2 ) ) )
End


Function Format:String( number:Double, decimals:Int = 1 )
	Local arr:String[] = String(number).Split(".")
	If arr.Length > 1
		Return arr[0] + "." + arr[1].Left( decimals )
	Else
		Return arr[0]
	End
End

Function Format:String( vec:Vec2<Float>, decimals:Int = 1 )
	Return Format( vec.X, decimals ) + ", " + Format( vec.Y, decimals )
End

Function Format:String( vec:Vec3<Float>, decimals:Int = 1 )
	Return Format( vec.X, decimals ) + ", " + Format( vec.Y, decimals ) + ", " + Format( vec.Z, decimals )
End




'*********************** Array functions ***********************

Function ArrayContains<T>:Bool( arr:T[], value:T )
	For local n := 0 Until arr.Length
		If arr[ n ] = value Then Return True
	End
	Return False
End

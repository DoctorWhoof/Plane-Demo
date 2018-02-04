Namespace plane

#Import "<std>"
Using std..

Const SMOOTH := 0
Const LINEAR := 1
Const HARD := 2
Const SINE := 3

'Offset acts like a 'seed'. Use distinct large values, like 100, 200, etc.

Function NoiseCurve:Float( x:Float, maxValue:Float, frequency:Float = 1.0, style:Int = SMOOTH, offset:Float = 0.0 )
	
	Local time := (x*frequency)+offset
	Local f := Fractional(time)
	Local r0:Float
	Local r1:Float
	
	If style = SINE
		r0 = Sin(time)
	Else
		r0 = Fractional( Sin(Floor(time))*1000000.0 )
		If style = LINEAR Or style = SMOOTH
			r1 = Fractional( Sin(Ceil(time))*1000000.0 )
		End
	End

	Select style
		Case LINEAR
			Return ( Mix( r0, r1, f ) -0.5 ) * maxValue * 2.0
		Case HARD
			Return ( r0 - 0.5 ) * maxValue * 2.0
		Case SINE
			Return r0 * maxValue
	End

	Return ( SmoothStep( r0, r1, f ) -0.5 ) * maxValue * 2.0
End


Function Fractional:Float( x:Float )
	Return ( x - Floor(x) )
End


Function SmoothStep:Float( value0:Float, value1:Float, x:Float )
	x = Clamp( x, 0.0, 1.0 )
	Local pos := x * x * (3 - 2 * x)
	Return Mix( value0, value1, pos )
End


Function Mix:Float( value0:Float, value1:Float, x:Float )
	Return ( value0 * ( 1 - x ) ) + ( value1 * x )
End



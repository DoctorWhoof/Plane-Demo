Namespace plane 

#Import "<mojo>"
#Import "../NoiseCurve"

Using mojo..

Function Main()
	New AppInstance
	New GraphWindow
	App.Run()
End

Class GraphWindow Extends Window
	
	Field time:= 0.0
	Field timeSpan := 10.0		'in seconds
	Field paused := False
	Field lastTime :Int
	
	Field curveHeight:Float
	Field curveFreq := 1.0
	
	Field maxValue:= 0.0
	Field minValue:= 0.0
	
	Method New()
		Super.New( "Noise graph", 1280, 720, WindowFlags.Resizable | WindowFlags.HighDPI  )
		lastTime = Microsecs()
	End
	
	Method OnRender( canvas:Canvas ) Override
		
		If Keyboard.KeyHit( Key.P )
			paused = Not paused	
		End
		
		If( Not paused ) time += (Microsecs()-lastTime)/1000000.0
		curveHeight = Height/3
		
		canvas.Color = Color.DarkGrey
		canvas.DrawLine( 0, Height/2, Width, Height/2 )
		canvas.DrawLine( Width/2, 0, Width/2, Height )
		
		Local interval := timeSpan/Float(Width)
		Local previousFinal:= curveHeight
		Local finalValue:= 0.0
		
		For Local x := 0.0 Until Width
			
			canvas.Alpha = 1.0
			If( x < Width/2 )
				canvas.Color = Color.White
			Else
				canvas.Color = Color.DarkGrey
			End
			
			Local pixelTime := (interval*x)+time

			Local value1 := NoiseCurve( pixelTime, 100.0, curveFreq, SMOOTH )
'			Local value2 := NoiseCurve( pixelTime, 60, curveFreq*3.0, SMOOTH )
'			Local value3 := NoiseCurve( pixelTime, 20, curveFreq*9.0, SMOOTH )
			
			finalValue = value1' + value2' + value3
			canvas.DrawLine( x-1, previousFinal + Height/2, x, finalValue + Height/2 )
			
			previousFinal = finalValue
		End
		
		If finalValue > maxValue Then maxValue = finalValue
		If finalValue < minValue Then minValue = finalValue
		
		canvas.Alpha = 1.0
		canvas.Color = Color.Orange
		canvas.DrawText( "Time: " + time, Width/2,10 )
		canvas.DrawText( "Value: " + finalValue, Width/2,25 )
		canvas.DrawText( "Time - " + timeSpan/2, 10,10 )
		canvas.DrawText( "Time + " + timeSpan/2, Width-10 ,10, 1.0, 0 )
		canvas.DrawText( "Max: " + maxValue + ", Min: " + minValue, Width/2,Height - 20 )
		canvas.DrawText( "Press 'P' to pause", 10, Height - 20 )
		
		lastTime = Microsecs()
		RequestRender()
	End
	
End
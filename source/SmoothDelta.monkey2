Namespace plane


Function SmoothElapsed:Double( elapsed:Double )

	Local deltaLimit:Double= (Double(1.0)/Double(App.FPS))*1.2		'20% tolerance
	If elapsed > deltaLimit
'		Print elapsed
		elapsed = deltaLimit
	End
	Return elapsed
	
End


Function SmoothDelta:Double( elapsed:Double, speed:Double = 60.0 )

	Return SmoothElapsed( elapsed ) * speed
	
End




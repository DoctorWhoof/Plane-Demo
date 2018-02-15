Namespace plane

Class PlaneDemo Extension
	
	Method DrawLoadingScreen( canvas:Canvas )
		
		Print"~n Loading Assets...~n"
		Local imgAspect := Float(_loadingScreen.Width) / _loadingScreen.Height
		Local imgHeight :=  Height/6
		Local imgWidth := imgHeight * imgAspect
		
		canvas.Clear( Color.Black )
		canvas.DrawRect( Width - imgWidth*2, Height - imgHeight*2, imgWidth, imgHeight, _loadingScreen )
	End	
	
	
End 
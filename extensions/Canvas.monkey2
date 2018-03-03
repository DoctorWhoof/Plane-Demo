Namespace util

Private
Global graphstack:= New Stack<Float>

Public
Class Canvas Extension

	Method Graph( value:Double )

		graphstack.Add( value )
		If graphstack.Length > Viewport.Width
			graphstack.Clear()	
		End
		
	End
	
	
	Method DrawGraph( scale:Double )
		
		Local w := Viewport.Width	
		Local h := Viewport.Height
		
		For Local x := 0 Until w
			Local y0:Double
			Local y:= (-graphstack[x] * scale) + h/2.0
			
			If x = 0
				y0 = y	
			Else
				y0 = (-graphstack[x-1] * scale) + h/2.0
			End
			
			DrawLine( x-1, y0, x, y)
		Next
		
		Color = Color.Black
		DrawLine( 0, h/2, w, h/2 )
	End
	
End

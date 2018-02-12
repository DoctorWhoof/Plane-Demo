Namespace util


Global _echoStack:= New StringStack
Global _colorStack:= New Stack<Color>


'USe this to add text to the Echo Display
Function Echo( text:String, color:Color = Color.White )
	_echoStack.Push( text )
	_colorStack.Push( color )
End


Function Echo( scene:Scene )
	Echo( "Scene", Color.Grey )
	For Local e := EachIn scene.GetRootEntities()
		e.Echo( "|   " )
'		Echo( "    " + e.Name, Color.Grey )
	End
End


'Call this once at the end of each frame.
Function DrawEcho( canvas:Canvas, x:Int=0, y:Int=0, drawRect:Bool = False, border:Int = 5 )
	
	canvas.PushMatrix()
	Local lineY := 2
	Local maxWidth := 0
	
	'Figure out dimensions
	For Local n := 0 Until _echoStack.Length
		local text := _echoStack[ n ]
		Local size := canvas.Font.TextWidth( text )
		If( size > maxWidth ) maxWidth = size
	Next
	
	'Draw rect
	If drawRect
		canvas.Color = New Color( 0, 0, 0, 0.5 )
		canvas.DrawRect( x-border, y+lineY-border, maxWidth+border+border, (canvas.Font.Height*_echoStack.Length)+border+border )
	End
	
	'Draw text
	For Local n := 0 Until _echoStack.Length
		local text := _echoStack[ n ]
		canvas.BlendMode = BlendMode.Alpha
		canvas.Alpha = 1.0

		canvas.Color = _colorStack[ n ]
'		canvas.Color = Color.White
		canvas.DrawText( text, x, y+lineY )
		lineY += canvas.Font.Height
	Next
	
	canvas.PopMatrix()
	_echoStack.Clear()
	_colorStack.Clear()
End


'********************************   Extensions   ********************************

Class Entity Extension
	
	Method Echo( tab:String )
	
		util.Echo( tab + Name )
		
		For Local c := Eachin Children
			c.Echo( tab + ".   " )
		Next	
	End	
	
End

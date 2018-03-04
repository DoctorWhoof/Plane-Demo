Namespace util

#Import "<mojo>"
#Import "<std>"
Using mojo..
Using std..

Class Echo
	
	Global font:Font

	Private
	
	Global _textStack:= New StringStack
	Global _colorStack:= New Stack<Color>
	
	Public
	
	'************************************* Public static functions *************************************
	
	'Use this to add text to the Echo Display
	Function Add( text:String, color:Color = Color.White )
		_textStack.Push( text )
		_colorStack.Push( color )
	End
	
	
	'This will echo the entire mojo3d scene hierarchy, recursively
	Function Add( scene:Scene )
		Add( "Scene", Color.LightGrey )
		For Local e := EachIn scene.GetRootEntities()
			e.Echo( ".   " )
		End
	End
	
	'Draws all echo messages
	Function Draw( canvas:Canvas, x:Int=0, y:Int=0, rectAlpha:Float = 0.5, border:Int = 5 )
		
		If font Then canvas.Font = font
		
		canvas.PushMatrix()
		Local lineY := 2
		Local maxWidth := 0
		
		'Figure out dimensions
		For Local n := 0 Until _textStack.Length
			local text := _textStack[ n ]
			Local size := canvas.Font.TextWidth( text )
			If( size > maxWidth ) maxWidth = size
		Next
		
		'Draw rect
		If rectAlpha > 0.01
			canvas.Alpha = rectAlpha
			canvas.Color = New Color( 0, 0, 0 )
			canvas.DrawRect( x-border, y+lineY-border, maxWidth+border+border, (canvas.Font.Height*_textStack.Length)+border+border )
		End
		
		'Draw text
		For Local n := 0 Until _textStack.Length
			local text := _textStack[ n ]
			canvas.BlendMode = BlendMode.Alpha
			canvas.Alpha = 1.0
	
			canvas.Color = _colorStack[ n ]
			canvas.DrawText( text, x, y+lineY )
			lineY += canvas.Font.Height
		Next
		
		canvas.PopMatrix()
		
		Clear()	
	End
	
	'Clears stacks. MUST BE CALLED when not drawing the current messages or the stacks will grow until they explode.
	Function Clear()
		_textStack.Clear()
		_colorStack.Clear()
	End
	
	
End

'********************************   Extensions   ********************************

Class Entity Extension
	
	Method Echo( tab:String )
		util.Echo.Add( tab + Name )
		For Local c := Eachin Children
			c.Echo( tab + ".   " )
		Next	
	End	
	
End

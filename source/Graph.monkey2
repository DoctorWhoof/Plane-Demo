Namespace util

#Import "<mojo>"
#Import "<std>"
Using mojo..
Using std..

Class Graph
	
	Field color:Color
	
	Global bgAlpha:= 0.75
	Global rightBorder := 10
	Global leftBorder := 100
	
	Private
	
	Field values:= New Deque<Float>
	Global cursor:= 0
	
	Global all:= New Map<String, Graph>
	
	
	'************************************* Public methods *************************************
	
	Public
	
	Method New( name:String, color:Color )
		Self.color = color
		all.Add( name, Self )
	End
	
	'************************************* Private methods *************************************
	
	Private
	
	Method AddValue( v:Float )
		Local c := cursor
		
		If cursor >= values.Length
			values.AddLast( v )
		Else
			values[ cursor ] = v
		End
	End
	
	
	Method Draw( canvas:Canvas, scale:Float )
		
		Local w := canvas.Viewport.Width - rightBorder - leftBorder
		Local h := canvas.Viewport.Height
		
		For Local x := 0 Until values.Length
			Local y0:Double
			Local y:= (-values[x] * scale) + h/2.0
			
			If x = 0
				y0 = y	
			Else
				y0 = (-values[x-1] * scale) + h/2.0
			End
			
			canvas.DrawLine( x-1+leftBorder, y0, x+leftBorder, y)
		Next
		
		canvas.DrawCircle( cursor+leftBorder, (-values[cursor] * scale) + h/2.0, 3 )
	
	End
	
	'************************************* Public static functions *************************************
	
	Public
	
	Function Add( name:String, value:Double, color:Color = Color.White )
		Local g := all[ name ]
		If Not g
			New Graph( name, color )
		Else
			g.AddValue( value )
		End
	End
	

	Function DrawAll( canvas:Canvas, height:Double, range:Double )
		
		Local w := canvas.Viewport.Width - rightBorder - leftBorder
		Local h := canvas.Viewport.Height
		Local mid := h/2
		Local top := mid-height
		Local bottom := mid+height-1
		Local scale := height/range
		Local interval := 60
		
		canvas.Font = Null
		canvas.Alpha = bgAlpha
		canvas.Color = Color.Black
		canvas.DrawRect( leftBorder, top,w, height*2)

		canvas.Alpha = 1.0
		canvas.DrawLine( leftBorder, top, leftBorder+w, top )
		canvas.DrawLine( leftBorder, bottom, leftBorder+w, bottom )
		canvas.DrawRect( rightBorder, top, leftBorder-rightBorder, height*2 )
		
		canvas.Color = Color.LightGrey
		canvas.DrawLine( leftBorder, mid, leftBorder+w, mid )
		canvas.DrawLine( cursor+leftBorder, top, cursor+leftBorder, bottom )
		
		canvas.Color = Color.DarkGrey
		For Local x := leftBorder To w Step interval
			canvas.DrawLine( x, top, x, bottom )	
		Next
		
		canvas.Color = Color.White
		canvas.DrawText( range, leftBorder, top, 1, 0 )
		canvas.DrawText( "0", leftBorder, mid, 1, 1 )
		canvas.DrawText( -range, leftBorder, bottom, 1, 1 )
		
		Local ty := 0
		For Local name := Eachin all.Keys
			Local g := all[name]
			If g
				canvas.Color = g.color
				canvas.DrawText( name, leftBorder, mid-ty, 1, 0 )
				g.Draw( canvas, scale )
				ty -= canvas.Font.Height
			End
		Next
		
		If cursor = w
			For Local g := Eachin all.Values
				g.values.PopFirst()
			Next
		Else
			cursor += 1
		End

	End
	
End

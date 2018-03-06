Namespace plane

Class Paragraph
	
	Field scale := 0.5					'Allows loading fonts at twice the size but drawing smaller for better quality at various resolutions
	Field handle := New Vec2f( 0, 1 )	'Text alignment
	Field leading := 1.0				'Line spacing

	Protected
	Global _styles:= New Stack<TextStyle>
	
	Field _blocks:= New Stack<TextBlock>
	Field _text:= ""
	
	Public
	
	Property Text:String()
		Return _text
	Setter( t:String )
		
		_text = t
		_blocks.Clear()
		Local lineSplits := _text.Split("~n")
		
		Local lineNumber := 0
		If Not _blocks.Empty Then lineNumber = _blocks.Top.lineNumber
		
		Local text := ""
		Local style := 0
		
		For Local line := Eachin lineSplits

			Local n := 0
			While n < line.Length
				
				Local char := String.FromChar( line[n] )
				
				If char = "~"
					If text <> ""
						AddBlock( text, lineNumber, style )
						text = ""
					End
					style = Int( String.FromChar( line[n+1] ) )
					Assert( style > -1 And style < 16, "Paragraph: Invalid style " + style )
					n += 2
				Else
					text += char
					n += 1		
				End

			End

			AddBlock( text, lineNumber, style )
			text = ""
			lineNumber += 1
		Next
		
	End
	
	
	Method New( text:String, style:Int=0, leading:Float=1.0, handle:Vec2f=New Vec2i(0,1) )
		Text = "~" + style + text
		Self.leading = leading
		Self.handle = handle
	End
	
	
	Method Add( text:String, style:Int = 0 )
		Text += "~n~" + style + text
	End
	
	
	Method Draw( canvas:Canvas, x:Int, y:Int )
		Assert( _styles.Length > 0, "~nParagraph: Error, needs at least one text style.")
		canvas.Color = _styles[0].color
		canvas.Alpha = _styles[0].color.A
		canvas.Font = _styles[0].font
		
		Local firstStyle := _styles[ _blocks[0].style ]
		Local offset := New Vec2i( 0, firstStyle.font.Height )
		Local previousHeight:= 0
		Local lineNumber := 0
		
		For Local b := Eachin _blocks
			
			Assert( _styles.Get( b.style ), "Paragraph: Invalid style " + b.style )
			
			If lineNumber <> b.lineNumber
				offset.X = 0
				offset.Y += ( previousHeight * leading )
				previousHeight = 0
			End

			Local font :=  _styles[ b.style ].font
			
			canvas.Color = _styles[ b.style ].color
			canvas.Font = font

			canvas.PushMatrix()
			canvas.Scale( scale, scale )
			canvas.Translate( x/scale, y/scale )
			canvas.DrawText( b.text, offset.X, offset.Y, handle.X, handle.Y )
			canvas.PopMatrix()
			
			offset.X += font.TextWidth( b.text )
			If font.Height > previousHeight
				previousHeight = font.Height
			End
			lineNumber = b.lineNumber
		End
	End
	
	
	Function AddStyle( fontPath:String, height:Int, color:Color = Color.White, flags:TextureFlags = TextureFlags.FilterMipmap )
		Local newStyle := New TextStyle
		newStyle.font = Font.Load( fontPath, height, Null, flags )
		newStyle.color = color
		_styles.Add( newStyle )
	End
	
	
	Function AddStyle( font:Font, color:Color = Color.White )
		Local newStyle := New TextStyle
		newStyle.font = font
		newStyle.color = color
		_styles.Add( newStyle )
	End
	
	Protected
	
	Method AddBlock( text:String, lineNumber:Int, style:Int )
		Local block := New TextBlock
		block.style = style
		block.lineNumber = lineNumber
		block.text = text
		_blocks.Add( block )
	End
	
End


Class TextStyle
	Field font:Font
	Field color:Color
End


Class TextBlock
	Field text:= ""
	Field style:= 0
	Field lineNumber:= 0	
End
	
Namespace util

#Import "<mojo>"
Using mojo..
Using std..

'Fader objects can fade in and out of the screen with user determined timing. 

Class Fader
	
	Field color:Color
	Field fadeIn:Float
	Field fadeOut:Float
	Field length:Float
	
	Protected
	Field startTime:Double
	Field alpha:Float = 0.0
	Field alphaMult:Float = 1.0
	
	Global all:= New Stack<Fader>

	Public
	Function DrawAll( canvas:Canvas )
		For Local m := Eachin all
			m.Update()
			m.Draw( canvas )
		Next	
	End
	
	Function ClearAll()
		all.Clear()
	End
	
	Protected
	Method Update()
		If Now() > startTime
			Local time := Now() - startTime
			
			If time < fadeIn
				alpha = time / fadeIn
			Elseif time < fadeIn + length
				alpha = 1.0
			Elseif time < fadeIn + length + fadeOut
				alpha = 1.0- ( ( time - (fadeIn + length ) ) / fadeOut )
			Else
				all.Remove( Self )
			End
			
			alpha *= alphaMult
		End
	End
	
	Method Draw( canvas:Canvas  ) Virtual
	End

End


'************************************ Extended classes ************************************


Class Message Extends Fader
	
	Field text:String
	Field font:Font
	Field handle:Vec2f
	Field x:Float
	Field y:Float
	
	Field speed:= New Vec2f( 0.0 )
	
	Global defaultFont:Font

	Method New( text:String, x:Float, y:Float, fadein:Float, length:Float, fadeout:Float, delay:Float = 0.25, font:Font = Null, color:Color = Color.White )
		Self.text = text
		Self.font = font
		Self.color = color
		Self.x = x
		Self.y = y
		Self.fadeIn = fadein
		Self.fadeOut = fadeout
		Self.length = length
		Self.startTime = Now() + delay
		Self.handle = New Vec2f( 0.5, 0.5 )
		Fader.all.Add( Self )
	End
	
	Protected
	'allows extended classes to use their own constructors, while staying protected so it can't be called "from outside"
	Method New()
	End
	
	Method Draw( canvas:Canvas  ) Override
		If font
			canvas.Font = font
		Elseif defaultFont
			canvas.Font = defaultFont	
		End
		
		x += speed.X
		y += speed.Y
		
		canvas.Color = color
		canvas.Alpha = alpha
		canvas.DrawText( text, x, y, handle.X, handle.Y )
	End
	
End


Class StackedMessage Extends Message
	
	Global stackedFont:Font
	Global defaultX:Float
	Global defaultY:Float
	
	Method New( text:String, font:Font = Null, color:Color = Color.White )
		Self.text = text
		Self.color = color
		Self.x = defaultX
		Self.y = defaultY
		Self.fadeIn = 0.0
		Self.fadeOut = 2.0
		Self.length = 1.0
		Self.startTime = Now()
		Self.handle = New Vec2f( 1, 1 )
		
		speed = New Vec2f( 0, -0.5 )
		
		If font
			Self.font = font
		Else
			Self.font = stackedFont	
		End
		
		Local height:Int
		Local offset:Int
		
		If font
			height = font.Height
		Elseif stackedFont
			height = stackedFont.Height
		Elseif defaultFont
			height = defaultFont.Height
		End

		Local  lowest:StackedMessage 

		'makes all other messages dimmer and moves them higher according to offset
		For Local m := Eachin all.Backwards()
			Local sm := Cast<StackedMessage>( m )
			If sm
				If Not lowest
					lowest = sm
					'checks if lowest message is too low, adjusts offset value
					If lowest.y > y-height
						offset = lowest.y - (y-height)
					Else
						offset = 0	
					End
				End
				sm.y -= offset
				sm.alphaMult *= 0.75
			End	
		End
		
		Fader.all.Add( Self )
	End	
	
End



Class ScreenFade Extends Fader

	Method New( fadein:Float, length:Float, fadeout:Float, delay:Float = 0.25, color:Color = Color.Black )
		Self.color = color
		Self.fadeIn = fadein
		Self.fadeOut = fadeout
		Self.length = length
		Self.startTime = Now() + delay
		Fader.all.Add( Self )
	End	
	
	Private
	Method Draw( canvas:Canvas ) Override
		canvas.Color = color
		canvas.Alpha = alpha
		canvas.DrawRect( 0.0, 0.0, Float(canvas.Viewport.Width), Float(canvas.Viewport.Height) )
	End
	
End


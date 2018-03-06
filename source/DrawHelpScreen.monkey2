Namespace plane

Class PlaneDemo Extension
	
	Method CreateHelpScreen()
		
		Paragraph.AddStyle( _fontRegular, Color.White )		'0
		Paragraph.AddStyle( _fontItalic, Color.White )		'1
		Paragraph.AddStyle( _fontLight, Color.White )		'2
		Paragraph.AddStyle( _fontMedium, Color.White )		'3
		Paragraph.AddStyle( _fontBig, Color.White )			'4
		
		_helpScreen = Image.Load( "asset::helpBG.png", Null, TextureFlags.FilterMipmap )
		
		_helpText1 = New Paragraph( "FLYING MONKEY", 4, 0.6, New Vec2f( 0.5, 1.0 ) )
		_helpText1.Add( "A Mojo3D Demo", 2 )
		
		_helpText2 = New Paragraph( "Camera controls", 3, 1.2, New Vec2f( 0, 1 ) )
		
		_helpText2.Add( "~nTranslation", 2 )
		_helpText2.Add( "Orbit Vertically: W,S", 0 )
		_helpText2.Add( "Orbit Horizontally: A, D", 0 )
		_helpText2.Add( "Dolly In/Out: Z,X", 0 )
		
		_helpText2.Add( "~nRotation ", 2 )
		_helpText2.Add( "Pan Left/Right: Shift+A, Shift+D", 0 )
		_helpText2.Add( "Tilt Up/Down: Shift+W, Shift+S", 0 )
		
		_helpText2.Add( "~nField of view", 2 )
		_helpText2.Add( "Zoom In/Out:  Equals, Minus",0 )
		
		_helpText2.Add( "~nReset translation: Space bar", 0 )
		_helpText2.Add( "Reset rotation: Shift+Space bar", 0 )
		_helpText2.Add( "Reset FOV: Shift+Space bar", 0 )
		
		_helpText3 = New Paragraph( "Press Escape to resume flying", 2, 0.6, New Vec2f( 0.5, 1.0 ) )
'		
		_helpText4 = New Paragraph( "User Interface", 3, 1.2, New Vec2f( 1, 1 ) )
		
		_helpText4.Add( "Help screen: Escape", 0 )
		_helpText4.Add( "Debug info: Tab", 0 )
		_helpText4.Add( "Select camera: 1, 2", 0 )
		_helpText4.Add( "Toggle camera shake: Enter", 0 )
		_helpText4.Add( "Toggle render quality: Slash", 0 )
		
		_helpText4.Add( "~nAirplane controls", 3 )
		_helpText4.Add( "Turn Left/Right: Cursor Left, Right", 0 )
		_helpText4.Add( "Ascend/Descend: Cursor Down, Up", 0 )
		
		_helpText4.Add( "~nCredits", 3 )
		_helpText4.Add( "Art & Programming: Leo Santos", 0 )
		_helpText4.Add( "http://leosantos.com", 1 )
		_helpText4.Add( "~nCreated using  the Monkey2 Programming Language", 0 )
		_helpText4.Add( "http://monkeycoder.co.nz", 1 )
		
	End
	
	
	Method DrawHelpScreen( canvas:Canvas )
		
		canvas.DrawRect(0, 0, Width, Height, _helpScreen )
		
		_helpText1.Draw( canvas, Width/2, Height*0.05 )
		
		canvas.DrawLine( Width*0.05, Height*0.2, Width*0.95, Height*0.2 )
		
		_helpText2.Draw( canvas, Width*0.05, Height*0.25 )
		
		_helpText3.Draw( canvas, Width/2, Height*0.25 )
		
		_helpText4.Draw( canvas, Width*0.95, Height*0.25 )
		
	End
	
End
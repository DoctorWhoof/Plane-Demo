Namespace asset

Class AssetManager
	
	Private
	Field _assets := New Map< String, Asset >
	Field _finished := False
	
	Public
	
	Property Finished:Bool()
		Return _finished
	End
	
	
	Method Get<T>:T( name:String )
		If _assets[ name ]
			Local a := Cast<T>( _assets[ name ].data )
			If a Then Return a
		End
		Print "Assetmanager: Warning, asset " + name + " not found."
		Return Null
	End
	
	
	Method Add( name:String, path:String, flags:TextureFlags = Null )
		Local asset := New Asset
		asset.path = path
		asset.flags = flags
		_assets.Add( name, asset)
	End
	
	
	Method Load( name:String )
		Local a := _assets[ name ]
		If a
			Select a.path.Right(4)
				Case ".png", ".jpg"
					a.data = Variant( Texture.Load( a.path, a.flags ) )
				Case ".ogg"
					a.data = Variant( Sound.Load( a.path ) )
				Case ".pbr"
					a.data = Variant( PbrMaterial.Load( a.path, a.flags ) )
				Case "gltf", ".glb"
					a.data = Variant( Model.LoadBoned( a.path ) )
			End
		End	
	End
	
	
	Method LoadAll()
		For Local name:=Eachin _assets.Keys
			Load( name )
		Next
		_finished = True
	End
	
End




Class Asset
	
	Field data:Variant
	Field path:String
	Field flags:TextureFlags
	
End
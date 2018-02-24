Namespace mojo3d


Class Model Extension
	
	
	Method GetChild:Model( name:String )
		For Local c := Eachin Children
			Local model := Cast<Model>(c)
			If model
				If model.Name = name
					Print "Found model " + name
					Return model
				Else
					Local recurse := model.GetChild( name )
					If recurse Then Return recurse
				End
			End
		Next
'		Print "Warning: Model " + name + " not found under " + Name
		Return Null
	End
	
	
	Method AssignMaterialToHierarchy( mat:Material )
		
		If Not mat Return
		
		Local matArray := New Material[ Materials.Length ]
		For Local n := 0 Until matArray.Length
			matArray[n] = mat
		Next
		
		Print ( "Replacing material in " + Name )
		Materials = matArray
		
		For Local c := Eachin Children
			Local model := Cast<Model>(c)
			If model
				model.AssignMaterialToHierarchy( mat )
			End
		Next
	End
	
End	

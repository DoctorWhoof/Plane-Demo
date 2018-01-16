import json

node = hou.pwd()
path = node.parm("filePath").eval()
dict = {}

#-------------------------------- Helper functions ----------------------------------

def nodeToJson( n ):
    data = { "Class":"game3d.GameObject",
        'Name':n.name(),
        'Parent': n.inputs()[0].name() if n.inputs() else "",
        'Position':[n.parm("tx").eval(),n.parm("ty").eval(),n.parm("tz").eval()],
        'Rotation':[n.parm("rx").eval(),n.parm("ry").eval(),n.parm("rz").eval()],
        'Scale':[n.parm("sx").eval(),n.parm("sy").eval(),n.parm("sz").eval()],
        'Visible':True if n.parm("display").eval() else False,
        'timeOffset':0 }
    return data
    
def listMaterial( m ):
    pass
    
def compactArrays( t ):
    result = ""
    isArray = False
    for n in range(0, len(t)):
        char = t[n]
        if char == "[":
            isArray = True
        if char == "]":
            isArray = False
        if ( char == "\n" or char == " " ) and isArray:
            char = ""
        if char == ",":
            char = ", "
        result += char
    return result

#-------------------------------- Start Export ----------------------------------

def exportScene():
    print "Exporting Scene to Json file: " + path
    
    for n in hou.node("/mat").children():
        #dict[ n.name() ] = n.name
        print n.name()
        
    #text = json.dumps( dict, sort_keys=True, indent=4, separators=(',',':') )
    #text = compactArrays( text )
    
    #textFile = open( path, "w" )
    #textFile.write( text )
    #textFile.close()
    
    #print text
    #print "Export finished.\n"
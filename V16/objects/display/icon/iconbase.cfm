<cfset GraphicFile = GetTempFile(GetTempDirectory(),'gf') >
<CFX_FileIcon TEMPFILE  = "#GraphicFile#"
	  ICON_NAME = "#attributes.icon_name#"
	  OBJECT    = "#fname#" 				  
	  ICON      = "#iconName#"
	  ICON_TEXT = "#attributes.icon_text#">						   	 	 
 <CFCONTENT
     TYPE="image/jpeg"
     FILE="#GraphicFile#"
     DELETEFILE="Yes" >

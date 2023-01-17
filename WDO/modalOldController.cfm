<cfscript>
	GET_CONTROLLERNAME = getObj.GET_CONTROLLERNAME(userFriendly : attributes.userFriendly);
</cfscript>
<cffile action="read" variable = "icerik" file="#index_folder#/#GET_CONTROLLERNAME.CONTROLLER_FILE_PATH#" charset="UTF-8">
<cfoutput><pre>#htmlCodeFormat(icerik)#</pre></cfoutput>
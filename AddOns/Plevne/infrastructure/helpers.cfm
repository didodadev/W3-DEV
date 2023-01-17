<cffunction name="structKeyByValue">
    <cfargument name="s" default="#{}#">
    <cfargument name="v" default="">
    <cfreturn structFindValue(s,v)[1].KEY>
</cffunction>
<cffunction name="calcFileSize" access="public" output="false" hint="Returns file size in either b, kb, mb, gb, or tb">
	<cfargument name="size" type="numeric" required="true" hint="File size to be rendered" />
	<cfargument name="type" type="string" required="true" default="bytes" />
	
	<cfscript>
		local.newsize = ARGUMENTS.size;
		local.filetype = ARGUMENTS.type;
		do{
			local.newsize = (local.newsize / 1024);
			if(local.filetype eq 'bytes')local.filetype = 'KB';
			else if(local.filetype eq 'KB')local.filetype = 'MB';
			else if(local.filetype eq 'MB')local.filetype = 'GB';
			else if(local.filetype eq 'GB')local.filetype = 'TB';
		}while((local.newsize GT 1024) AND (local.filetype neq arguments.type));
		local.filesize = REMatchNoCase('[(0-9)]{0,}(\.[(0-9)]{0,2})',local.newsize);
		if(arrayLen(local.filesize))return local.filesize[1] & ' ' & local.filetype;
		else return local.newsize & ' ' & local.filetype;
		return local;
	</cfscript>
</cffunction>
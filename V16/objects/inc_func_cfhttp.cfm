<cffunction name="func_cfhttp" access="public" returntype="string">
	<cfargument name="URL" type="string" required="true">
	<cfargument name="ResolveURL" type="boolean" required="false">
	<cfhttp url="#arguments.URL#" resolveurl="#arguments.ResolveURL#"></cfhttp>
	<cfreturn cfhttp.fileContent>
</cffunction>

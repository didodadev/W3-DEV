<cffunction name="cfquery" access="public" returntype="query">
	<cfargument name="SQLString" type="string" required="true">
	<cfargument name="Datasource" type="string" required="true">
	<cfquery name="recordset" datasource="#arguments.Datasource#">
		#preserveSingleQuotes(arguments.SQLString)#
	</cfquery>
	<cfreturn recordset>
</cffunction>

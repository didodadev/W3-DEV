<cfcomponent namespace="SortInterface" extends="EventInterface">
	<cffunction name="init" access="public" returntype="any">
		<cfargument name="_request" type="any" required="yes">
		<cfset super.init(ARGUMENTS._request)>
		<cfset this.rules = variables._request.get_sort_by()>
		<cfreturn this>
	</cffunction>
	<cffunction name="add" access="public" returntype="void">
		<cfargument name="name" type="string" required="yes">
		<cfargument name="dir" type="string" required="yes">
		<cfset variables._request.set_sort(ARGUMENTS.name,ARGUMENTS.dir)>
	</cffunction>
</cfcomponent>


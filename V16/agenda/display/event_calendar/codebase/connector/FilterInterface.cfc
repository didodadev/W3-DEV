<cfcomponent namespace="FilterInterface" extends="EventInterface">
	<cffunction name="init" access="public" returntype="any">
		<cfargument name="_request" type="any" required="yes">
		<cfset variables._request = ARGUMENTS._request>
		<cfset this.rules = variables._request.get_filters()>
		<cfreturn this>
	</cffunction>
	<cffunction name="add" access="public" returntype="void">
		<cfargument name="name" type="string" required="yes">
		<cfargument name="value" type="string" required="yes">
		<cfargument name="rule" type="any" required="yes">
		<cfset variables._request.set_filter(ARGUMENTS.name,ARGUMENTS.value,ARGUMENTS.rule)>
	</cffunction>
</cfcomponent>


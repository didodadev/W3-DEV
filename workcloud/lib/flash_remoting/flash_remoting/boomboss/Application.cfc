<cfcomponent output="false">
	<!--- Application Settings --->
    <cfset THIS.name = "Boomboss Report Beta">
    <cfset THIS.applicationTimeout = createTimeSpan(0, 2, 0, 0)>
    <cfset THIS.sessionManagement = true>
    <cfset THIS.sessionTimeout = createTimeSpan(0, 1, 0, 0)>
</cfcomponent>
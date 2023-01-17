<cfcomponent>
<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="control" access="public" returntype="query">
		<cfargument name="EMPLOYEE_ID" default="">
        <cfquery name="control" datasource="#dsn#">
		    SELECT ER.*, P.REQ_TYPE FROM EMPLOYEE_REQUIREMENTS ER,POSITION_REQ_TYPE  P WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EMPLOYEE_ID#"> AND  ER.REQ_TYPE_ID=P.REQ_TYPE_ID
        </cfquery>
    <cfreturn control />
	</cffunction>
</cfcomponent>
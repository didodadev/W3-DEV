<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfif isdefined("session.ep.period_year")>
		<cfset dsn3 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    </cfif>
	<!--- Gelen E-Fatura ekranindaki print sayisini artırmak icin kullanmali BK20140701--->    
	<cffunction name="update_print_count" access="remote" returnformat="plain" returntype="any">
    <cfargument name="receiving_detail_id" type="string" required="yes">
    <cfset return_val = 1>
    <cfif isdefined("session.ep") and len(arguments.receiving_detail_id)>
		<cftry>
            <cfquery name="UPD_PRINT_COUNT" datasource="#dsn3#">
                UPDATE 
                    EINVOICE_RECEIVING_DETAIL 
                SET 
                    PRINT_COUNT = ISNULL(PRINT_COUNT,0)+1
                WHERE
                    RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.receiving_detail_id#"> 
            </cfquery>
       <cfcatch><cfset return_val = 0></cfcatch>
        </cftry>
  <cfelse>
    	<cfset return_val = -1>
    </cfif>
    <cfreturn return_val>
	</cffunction>
</cfcomponent>

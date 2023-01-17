<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="UPDATE_PAYMENT_DAY" access="remote" returntype="any">
        <cfargument name="puantaj_id" default="">
        <cfargument name="payment_day">
        <cf_date tarih='arguments.payment_day'>
       <cfquery name="UPDATE_PAYMENT_DAY" datasource="#dsn#">
           UPDATE
                EMPLOYEES_PUANTAJ
            SET
                PAYMENT_DATE = <cfif len(arguments.payment_day)><cfqueryparam cfsqltype = "cf_sql_timestamp" value = "#arguments.payment_day#"><cfelse>NULL</cfif>
            WHERE
                PUANTAJ_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#arguments.puantaj_id#">
        </cfquery>
    </cffunction>
</cfcomponent>



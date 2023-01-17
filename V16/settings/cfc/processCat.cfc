<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>

	<cffunction name="getProcessCat" access="remote" returntype="any" returnformat="plain">
        <cfargument name="process_cat" type="numeric" required="yes">
        <cfif isdefined("session.ep")>
            <cfquery name="get_process_cat" datasource="#dsn3#">
            	SELECT 
                	IS_PROCESS_CURRENCY 
                FROM 
                	SETUP_PROCESS_CAT 
               	WHERE 
                	PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_cat#">
            </cfquery>
            <cfset return_val =  SerializeJSON(get_process_cat)>
        <cfelse>
        	<cfset return_val =  ''>
        </cfif>
        <cfreturn return_val>
    </cffunction>

    <cffunction name="getProcessCats" access="public" returntype="query" hint="İşlem tiplerini getirir.">
        <cfquery name="get_process_cats" datasource="#dsn3#">
            SELECT PROCESS_CAT_ID, PROCESS_CAT, PROCESS_TYPE FROM SETUP_PROCESS_CAT ORDER BY PROCESS_CAT
        </cfquery>
        <cfreturn get_process_cats />
    </cffunction>
</cfcomponent>
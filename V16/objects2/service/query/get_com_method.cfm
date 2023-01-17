<cfquery name="GET_COM_METHOD" datasource="#DSN#">
	SELECT 
		COMMETHOD_ID, 
        COMMETHOD
	FROM 
		SETUP_COMMETHOD
		<cfif isdefined("attributes.commethod_id")>
            WHERE
                COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.commethod_id#">
        </cfif>
</cfquery>


<cfquery name="GET_SERVICE_SUBSTATUS" datasource="#DSN3#">
	SELECT 
		SERVICE_SUBSTATUS,
        SERVICE_SUBSTATUS_ID
	FROM 
		SERVICE_SUBSTATUS
	<cfif isdefined("attributes.service_substatus_id")>
        WHERE
            SERVICE_SUBSTATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_substatus_id#">
    </cfif>
</cfquery>

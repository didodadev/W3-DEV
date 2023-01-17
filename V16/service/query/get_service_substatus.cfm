<cfquery name="GET_SERVICE_SUBSTATUS" datasource="#DSN3#">
	SELECT 
		SERVICE_SUBSTATUS_ID,
		#dsn#.Get_Dynamic_Language(SERVICE_SUBSTATUS_ID,'#session.ep.language#','SERVICE_SUBSTATUS','SERVICE_SUBSTATUS',NULL,NULL,SERVICE_SUBSTATUS) AS SERVICE_SUBSTATUS
	FROM 
		SERVICE_SUBSTATUS
		<cfif isDefined("attributes.service_substatus_id")>
        	WHERE
            	SERVICE_SUBSTATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_substatus_id#">
        </cfif>
	ORDER BY
		SERVICE_SUBSTATUS
</cfquery>

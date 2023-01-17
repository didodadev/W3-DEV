<cfquery name="GET_SCHEDULES" datasource="#DSN#">
	SELECT 
		*
	FROM 
		SCHEDULE_SETTINGS 
	WHERE
		<cfif isDefined("attributes.schedule_id")>
           	SCHEDULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.schedule_id#">
    	<cfelse>
            ISNULL(IS_POS_OPERATION,0) = <cfqueryparam cfsqltype="cf_sql_integer" value="#is_pos_operation#">
        </cfif>		
        <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
        	AND SCHEDULE_NAME LIKE '#attributes.keyword#%'
        </cfif>
	ORDER BY
		SCHEDULE_NAME
</cfquery>

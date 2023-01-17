<cfquery name="TMARKET" datasource="#DSN3#">
	SELECT
		*
	FROM
		TARGET_MARKETS
	WHERE
		1=1 
        <cfif isdefined("attributes.tmarket_module") and attributes.tmarket_module is 'call'>
	        AND TMARKET_ID IN (SELECT DISTINCT TMARKET_ID FROM TARGET_AUDIENCE_RECORD)
        </cfif>
		<cfif isDefined("attributes.tmarket_id") and len(attributes.tmarket_id)>
            AND TMARKET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.tmarket_id#">)
        <cfelseif isdefined("attributes.keyword") and len(attributes.keyword)>
            AND (TMARKET_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
            TMARKET_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
        </cfif>
        <cfif isDefined("attributes.is_active") and len(attributes.is_active) and (attributes.is_active) neq 2>
            AND IS_ACTIVE = #attributes.is_active#
        </cfif>	
	ORDER BY
		RECORD_DATE DESC
</cfquery>

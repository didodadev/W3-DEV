<cfquery name="GET_EMAIL_ASSETS" datasource="#DSN3#">
	SELECT 
		FILE_NAME
	FROM 
		CAMPAIGN_ASSETS
	WHERE 
		ASSET_ID IS NOT NULL
		<cfif isDefined("attributes.asset_ids") AND len(attributes.asset_ids)>
			AND ASSET_ID IN (#attributes.asset_ids#)
		<cfelseif isDefined("attributes.email_cont_id")>
			AND EMAIL_CONT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.email_cont_id#">
		</cfif>
</cfquery>

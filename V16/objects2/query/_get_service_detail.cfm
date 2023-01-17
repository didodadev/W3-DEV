<cfquery name="GET_SERVICE_DETAIL" datasource="#dsn#">
	SELECT 
		* 
	FROM
		#dsn3_alias#.SERVICE AS SERVICE,
		#dsn3_alias#.SERVICE_APPCAT AS SERVICE_APPCAT
	WHERE 
		SERVICE.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> AND
		SERVICE.SERVICECAT_ID = SERVICE_APPCAT.SERVICECAT_ID
</cfquery>

<cfquery name="GET_PARTNER_SUPPORT" datasource="#dsn3#">
	SELECT
		*
	FROM
		SERVICE_SUPPORT,
		#dsn_alias#.SETUP_SUPPORT AS SETUP_SUPPORT
	WHERE
		SERVICE_SUPPORT.SUPPORT_CAT_ID = SETUP_SUPPORT.SUPPORT_CAT_ID
		<cfif len(GET_SERVICE_DETAIL.SERVICE_PARTNER_ID)>
		AND		
		(		
			SERVICE_SUPPORT.SALES_PARTNER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.service_partner_id#">
		OR
			SERVICE_SUPPORT.SERVICE_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.service_partner_id#">
		)
		</cfif>
</cfquery>

<cfquery name="GET_SERVICE_SUPPORT" datasource="#dsn3#">
	SELECT
		*
	FROM
		SERVICE_SUPPORT,
		#dsn_alias#.SETUP_SUPPORT AS SETUP_SUPPORT
	WHERE
		SERVICE_SUPPORT.SUPPORT_CAT_ID = SETUP_SUPPORT.SUPPORT_CAT_ID
		<cfif len(GET_SERVICE_DETAIL.SERVICE_CONSUMER_ID)>
		AND
		(
		SERVICE_SUPPORT.SALES_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.service_consumer_id#">
		OR
		SERVICE_SUPPORT.SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.service_consumer_id#">
		)
		</cfif>
</cfquery>


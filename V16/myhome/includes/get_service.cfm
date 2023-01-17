<cfif not isdefined("attributes.to_day") or not len(attributes.to_day)>
	<cfset attributes.to_day=DateAdd('h',session.ep.time_zone,createdate(year(now()),month(now()),day(now())))>
</cfif>
<cfquery name="GET_SERVICE" datasource="#dsn3#">
	SELECT
		SERVICE.SERVICE_ID, 
		SERVICE.SERVICE_HEAD, 
		SERVICE.SERVICE_COMPANY_ID, 
		SERVICE.APPLICATOR_NAME, 
		SERVICE_APPCAT.SERVICECAT
	FROM
		SERVICE,
		SERVICE_APPCAT
	WHERE 
		SERVICE.SERVICECAT_ID = SERVICE_APPCAT.SERVICECAT_ID AND
		(
			ISNULL(SERVICE.UPDATE_DATE,SERVICE.RECORD_DATE) < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('D',1,attributes.to_day)#"> AND
			ISNULL(SERVICE.UPDATE_DATE,SERVICE.RECORD_DATE) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.to_day#">
		)
	ORDER BY
		ISNULL(SERVICE.UPDATE_DATE,SERVICE.RECORD_DATE) DESC
</cfquery>

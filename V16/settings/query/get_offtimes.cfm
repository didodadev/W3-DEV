<cfquery name="GET_OFFTIMES" datasource="#dsn#">
	SELECT 
		*,
		YEAR(START_DATE) YEAR_INFO
	FROM 
		<cfif fusebox.circuit eq 'settings'>SETUP_GENERAL_OFFTIMES<cfelse>SETUP_GENERAL_OFFTIMES_SATURDAY</cfif>
	<cfif isDefined("attributes.offtime_ids")>
	WHERE
		OFFTIME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offtime_ids#">
	</cfif>	
	ORDER BY
		START_DATE
</cfquery>

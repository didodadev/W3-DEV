<cfif isdefined("session.ww.userkey") and session.ww.userkey contains 'C'>
	<cfquery name="GET_COMP_CONS_CAT" datasource="#dsn#">
		SELECT 
			CONSUMER_CAT_ID
		FROM 
			CONSUMER
		WHERE 
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
<cfelse>
	<cfquery name="GET_COMP_CONS_CAT" datasource="#dsn#">
		SELECT 
			C.COMPANYCAT_ID
		FROM 
			COMPANY C,
			COMPANY_PARTNER CP
		WHERE 
			CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
			AND
			C.COMPANY_ID = CP.COMPANY_ID
	</cfquery>
</cfif>

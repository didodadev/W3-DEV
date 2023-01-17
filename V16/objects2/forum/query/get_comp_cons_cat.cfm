<cfif isDefined("session.ww.userid")>
	<cfquery name="GET_COMP_CONS_CAT" datasource="#DSN#">
		SELECT 
			CONSUMER_CAT_ID
		FROM 
			CONSUMER
		WHERE 
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
<cfelseif isDefined("session.pp.userid")>
	<cfquery name="GET_COMP_CONS_CAT" datasource="#DSN#">
		SELECT 
			C.COMPANYCAT_ID
		FROM 
			COMPANY C,
			COMPANY_PARTNER CP
		WHERE 
			CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
			AND
			C.COMPANY_ID = CP.COMPANY_ID
	</cfquery>
</cfif>

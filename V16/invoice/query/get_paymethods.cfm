<cfquery name="PAYMETHODS" datasource="#dsn#">
	SELECT
		<cfif isDefined("attributes.NAMES")>
			SP.PAYMETHOD_ID,
			SP.PAYMETHOD
		<cfelse>
			SP.*
		</cfif>
	FROM
		SETUP_PAYMETHOD SP,
		SETUP_PAYMETHOD_OUR_COMPANY SPOC
	WHERE
		SP.PAYMETHOD_STATUS = 1
		AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
		AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
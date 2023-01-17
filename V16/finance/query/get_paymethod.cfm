<!--- get_commethod.cfm --->
<cfquery name="GET_PAYMETHOD" datasource="#dsn#">
	SELECT 
		SP.* 
	FROM 
		SETUP_PAYMETHOD SP,
		SETUP_PAYMETHOD_OUR_COMPANY SPOC
	WHERE
	    SP.PAYMETHOD_STATUS = 1
		AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
		AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		<cfif isdefined("attributes.paymethod_id")>
			AND SP.PAYMETHOD_ID = #attributes.PAYMETHOD_ID#
		</cfif>
	ORDER BY
		SP.PAYMETHOD
</cfquery>


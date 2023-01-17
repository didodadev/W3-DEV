<cfif not isdefined("attributes.period_id") >
	<cfset attributes.period_id = SESSION.EP.PERIOD_ID>
</cfif>
<cfquery name="GET_OTHER_PERIOD" datasource="#DSN#">
	SELECT	
		* 
	FROM 
		SETUP_PERIOD 
	WHERE 
		OUR_COMPANY_ID = #SESSION.EP.COMPANY_ID# AND 
		PERIOD_ID = #attributes.period_id#
</cfquery>

<cfquery name="GET_IN_OUT_PERIODS" datasource="#DSN#">
	SELECT
		*
	FROM
		EMPLOYEES_IN_OUT_PERIOD EPP,
		EMPLOYEES_IN_OUT EP
	WHERE
		EP.IN_OUT_ID = #attributes.in_out_id# AND
		EP.IN_OUT_ID = EPP.IN_OUT_ID AND
		EPP.PERIOD_ID = #attributes.period_id#
</cfquery>

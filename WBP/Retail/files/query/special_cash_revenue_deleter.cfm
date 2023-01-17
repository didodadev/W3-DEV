<cfquery name="get_" datasource="#dsn2#">
SELECT
	*
FROM
	(
	SELECT
		ISNULL((SELECT S.COMPANY_ID FROM SHIP S WHERE S.SHIP_ID = CASH_ACTIONS.SPECIAL_DEFINITION_ID),0) AS IRSALIYE_SIRKETI,
		CASH_ACTION_FROM_COMPANY_ID,
		ACTION_ID	
	FROM
		CASH_ACTIONS
	WHERE
		SPECIAL_DEFINITION_ID IS NOT NULL AND
		CASH_ACTION_FROM_COMPANY_ID = 509
	) T1
WHERE
	CASH_ACTION_FROM_COMPANY_ID <> IRSALIYE_SIRKETI
</cfquery>

<cftry>
	<cfscript>
			cari_sil(action_id:-1,process_type:-1);
	</cfscript>
<cfcatch type="any">
	<cfinclude template="/objects/functions/get_carici.cfm">
</cfcatch>	
</cftry>

<cftry>
	<cfscript>
			muhasebe_sil(action_id:-1,process_type:-1);
	</cfscript>
<cfcatch type="any">
	<cfinclude template="/objects/functions/get_muhasebeci.cfm">
</cfcatch>
</cftry>

<cfoutput query="get_">
	<cfset attributes.old_process_type = 31>
    <cfset attributes.id = action_id>
    <cfset url.id = action_id>
    <cfset attributes.detail = ''>
    <cfset attributes.xml_import = 1>
    <cfinclude template="/cash/query/del_cash_revenue.cfm">
</cfoutput>
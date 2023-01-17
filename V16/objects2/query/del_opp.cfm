<cfset attributes.action_id=attributes.OPP_ID>
<cfset attributes.action_section="OPP_ID">
<cfinclude template="../../objects/query/del_assets.cfm">
<cfquery name="DEL_OPP_PLUS" datasource="#dsn3#">
	DELETE
	FROM
		OPPORTUNITIES_PLUS
	WHERE
		OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#opp_id#">
</cfquery>	

<cfquery datasource="#dsn3#" name="del_opp">
	DELETE FROM OPPORTUNITIES WHERE OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opp_id#">
</cfquery>
<cflocation url="#request.self#?fuseaction=objects2.list_opportunities" addtoken="No">

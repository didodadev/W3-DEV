<cfquery name="DEL_OFFER" datasource="#DSN3#">
	DELETE FROM OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>
<cfquery name="DEL_OFFER_ROW" datasource="#DSN3#">
	DELETE FROM OFFER_ROW WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>
<cflocation url="#request.self#?fuseaction=objects2.view_list_offer" addtoken="no">

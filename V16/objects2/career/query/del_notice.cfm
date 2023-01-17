<cfquery name="upd_notice" datasource="#dsn#">
	DELETE FROM NOTICES WHERE NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.notice_id#">
</cfquery>
<cflocation url="#request.self#?fuseaction=objects2.list_notices_partner" addtoken="No">

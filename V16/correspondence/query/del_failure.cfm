<cfquery name="del_failure" datasource="#dsn#">
	DELETE FROM ASSET_FAILURE_NOTICE WHERE FAILURE_ID = #attributes.failure_id#	
</cfquery>
<cflocation url="#request.self#?fuseaction=correspondence.list_asset_failure" addtoken="no">

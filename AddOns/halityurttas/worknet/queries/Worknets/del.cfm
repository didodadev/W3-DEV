<cfquery name="del_worknet" datasource="#dsn#">
	DELETE FROM WORKNET WHERE WORKNET_ID = #attributes.worknet_id#
</cfquery>

<cflocation url="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['list']['fuseaction']#" addtoken="no">
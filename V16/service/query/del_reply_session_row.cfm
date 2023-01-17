<cfquery name="DEL_TASK" datasource="#dsn3#">
	DELETE FROM
		SERVICE_REPLY
	WHERE
		SERVICEREPLY_ID=#SESSION[VAR_][ROW][8]#
</cfquery>

<cfoutput>#arraydeleteat(session[url.var_],url.row)#</cfoutput>
<cflocation url="#request.self#?fuseaction=service.list_service&event=upd&service_id=#URL.ID#" addtoken="No">

<cfquery name="upd_group" datasource="#DSN#">
	UPDATE 
		EMPLOYEES_PUANTAJ_GROUP
	SET
		GROUP_NAME = '#group_name#',
        UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.REMOTE_ADDR#'
	WHERE
		GROUP_ID = #attributes.group_id#
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
		location.reload();
	</cfif>
</script>
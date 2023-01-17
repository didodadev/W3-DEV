<cfquery name="add_prize_type" datasource="#dsn#">
  INSERT INTO
    EMPLOYEES_PUANTAJ_GROUP
	(
		GROUP_NAME,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	)
	VALUES
	(
		'#group_name#',
		#now()#,
		#session.ep.userid#,
		'#cgi.REMOTE_ADDR#'
	)
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

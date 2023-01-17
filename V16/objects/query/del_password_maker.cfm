<cfquery name="GET_PASSWORD_MAKER" datasource="#DSN#">
	SELECT PARTNER_ID,EMPLOYEE_ID,PASSWORD_MAKER_NO FROM PASSWORD_MAKER WHERE PASSWORD_MAKER_ID = #attributes.pass_id#
</cfquery>

<cfquery name="DEL_CONTRACT" datasource="#DSN#">
	DELETE FROM PASSWORD_MAKER WHERE PASSWORD_MAKER_ID = #attributes.pass_id#
</cfquery>
<cf_add_log  log_type="-1" action_id="#attributes.pass_id#" action_name="#get_password_maker.partner_id#-#get_password_maker.employee_id#-#get_password_maker.password_maker_no#">

<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</cfif>
</script>

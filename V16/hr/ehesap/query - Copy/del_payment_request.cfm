
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery  name="del_rec" datasource="#DSN#">
			DELETE FROM
				CORRESPONDENCE_PAYMENT
			WHERE
				ID=#attributes.id#
		</cfquery>
		<cfquery name="del_pay" datasource="#DSN#">
			DELETE FROM
				SALARYPARAM_GET
			WHERE
				PAYMENT_ID=#attributes.id#
		</cfquery>
		<cf_add_log  log_type="-1" action_id="#attributes.id#" action_name="Avans Silme - Employee:#attributes.employee_id#" process_type="0">
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif isdefined("attributes.modal_id") and len(attributes.modal_id)>
			closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
			location.href = document.referrer;
		<cfelse>
			wrk_opener_reload();
			window.close();
		</cfif>
</script>

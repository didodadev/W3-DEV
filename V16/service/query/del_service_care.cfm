<cfquery name="get_paper_no" datasource="#dsn3#">
	SELECT SERIAL_NO FROM SERVICE_CARE WHERE PRODUCT_CARE_ID = #URL.ID# 
</cfquery>
<cftransaction>
	<cfquery name="DEL_SUPPORT" datasource="#DSN3#">
		DELETE 
		FROM 
			SERVICE_CARE
		WHERE
			PRODUCT_CARE_ID = #URL.ID# 
	</cfquery>
	<cfquery name="DEL_CARE_STATES" datasource="#DSN3#">
		DELETE
		FROM
			#dsn_alias#.CARE_STATES
		WHERE
			SERVICE_ID=#URL.ID#
	</cfquery>
	<cf_add_log  log_type="-1" action_id="#attributes.id#" action_name="#attributes.head#" PAPER_NO="#get_paper_no.serial_no#" data_source="#dsn3#">
</cftransaction>
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=service.list_care</cfoutput>"
</script>


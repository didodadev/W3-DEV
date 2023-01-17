<cfif attributes.valid_type eq 1>
	<cfquery name="UPD_REQ_ROWS" datasource="#dsn#">
		UPDATE
			TRAINING_REQUEST_ROWS
		SET
			IS_CHIEF_VALID=1,
			IS_VALID = 0,
			CHIEF_VALID_DATE = #NOW()#
		WHERE 
			REQUEST_ROW_ID = #attributes.request_row_id#
	</cfquery>
<cfelseif attributes.valid_type eq 0>
	<cfquery name="UPD_REQ_ROWS" datasource="#dsn#">
		UPDATE
			TRAINING_REQUEST_ROWS
		SET
			IS_CHIEF_VALID=-1,
			IS_VALID = -1,
			CHIEF_VALID_DATE = #NOW()#
		WHERE 
			REQUEST_ROW_ID = #attributes.request_row_id#
	</cfquery>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

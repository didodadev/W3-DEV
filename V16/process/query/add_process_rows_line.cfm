<cfsetting showdebugoutput="no">
<cfif attributes.type eq 0>
	<cfquery name="ADD_LINE_PLUS" datasource="#dsn#">
		UPDATE 
			PROCESS_TYPE_ROWS
		SET
			LINE_NUMBER = #attributes.line_number+1#
		WHERE 
			PROCESS_ID = #attributes.process_id# AND
			LINE_NUMBER = #attributes.line_number# AND
			PROCESS_ROW_ID = #attributes.process_row_id#
	</cfquery>
	<cfquery name="ADD_LINE_MINUS" datasource="#dsn#">
		UPDATE 
			PROCESS_TYPE_ROWS 
		SET
			LINE_NUMBER = #attributes.line_number#
		WHERE 
			PROCESS_ID = #attributes.process_id# AND
			LINE_NUMBER = #attributes.line_number+1# AND
			PROCESS_ROW_ID <> #attributes.process_row_id#
	</cfquery>
</cfif>
<cfif attributes.type eq 1>
	<cfquery name="ADD_LINE_PLUS" datasource="#dsn#">
		UPDATE 
			PROCESS_TYPE_ROWS 
		SET
			LINE_NUMBER = #attributes.line_number-1#
		WHERE 
			PROCESS_ID = #attributes.process_id# AND
			LINE_NUMBER = #attributes.line_number# AND
			PROCESS_ROW_ID = #attributes.process_row_id#
	</cfquery>
	<cfquery name="ADD_LINE_MINUS" datasource="#dsn#">
		UPDATE 
			PROCESS_TYPE_ROWS 
		SET
			LINE_NUMBER = #attributes.line_number#
		WHERE 
			PROCESS_ID = #attributes.process_id# AND
			LINE_NUMBER = #attributes.line_number-1# AND
			PROCESS_ROW_ID <> #attributes.process_row_id#
	</cfquery>
</cfif>
<cfquery name="upd_process_type" datasource="#dsn#">
	UPDATE
		PROCESS_TYPE
	SET
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_EMP = #session.ep.userid#
	WHERE
		PROCESS_ID = #attributes.process_id#
</cfquery>
<script type="text/javascript">
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=process.emptypopupajax_dsp_process_stage&process_id=#process_id#</cfoutput>',process_stage_div,1);
</script>

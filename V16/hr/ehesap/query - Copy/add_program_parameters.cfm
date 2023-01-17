<CFTRANSACTION>
<cfquery name="add_query" datasource="#dsn#">
		INSERT INTO
			SETUP_PROGRAM_PARAMETERS
			(
			PARAMETER_NAME,
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP
			)
		VALUES
			(
			'#attributes.parameter_name#',
			#NOW()#,
			'#CGI.REMOTE_ADDR#',
			#SESSION.EP.USERID#
			)
	</cfquery>
	
	<cfquery name="LAST_ID" datasource="#DSN#">
		SELECT MAX(PARAMETER_ID) AS LATEST_PARAMETER_ID FROM SETUP_PROGRAM_PARAMETERS
	</cfquery>
</CFTRANSACTION>
<cfset attributes.param_id = LAST_ID.LATEST_PARAMETER_ID>
<cfinclude template="add_parameters_history.cfm">
<cfset attributes.actionId = LAST_ID.LATEST_PARAMETER_ID>
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=ehesap.list_program_parameters&event=upd&parameter_id=#LAST_ID.LATEST_PARAMETER_ID#</cfoutput>";
</script>

<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>

	<cfquery name="DEL_CLASS_ATTENDER_EVAL" datasource="#dsn#">
		DELETE FROM
			TRAINING_CLASS_ATTENDER_EVAL
		WHERE
			CLASS_ID = #attributes.CLASS_ID#
	</cfquery>	
		
	</CFTRANSACTION>
</CFLOCK>

<script type="text/javascript">
wrk_opener_reload();
window.close();
</script>

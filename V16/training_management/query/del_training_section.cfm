<cfquery name="DEL_section" datasource="#dsn#">
	DELETE FROM
		TRAINING_SEC
	WHERE
		TRAINING_SEC_ID = #attributes.TRAINING_SEC_ID#
</cfquery>
<script>
        window.location.href = '<cfoutput>#request.self#?fuseaction=training_management.definitions</cfoutput>';
</script>


<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>

		<cfquery name="DEL_PROCESS_CAT_ROWS" datasource="#dsn3#">
			DELETE SETUP_PROCESS_CAT_ROWS WHERE PROCESS_CAT_ID = #ATTRIBUTES.PROCESS_CAT_ID#
		</cfquery>
		
		<cfquery name="DEL_PROCESS_CAT" datasource="#dsn3#">
			DELETE SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #ATTRIBUTES.PROCESS_CAT_ID#
		</cfquery>

	</CFTRANSACTION>
</CFLOCK>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
<!--- <cflocation url="#request.self#?fuseaction=settings.form_add_process_cat" addtoken="no"> --->

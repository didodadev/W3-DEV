<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="DEL_COMPUTER_INFO" datasource="#dsn#">
			DELETE FROM SETUP_COMPUTER_INFO WHERE COMPUTER_INFO_ID=#COMPUTER_INFO_ID#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_computer_info" addtoken="no">

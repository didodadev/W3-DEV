<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_SETUP_COMPUTER_INFO" datasource="#dsn#">
			UPDATE 
				SETUP_COMPUTER_INFO 
			SET 
				COMPUTER_INFO_NAME = '#COMPUTER_INFO_NAME#',
				COMPUTER_INFO_DESCRIPTION = '#COMPUTER_INFO_DESCRIPTION#',
				COMPUTER_INFO_STATUS = <cfif isDefined('attributes.computer_info_status')>1<cfelse>0</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE 
				COMPUTER_INFO_ID=#COMPUTER_INFO_ID#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_computer_info" addtoken="no">

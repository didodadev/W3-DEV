<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_SETUP_COMPUTER_INFO" datasource="#dsn#">
			INSERT 
			INTO 
				SETUP_COMPUTER_INFO
				(
					COMPUTER_INFO_NAME,
					COMPUTER_INFO_DESCRIPTION,
					COMPUTER_INFO_STATUS,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				) 
			VALUES 
				(
					'#COMPUTER_INFO_NAME#',
					'#COMPUTER_INFO_DESCRIPTION#',
					<cfif isDefined('attributes.computer_info_status')>1<cfelse>0</cfif>,
					#session.ep.userid#,
					#NOW()#,
					'#CGI.REMOTE_ADDR#'
				)
		</cfquery>		
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_computer_info" addtoken="no">

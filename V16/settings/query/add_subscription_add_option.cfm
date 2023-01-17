<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="ADD_SUBS_OPTIONS" datasource="#dsn3#">
			INSERT INTO 
				SETUP_SUBSCRIPTION_ADD_OPTIONS
				(
					SUBSCRIPTION_ADD_OPTION_NAME,
					DETAIL,
					RECORD_IP,
					RECORD_DATE,
					RECORD_EMP
				) 
			VALUES 
				(
					'#attributes.add_option_name#',
					<cfif len(attributes.add_option_detail)>'#attributes.add_option_detail#',<cfelse>NULL,</cfif>
					'#CGI.REMOTE_ADDR#',
					#NOW()#,
					#SESSION.EP.USERID#
				)
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.add_subscription_add_option" addtoken="no">

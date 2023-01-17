<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="UPD_SUBSCRIPTION_OPTIONS" datasource="#dsn3#">
			UPDATE 
				SETUP_SUBSCRIPTION_ADD_OPTIONS
			SET 
				SUBSCRIPTION_ADD_OPTION_NAME = '#attributes.add_option_name#',
				DETAIL = <cfif len(attributes.add_option_detail)>'#attributes.add_option_detail#',<cfelse>NULL,</cfif>
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_DATE = #NOW()#,
				UPDATE_EMP = #SESSION.EP.USERID#
			WHERE 
				SUBSCRIPTION_ADD_OPTION_ID = #attributes.subs_option_id#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.add_subscription_add_option" addtoken="no">

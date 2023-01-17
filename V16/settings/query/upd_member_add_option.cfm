<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="UPD_MEMBER_OPTIONS" datasource="#DSN#">
			UPDATE 
				SETUP_MEMBER_ADD_OPTIONS
			SET 
				MEMBER_ADD_OPTION_NAME = '#attributes.add_option_name#',
				DETAIL = <cfif len(attributes.add_option_detail)>'#attributes.add_option_detail#'<cfelse>NULL</cfif>,
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#
			WHERE 
				MEMBER_ADD_OPTION_ID = #attributes.member_option_id#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.add_member_add_option" addtoken="no">

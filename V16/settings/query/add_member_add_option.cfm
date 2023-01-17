<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="ADD_SALE_OPTIONS" datasource="#DSN#">
			INSERT INTO 
				SETUP_MEMBER_ADD_OPTIONS
			(
				MEMBER_ADD_OPTION_NAME,
				DETAIL,
				RECORD_IP,
				RECORD_DATE,
				RECORD_EMP
			) 
			VALUES 
			(
				'#attributes.add_option_name#',
				<cfif len(attributes.add_option_detail)>'#attributes.add_option_detail#'<cfelse>NULL</cfif>,
				'#cgi.remote_addr#',
				#now()#,
				#session.ep.userid#
			)
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.add_member_add_option" addtoken="no">

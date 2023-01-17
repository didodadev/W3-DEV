<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="ADD_BANK_TYPE" datasource="#DSN#" result="MAX_ID">
			INSERT
			INTO
				SETUP_BANK_TYPES
				(
					BANK_NAME,
					BANK_CODE,
					DETAIL,
					EXPORT_TYPE,
					FTP_SERVER_NAME,
					FTP_FILE_PATH,
					FTP_USERNAME,
					<cfif len(attributes.ftp_password)>FTP_PASSWORD,</cfif>
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP,
					SWIFT_CODE,
					BANK_TYPE_GROUP_ID
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.bank_type#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.bank_code#">,
					<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,<cfelse>NULL,</cfif>
					<cfif len(attributes.export_type)>#attributes.export_type#,<cfelse>NULL,</cfif>
					<cfif len(attributes.ftp_server)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ftp_server#">,<cfelse>NULL,</cfif>
					<cfif len(attributes.ftp_file_path)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ftp_file_path#">,<cfelse>NULL,</cfif>
					<cfif len(attributes.ftp_username)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ftp_username#">,<cfelse>NULL,</cfif>
					<cfif len(attributes.ftp_password)><cfqueryparam cfsqltype="cf_sql_varchar" value='#Encrypt(attributes.ftp_password,attributes.export_type,"CFMX_COMPAT","Hex")#'>,</cfif>
					#session.ep.userid#,
					#now()#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					<cfif len(attributes.swift_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.swift_code#">,<cfelse>NULL,</cfif>
					<cfif len(attributes.bank_type_group)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_type_group#"><cfelse>NULL</cfif>
				)
		</cfquery>
		  <cfset bank_id = MAX_ID.IDENTITYCOL>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_upd_bank_type&bank_id=#bank_id#" addtoken="no">

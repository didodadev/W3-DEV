<cfquery name="UPD_BANK_TYPE" datasource="#DSN#">
	UPDATE
		SETUP_BANK_TYPES
	SET
		BANK_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.bank_type#">,
		BANK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.bank_code#">,
		DETAIL = <cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
		EXPORT_TYPE = <cfif len(attributes.export_type)>#attributes.export_type#,<cfelse>NULL,</cfif>
		FTP_SERVER_NAME = <cfif len(attributes.ftp_server)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ftp_server#">,<cfelse>NULL,</cfif>
		FTP_FILE_PATH = <cfif len(attributes.ftp_file_path)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ftp_file_path#">,<cfelse>NULL,</cfif>
		FTP_USERNAME = <cfif len(attributes.ftp_username)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ftp_username#">,<cfelse>NULL,</cfif>
		<cfif len(attributes.ftp_password)>FTP_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value='#Encrypt(attributes.ftp_password,attributes.export_type,"CFMX_COMPAT","Hex")#'>,</cfif>
		UPDATE_DATE=#NOW()#,
		UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
		UPDATE_EMP=#SESSION.EP.USERID#,
		SWIFT_CODE = <cfif len(attributes.swift_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.swift_code#">,<cfelse>NULL,</cfif>
		BANK_TYPE_GROUP_ID = <cfif len(attributes.bank_type_group)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_type_group#"><cfelse>NULL</cfif>
	WHERE
		BANK_ID = #attributes.bank_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_upd_bank_type&bank_id=#attributes.bank_id#" addtoken="no">

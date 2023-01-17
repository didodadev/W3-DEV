<cfscript>
	my_list = Trim(attributes.module_field_name);
	my_list = ReplaceList(my_list,'#chr(13)#','');
	my_list = ReplaceList(my_list,'#chr(10)#','');
</cfscript>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_DOCUMENT_TYPE" datasource="#DSN#" result="MAX_ID">
			INSERT INTO 
				SETUP_DOCUMENT_TYPE
			(
				DOCUMENT_TYPE_NAME,
				DOCUMENT_TYPE_DETAIL,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP			
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.document_name#">,
				<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			)	
		</cfquery>
		<cfloop from="1" to="#ListLen(my_list)#" index="Counter">
			<cfquery name="ADD_DOCUMENT_TYPE_ROW" datasource="#DSN#">
				INSERT INTO 
					SETUP_DOCUMENT_TYPE_ROW
				(
					DOCUMENT_TYPE_ID,
					FUSEACTION
				)
				VALUES
				(
					#MAX_ID.IDENTITYCOL#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(my_list, Counter)#">
				)	
			</cfquery>
		</cfloop>
	</cftransaction>
</cflock>

<cflocation url="#request.self#?fuseaction=settings.form_add_document_type" addtoken="no">

<cfscript>
	my_list = Trim(attributes.module_field_name);
	my_list = ReplaceList(my_list,'#chr(13)#','');
	my_list = ReplaceList(my_list,'#chr(10)#','');
</cfscript>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="UPD_DOCUMENT_TYPE" datasource="#DSN#">
			UPDATE 
				SETUP_DOCUMENT_TYPE
			SET
				DOCUMENT_TYPE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.document_name#">,
				DOCUMENT_TYPE_DETAIL = <cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			WHERE 
				DOCUMENT_TYPE_ID = #attributes.document_type_id#	 
		</cfquery>
		<cfquery name="DEL_DOCUMENT_TYPE_ROW" datasource="#dsn#">
			DELETE FROM SETUP_DOCUMENT_TYPE_ROW WHERE DOCUMENT_TYPE_ID = #attributes.document_type_id#
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
					#attributes.document_type_id#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(my_list, Counter)#">
				)	
			</cfquery>
		</cfloop>
	</cftransaction>
</cflock>
<script>
	location.href = document.referrer;
</script>
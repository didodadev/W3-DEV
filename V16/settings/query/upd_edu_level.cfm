<cfquery name="ADD_REC" datasource="#DSN#">
	UPDATE
		 SETUP_EDUCATION_LEVEL 
	SET
		EDUCATION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.edu_cat_name#">,
		IS_ACTIVE=<cfif isdefined("attributes.is_aktif")>1<cfelse>0</cfif>,
		EDU_TYPE=<cfif len(attributes.edu_type)>#attributes.edu_type#<cfelse>NULL</cfif>,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		DECLARATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.declaration_id#">
	WHERE 
		EDU_LEVEL_ID=#attributes.edu_id#
</cfquery>
<script>
	location.href=document.referrer;
</script>

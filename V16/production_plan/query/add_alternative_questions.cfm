<cfquery name="add_questions" datasource="#dsn#">
	INSERT INTO
		SETUP_ALTERNATIVE_QUESTIONS 
		(
			QUESTION_NO,
			QUESTION_NAME,
			QUESTION_DETAIL,
			LANG_MODULE,
			LANG_ITEM_ID,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP,
			ALTERNATIVE_PROCESS,
			PROPERTY_ID
		)
	VALUES
		(
		 <cfif isdefined("attributes.QUESTION_NO") and len(attributes.QUESTION_NO)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.QUESTION_NO#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.QUESTION_NAME") and len(attributes.QUESTION_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.QUESTION_NAME#"><cfelse>NULL</cfif>, 
		<cfif isdefined("attributes.QUESTION_DETAIL") and len(attributes.QUESTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.QUESTION_DETAIL#"><cfelse>NULL</cfif>, 
		<cfif isdefined("attributes.LANG_MODULE") and len(attributes.LANG_MODULE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.LANG_MODULE#"><cfelse>NULL</cfif>, 
		<cfif isdefined("attributes.LANG_ITEM_ID") and len(attributes.LANG_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LANG_ITEM_ID#"><cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		<cfif isdefined("attributes.ALTERNATIVE_PROCESS") and len(attributes.ALTERNATIVE_PROCESS)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ALTERNATIVE_PROCESS#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.PROPERTY_ID") and len(attributes.PROPERTY_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PROPERTY_ID#"><cfelse>NULL</cfif>
		)
</cfquery>
<script type="text/javascript">
	location.href = document.referrer;
</script>

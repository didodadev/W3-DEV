<cfquery name="upd_questions" datasource="#dsn#">
	UPDATE
		SETUP_ALTERNATIVE_QUESTIONS 
	SET
		QUESTION_NO= <cfif isdefined("attributes.QUESTION_NO") and len(attributes.QUESTION_NO)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.QUESTION_NO#"><cfelse>NULL</cfif>,
		QUESTION_NAME=<cfif isdefined("attributes.QUESTION_NAME") and len(attributes.QUESTION_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.QUESTION_NAME#"><cfelse>NULL</cfif>, 
		QUESTION_DETAIL=<cfif isdefined("attributes.QUESTION_DETAIL") and len(attributes.QUESTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.QUESTION_DETAIL#"><cfelse>NULL</cfif>, 
		LANG_MODULE=<cfif isdefined("attributes.LANG_MODULE") and len(attributes.LANG_MODULE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.LANG_MODULE#"><cfelse>NULL</cfif>, 
		LANG_ITEM_ID= <cfif isdefined("attributes.LANG_ITEM_ID") and len(attributes.LANG_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LANG_ITEM_ID#"><cfelse>NULL</cfif>,
		UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,    
        UPDATE_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
        UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		ALTERNATIVE_PROCESS=<cfif len(attributes.alternative_process)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.alternative_process#"><cfelse>NULL</cfif>,
		PROPERTY_ID=<cfif len(attributes.PROPERTY_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PROPERTY_ID#"><cfelse>NULL</cfif>
	WHERE
		QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.QUESTION_ID#">
</cfquery>

<script type="text/javascript">
location.href = document.referrer;
</script>
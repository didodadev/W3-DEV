<cfquery name="get_lang_name" datasource="#dsn#">
	SELECT
		ITEM,
		LANGUAGE
	FROM 
		SETUP_LANGUAGE_INFO
	WHERE
		UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TERM_ID#"> AND
		COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="TERM"> AND
		TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_MEMBER_ANALYSIS_TERM"> AND
        LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
</cfquery>
<cfif get_lang_name.recordcount>
	<cfquery name="upd_" datasource="#dsn#">
    	UPDATE 
			SETUP_LANGUAGE_INFO 
		SET 
			ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.period#"> 
		WHERE 
			UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TERM_ID#"> AND 	
			COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="TERM"> AND
			TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_MEMBER_ANALYSIS_TERM"> AND
			LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
    </cfquery>
</cfif>
<cfquery name="UPDTERM" datasource="#DSN#">
	UPDATE 
		SETUP_MEMBER_ANALYSIS_TERM 
	SET 
		TERM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.period#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE 
		TERM_ID = #TERM_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_member_analysis_period" addtoken="no">

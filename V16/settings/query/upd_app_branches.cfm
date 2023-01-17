<cfquery name="get_lang" datasource="#dsn#">
	SELECT
		ITEM,
		LANGUAGE
	FROM 
		SETUP_LANGUAGE_INFO
	WHERE
		UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BRANCHES_ID#"> AND
		COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="BRANCHES_NAME"> AND
		TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_APP_BRANCHES"> AND
		LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
</cfquery>
<cfif get_lang.recordcount>
	<cfquery name="upd_" datasource="#dsn#">
    	UPDATE 
			SETUP_LANGUAGE_INFO 
		SET 
			ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#branches_name#">
		WHERE 
			UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BRANCHES_ID#"> AND
			COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="BRANCHES_NAME"> AND
			TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_APP_BRANCHES"> AND
			LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
    </cfquery>
</cfif>
<cfquery name="get_lang_det" datasource="#dsn#">
	SELECT
		ITEM,
		LANGUAGE
	FROM 
		SETUP_LANGUAGE_INFO
	WHERE
		UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BRANCHES_ID#"> AND
		COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="BRANCHES_DETAIL"> AND
		TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_APP_BRANCHES"> AND
		LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
</cfquery>
<cfif get_lang.recordcount>
	<cfquery name="upd_" datasource="#dsn#">
    	UPDATE 
			SETUP_LANGUAGE_INFO 
		SET 
			ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#branches_detail#">
		WHERE 
			UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BRANCHES_ID#"> AND
			COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="BRANCHES_DETAIL"> AND
			TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_APP_BRANCHES"> AND
			LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
    </cfquery>
</cfif>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_SETUP_APP_BRANCHES" datasource="#dsn#">
			UPDATE 
				SETUP_APP_BRANCHES 
			SET 
				BRANCHES_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#branches_name#">,
				BRANCHES_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#branches_detail#">,
				BRANCHES_STATUS = <cfif isDefined('attributes.branches_status')>1<cfelse>0</cfif>,
				BRANCHES_ROW_LINE = <cfif isDefined('attributes.branches_row_line') and len(attributes.branches_row_line)>#attributes.branches_row_line#<cfelse>NULL</cfif>,
				BRANCHES_ROW_TYPE = <cfif isDefined('attributes.branches_row_type') and len(attributes.branches_row_type)>#attributes.branches_row_type#<cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE 
				BRANCHES_ID	= #branches_id#
		</cfquery>
	</cftransaction>
</cflock>
<script>
	location.href = document.referrer;
</script>

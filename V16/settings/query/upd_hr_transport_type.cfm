<cfquery name="get_lang" datasource="#dsn#">
	SELECT
		ITEM,
		LANGUAGE
	FROM 
		SETUP_LANGUAGE_INFO
	WHERE
		UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRANSPORT_TYPE_ID#"> AND
		COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="TRANSPORT_TYPE"> AND
		TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_TRANSPORT_TYPES"> AND
		LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
</cfquery>
<cfif get_lang.recordcount>
	<cfquery name="upd_" datasource="#dsn#">
    	UPDATE 
			SETUP_LANGUAGE_INFO 
		SET 
			ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TRANSPORT_type#">
		WHERE 
			UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRANSPORT_TYPE_ID#"> AND
			COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="TRANSPORT_TYPE"> AND
			TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_TRANSPORT_TYPES"> AND
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
		UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.TRANSPORT_TYPE_ID#"> AND
		COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="TRANSPORT_TYPE_DETAIL"> AND
		TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_TRANSPORT_TYPES"> AND
		LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
</cfquery>
<cfif get_lang.recordcount>
	<cfquery name="upd_det" datasource="#dsn#">
    	UPDATE 
			SETUP_LANGUAGE_INFO 
		SET 
			ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TRANSPORT_type_detail#">
		WHERE 
			UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.TRANSPORT_TYPE_ID#"> AND
			COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="TRANSPORT_TYPE_DETAIL"> AND
			TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_TRANSPORT_TYPES"> AND
			LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
    </cfquery>
</cfif>
<cfquery name="UPD_SETUP_COMPUTER_INFO" datasource="#dsn#">
	UPDATE 
		SETUP_TRANSPORT_TYPES 
	SET 
		UPPER_TRANSPORT_TYPE_ID = <cfif isdefined("attributes.upper_transport_type_id")>#attributes.upper_transport_type_id#,<cfelse>NULL,</cfif>
		TRANSPORT_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TRANSPORT_type#">,
		TRANSPORT_TYPE_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TRANSPORT_type_detail#">,
		BRANCH_ID = <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE 
		TRANSPORT_TYPE_ID = #attributes.TRANSPORT_type_id#
</cfquery>
<script>
	location.href=document.referrer;
</script>


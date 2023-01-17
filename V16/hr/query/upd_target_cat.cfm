<cfquery name="get_lang_name" datasource="#dsn#">
	SELECT
		ITEM,
		LANGUAGE
	FROM 
		SETUP_LANGUAGE_INFO
	WHERE
		UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.targetcat_id#"> AND
		COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="TARGETCAT_NAME"> AND
		TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="TARGET_CAT"> AND
        LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
</cfquery>
<cfif get_lang_name.recordcount>
	<cfquery name="upd_" datasource="#dsn#">
    	UPDATE 
			SETUP_LANGUAGE_INFO 
		SET 
			ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.targetcat_name#"> 
		WHERE 
			UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.targetcat_id#"> AND 	
			COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="TARGETCAT_NAME"> AND
			TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="TARGET_CAT"> AND
			LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
    </cfquery>
</cfif>
<cfquery name="get_lang_detail" datasource="#dsn#">
	SELECT
		ITEM,
		LANGUAGE
	FROM 
		SETUP_LANGUAGE_INFO
	WHERE
		UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.targetcat_id#"> AND
		COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="DETAIL"> AND
		TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="TARGET_CAT"> AND
		LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
</cfquery>
<cfif get_lang_detail.recordcount>
	<cfquery name="upd_" datasource="#dsn#">
    	UPDATE 
			SETUP_LANGUAGE_INFO 
		SET 
			ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.targetcat_detail#"> 
		WHERE 
			UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.targetcat_id#"> AND
			COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="DETAIL"> AND
			TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="TARGET_CAT"> AND
			LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
    </cfquery>
</cfif>
<cflock name="CreateUUID()" timeout="30">
	<cftransaction>
		<cfquery name="UPD_TARGET_CAT" datasource="#DSN#">
			UPDATE 
				TARGET_CAT 
			SET 
				TARGETCAT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.targetcat_name#">,
				DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.targetcat_detail#">,
				TARGETCAT_WEIGHT = <cfif isdefined("attributes.targetcat_weight") and len(attributes.targetcat_weight)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.targetcat_weight#"><cfelse>NULL</cfif>,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                IS_ACTIVE =  <cfif isdefined("attributes.is_active")><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>
			WHERE 
				TARGETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.targetcat_id#">
		</cfquery>
		
		<cf_relation_segment
			is_upd='1' 
			is_form='0'
			field_id='#attributes.targetcat_id#'
			table_name='TARGET_CAT'
			action_table_name='RELATION_SEGMENT'
			select_list='1,2,3,4,5,6,7,8'>
	</cftransaction>
</cflock>
<script>
    window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_target_cat&event=upd&targetcat_id=#attributes.targetcat_id#</cfoutput>';
</script>

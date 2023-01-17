<cfquery name="UpdateResult" datasource="#dsn#">
	UPDATE
    	SETUP_VISIT_RESULT
    SET
    	VISIT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.visit_type#">,
        VISIT_RESULT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.visit_result#">,
        VISIT_RESULT_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.visit_result_detail#">,
        IS_ACTIVE = <cfif isdefined("attributes.is_active")><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_active#"><cfelse>0</cfif>
    WHERE
    	VISIT_RESULT_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.visit_result_id#">
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_upd_visit_result&result_id=#attributes.visit_result_id#" addtoken="no">

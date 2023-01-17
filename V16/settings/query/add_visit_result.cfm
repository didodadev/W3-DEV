<cfquery datasource="#dsn#" name="InsertVisitResult" result="ResultSet">
	INSERT INTO SETUP_VISIT_RESULT
    (
    	VISIT_TYPE_ID,
        VISIT_RESULT,
        VISIT_RESULT_DETAIL,
        IS_ACTIVE
    )
    VALUES
    (
    	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.visit_type#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.visit_result#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.visit_result_detail#">,
        1
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_upd_visit_result&result_id=#ResultSet.generatedkey#" addtoken="no">

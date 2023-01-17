<cfquery name="PROD_PAUSE_CAT" datasource="#DSN3#">
	INSERT INTO 
		SETUP_PROD_PAUSE_CAT
    (
        PROD_PAUSE_CAT,
        IS_ACTIVE,
        IS_WORKING_TIME,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    ) 
	VALUES 
    (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#pauseCat#">,
        <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.is_working_time")>1<cfelse>0</cfif>,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        #now()#,
        #session.ep.userid#
    )
</cfquery>

<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=settings.form_add_prod_pause_cat</cfoutput>";
</script>

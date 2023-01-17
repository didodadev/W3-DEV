<cfquery name="upd_prod_pause_cat" datasource="#DSN3#">
	UPDATE 
		SETUP_PROD_PAUSE_CAT 
	SET 
		PROD_PAUSE_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pauseCat#">,
		IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
		IS_WORKING_TIME = <cfif isdefined("attributes.is_working_time")>1<cfelse>0</cfif>,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE 
		PROD_PAUSE_CAT_ID = #attributes.prodPauseCat_id#
</cfquery>

<script>
	location.href=document.referrer;
</script>

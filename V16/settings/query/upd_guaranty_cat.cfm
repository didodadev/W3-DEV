<cfif isDefined("FORM.CURRENCY")>
	<cfif CURRENCY EQ "ON">
		<cfset FORM.CURRENCY = 1>
	</cfif>
<cfelse>
	<cfset FORM.CURRENCY = 0>
</cfif>

<cfquery name="UPD_GUARANTY_CAT" datasource="#DSN#">
	UPDATE 
 		SETUP_GUARANTY 
	SET
		GUARANTYCAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.guarantycat#">,
        GUARANTYCAT_TIME = <cfif isdefined('attributes.guarantycat_time_') and len(attributes.guarantycat_time_)>#attributes.guarantycat_time_#<cfelse>NULL</cfif>,
		MAX_GUARANTYCAT_TIME = <cfif len(max_guaranty_time_)>#max_guaranty_time_#<cfelse>NULL</cfif>,
		DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DETAIL#">,
		CURRENCY = #CURRENCY#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE 
		GUARANTYCAT_ID = #attributes.guarantycat_id#
</cfquery>
<script>
	location.href = document.referrer;
</script>

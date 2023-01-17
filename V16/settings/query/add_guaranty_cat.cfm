<cfif isDefined("FORM.CURRENCY")>
	<cfif CURRENCY EQ "ON">
		<cfset FORM.CURRENCY = 1>
	</cfif>
<cfelse>
	<cfset FORM.CURRENCY = 0>
</cfif>

<cfquery name="SETUP_GUARANTY" datasource="#DSN#">
	INSERT INTO 
		SETUP_GUARANTY
    (
        GUARANTYCAT,
        GUARANTYCAT_TIME,
        <cfif LEN(max_guaranty_time_)>MAX_GUARANTYCAT_TIME,</cfif>
        DETAIL,
        CURRENCY,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    )
	VALUES
    (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.GUARANTYCAT#">,
        <cfif isdefined('attributes.guarantycat_time_') and len(attributes.guarantycat_time_)>#attributes.guarantycat_time_#<cfelse>NULL</cfif>,
        <cfif len(max_guaranty_time_)>#max_guaranty_time_#,</cfif>
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.DETAIL#">,
        <cfif isDefined("CURRENCY")>1<cfelse>0</cfif>,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_guaranty_cat" addtoken="no">

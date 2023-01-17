<cfquery name="ADD_ASSET" datasource="#DSN#" result="MAX_ID">
	INSERT INTO
		SETUP_HEADQUARTERS
    (
        UPPER_HEADQUARTERS_ID,
        IS_ORGANIZATION,
        NAME,
        HIERARCHY,
        HEADQUARTERS_DETAIL,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    )
    VALUES
    (
        <cfif len(attributes.upper_headquarters_id) and len(attributes.upper_headquarters_name)>#attributes.upper_headquarters_id#<cfelse>NULL</cfif>,
        <cfif isdefined("attributes.is_organization")>1<cfelse>0</cfif>,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.name#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cfquery name="add_headq_history" datasource="#DSN#">
	INSERT INTO 
    	SETUP_HEADQ_HISTORY 
    SELECT 
    	HEADQUARTERS_ID, 
        NAME, 
        HIERARCHY, 
        HEADQUARTERS_DETAIL, 
        IS_ORGANIZATION, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPPER_HEADQUARTERS_ID
	FROM 
    	SETUP_HEADQUARTERS 
    WHERE 
    	HEADQUARTERS_ID = #MAX_ID.IDENTITYCOL#
</cfquery>

<cfif isdefined("attributes.hr")>
    <script type="text/javascript">
        window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_headquarters&event=upd&head_id=<cfoutput>#MAX_ID.IDENTITYCOL#</cfoutput>&hr=1';
    </script>
<cfelse>
    <script type="text/javascript">
        window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_headquarters&event=upd&head_id=<cfoutput>#MAX_ID.IDENTITYCOL#</cfoutput>';
    </script>
</cfif>


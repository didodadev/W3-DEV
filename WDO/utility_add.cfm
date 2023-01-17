<cfquery name="addUtility" datasource="#dsn#">
    INSERT INTO
        UTILITIES
    (
        UTILITY_NAME,
        DEVELOPER,
        VERSION,
        DETAIL,
        UTILITY_TYPE,
        PATH,
        RECORD_DATE
    )
    VALUES
    (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.UTILITY_NAME#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.DEVELOPER#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.VERSION#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.DETAIL#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.utility_type#">,
        <cfif IsDefined("file_name") and len(file_name)>
            '<cfif isdefined("attributes.utility_type") and attributes.utility_type eq 3>#utilityCustomTagPath#<cfelse>#utilityPath#</cfif>#file_name#'
        <cfelse>
            NULL
        </cfif>,
        #now()#
    )
</cfquery>
<script>
    window.location.href="<cfoutput>#request.self#?fuseaction=dev.utility</cfoutput>";
</script>
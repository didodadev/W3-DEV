<cfquery name="updUtility" datasource="#dsn#" result="r">
    UPDATE
        UTILITIES
    SET
        UTILITY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.UTILITY_NAME#">,
        DEVELOPER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.DEVELOPER#">,
        VERSION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.VERSION#">,
        DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.DETAIL#">,
        UPDATE_DATE = #now()#,
        UTILITY_TYPE = <cfif len(attributes.utility_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.utility_type#"><cfelse>NULL</cfif>
        <cfif IsDefined("file_name") and len(file_name)>
            ,PATH ='<cfif isdefined("attributes.utility_type") and attributes.utility_type eq 3>#utilityCustomTagPath#<cfelse>#utilityPath#</cfif>#file_name#'
        </cfif>
    WHERE
        UTILITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.utility_id#">
</cfquery>
<!--- <cfif attributes.delete eq 1>
    <cfquery name="GET_FILE" datasource="#dsn#">
        SELECT
            PATH
        FROM
            UTILITIES
        WHERE
            UTILITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.utility_id#">
    </cfquery>
    <cfquery name="delUtility" datasource="#dsn#" result="r">
        DELETE FROM UTILITIES WHERE UTILITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.utility_id#">
    </cfquery>
    <cfif len(GET_FILE.PATH)>
        <cftry>
            <cffile action="delete" file="#rootFolder#\#GET_FILE.PATH#">
        <cfcatch></cfcatch>
        </cftry>
    </cfif>
</cfif> --->
<script type="text/javascript">
    window.location.href="<cfoutput>#request.self#?fuseaction=dev.utility&event=upd&type=ut&utility_id=#attributes.utility_id#</cfoutput>"
</script>
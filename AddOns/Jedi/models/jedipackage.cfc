<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="listpackage" access="public">
        <cfargument name="head" default="">
        <cfquery name="query_packages" datasource="#dsn#">
            SELECT * FROM JEDI_PACKAGES
            WHERE USERID = #session.ep.userid#
                AND IS_ACTIVE = 1
            <cfif len(arguments.head)>
                AND HEAD LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.head#%'>
            </cfif>
        </cfquery>
        <cfreturn query_packages>
    </cffunction>

    <cffunction name="getpackage" access="public">
        <cfargument name="id" required="true">
        <cfquery name="query_package" datasource="#dsn#">
            SELECT * FROM JEDI_PACKAGES
            WHERE USERID = #session.ep.userid#
                AND IS_ACTIVE = 1
                AND PACKAGE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.id#'>
        </cfquery>
        <cfreturn query_package>
    </cffunction>

    <cffunction name="insertpackage" access="public">
        <cfargument name="head" required="true">
        <cfargument name="path" required="true">
        <cfargument name="is_active" default="1">
        <cfquery name="query_insert" datasource="#dsn#">
            INSERT INTO JEDI_PACKAGES( USERID, HEAD, [PATH], IS_ACTIVE, RECORD_DATE, RECORD_IP )
            VALUES (
                #session.ep.userid#,
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.head#'>,
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.path#'>,
                <cfqueryparam cfsqltype='CF_SQL_BIT' value="#arguments.is_active#">,
                #now()#,
                '#cgi.REMOTE_HOST#'
            )
        </cfquery>
    </cffunction>

    <cffunction name="updatepackage" access="public">
        <cfargument name="id" required="true">
        <cfargument name="head" required="true">
        <cfargument name="is_active" default="1">
        <cfquery name="updatepackage" datasource="#dsn#">
            UPDATE JEDI_PACKAGES SET
            HEAD = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.head#'>,
            IS_ACTIVE = <cfqueryparam cfsqltype='CF_SQL_BIT' value='#arguments.is_active#'>
            WHERE PACKAGE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.id#'>
            AND USERID = #session.ep.userid#
        </cfquery>
    </cffunction>

    <cffunction name="deletepackage" access="public">
        <cfargument name="id" required="true">
        <cfquery name="query_delete" datasource="#dsn#">
            UPDATE JEDI_PACKAGES SET
            IS_ACTIVE = 0
            WHERE PACKAGE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.id#'>
            AND USERID = #session.ep.userid#
        </cfquery>
    </cffunction>

</cfcomponent>
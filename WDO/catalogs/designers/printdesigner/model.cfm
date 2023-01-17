<cffunction name="listPrint">
    <cfargument name="PRINT_HEAD" default="">
    <cfargument name="PRINT_FUSEACTION" default="">
    <cfargument name="PRINT_SYSNAME" default="">
    <cfargument name="PRINT_SOLUTIONID" default="">
    <cfargument name="PRINT_FAMILYID" default="">
    <cfargument name="PRINT_MODULEID" default="">

    <cfquery name="common_query" datasource="#dsn#">
        SELECT * FROM WRK_PRINTOUTPUT
        WHERE 1=1
        <cfif len(arguments.PRINT_HEAD)>
            AND (
            PRINT_HEAD LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.PRINT_HEAD#%'>
            OR PRINT_FUSEACTION LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.PRINT_FUSEACTION#%'>
            OR PRINT_SYSNAME LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.PRINT_SYSNAME#%'>
            )
        </cfif>
        <cfif len(arguments.PRINT_SOLUTIONID)>
            AND PRINT_SOLUTIONID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PRINT_SOLUTIONID#'>
        </cfif>
        <cfif len(arguments.PRINT_FAMILYID)>
            AND PRINT_FAMILYID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PRINT_FAMILYID#'>
        </cfif>
        <cfif len(arguments.PRINT_MODULEID)>
            AND PRINT_MODULEID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PRINT_MODULEID#'>
        </cfif>
    </cfquery>
    
    <cfreturn common_query>
</cffunction>

<cffunction name="getPrint">
    <cfargument name="PRINTID" type="numeric">

    <cfquery name="common_query" datasource="#dsn#">
        SELECT * FROM WRK_PRINTOUTPUT WHERE PRINTID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PRINTID#'>
    </cfquery>

    <cfreturn common_query>
</cffunction>

<cffunction name="insertPrint">
    <cfargument name="PRINT_HEAD" type="string">
    <cfargument name="PRINT_FUSEACTION" type="string">
    <cfargument name="PRINT_SYSNAME" type="string">
    <cfargument name="PRINT_MODELJSON">
    <cfargument name="PRINT_CODE">
    <cfargument name="PRINT_SOLUTION" type="string">
    <cfargument name="PRINT_SOLUTIONID" type="numeric">
    <cfargument name="PRINT_FAMILY" type="string">
    <cfargument name="PRINT_FAMILYID" type="string">
    <cfargument name="PRINT_MODULE" type="string">
    <cfargument name="PRINT_MODULEID" type="numeric">
    <cfargument name="STATUS" type="numeric">
    <cfargument name="PRINT_DESCRIPTION">

    <cfquery name="common_query" datasource="#dsn#" result="common_result">
        INSERT INTO WRK_PRINTOUTPUT
        (
            PRINT_HEAD, PRINT_FUSEACTION, PRINT_SYSNAME, PRINT_MODELJSON, PRINT_CODE, PRINT_SOLUTION, PRINT_SOLUTIONID, PRINT_FAMILY, PRINT_FAMILYID, PRINT_MODULE, PRINT_MODULEID, RECORD_IP, RECORD_EMP, RECORD_DATE, [STATUS], PRINT_DESCRIPTION
        )
        VALUES
        (
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PRINT_HEAD#'>
            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PRINT_FUSEACTION#'>
            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PRINT_SYSNAME#'>
            <cfif isDefined( "arguments.PRINT_MODELJSON" )>
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PRINT_MODELJSON#'>
            <cfelse>
                ,NULL
            </cfif>
            <cfif isDefined( "arguments.PRINT_CODE" )>
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PRINT_CODE#'>
            <cfelse>
                ,NULL
            </cfif>
            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PRINT_SOLUTION#'>
            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PRINT_SOLUTIONID#'>
            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PRINT_FAMILY#'>
            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PRINT_FAMILYID#'>
            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PRINT_MODULE#'>
            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PRINT_MODULEID#'>
            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#cgi.remote_addr#'>
            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#session.ep.userid#'>
            ,#now()#
            ,<cfqueryparam cfsqltype='CF_SQL_BIT' value='#arguments.STATUS#'>
            <cfif isDefined( "attributes.PRINT_DESCRIPTION" ) and len( attributes.PRINT_DESCRIPTION )>
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.PRINT_DESCRIPTION#'>
            <cfelse>
                ,NULL
            </cfif>
        )
    </cfquery>
    <cfreturn common_result["GENERATEDKEY"]>
</cffunction>

<cffunction name="updatePrint">
    <cfargument name="PRINTID" type="numeric">
    <cfargument name="PRINT_HEAD" type="string">
    <cfargument name="PRINT_FUSEACTION" type="string">
    <cfargument name="PRINT_SYSNAME" type="string">
    <cfargument name="PRINT_MODELJSON">
    <cfargument name="PRINT_CODE">
    <cfargument name="PRINT_SOLUTION" type="string">
    <cfargument name="PRINT_SOLUTIONID" type="numeric">
    <cfargument name="PRINT_FAMILY" type="string">
    <cfargument name="PRINT_FAMILYID" type="string">
    <cfargument name="PRINT_MODULE" type="string">
    <cfargument name="PRINT_MODULEID" type="numeric">
    <cfargument name="STATUS" type="numeric">
    <cfargument name="PRINT_DESCRIPTION">

    <cfquery name="common_query" datasource="#dsn#">
        UPDATE WRK_PRINTOUTPUT SET
        PRINT_HEAD = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PRINT_HEAD#'>
        ,PRINT_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PRINT_FUSEACTION#'>
        ,PRINT_SYSNAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PRINT_SYSNAME#'>
        <cfif isDefined("arguments.PRINT_MODELJSON")>
        ,PRINT_MODELJSON = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PRINT_MODELJSON#'>
        </cfif>
        <cfif isDefined("arguments.PRINT_CODE")>
        ,PRINT_CODE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PRINT_CODE#'>
        </cfif>
        ,PRINT_SOLUTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PRINT_SOLUTION#'>
        ,PRINT_SOLUTIONID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PRINT_SOLUTIONID#'>
        ,PRINT_FAMILY = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PRINT_FAMILY#'>
        ,PRINT_FAMILYID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PRINT_FAMILYID#'>
        ,PRINT_MODULE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PRINT_MODULE#'>
        ,PRINT_MODULEID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PRINT_MODULEID#'>
        ,UPDATE_IP = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#cgi.REMOTE_ADDR#'>
        ,UPDATE_EMP = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#session.ep.userid#'>
        ,UPDATE_DATE = #now()#
        ,[STATUS] = <cfqueryparam cfsqltype='CF_SQL_BIT' value='#arguments.STATUS#'>
        <cfif isDefined("arguments.PRINT_DESCRIPTION")>
        ,PRINT_DESCRIPTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PRINT_DESCRIPTION#'>
        </cfif>
        WHERE
        PRINTID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PRINTID#'>
    </cfquery>
</cffunction>

<cffunction name="deletePrint">
    <cfargument name="PRINTID" type="numeric">

    <cfquery name="common_query" datasource="#dsn#">
        DELETE FROM WRK_PRINTOUTPUT WHERE PRINTID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PRINTID#'>
    </cfquery>
</cffunction>

<cffunction name="loadModel" access="public" returntype="any">
    <cfargument name="fuseact" type="string">
    <cfquery name="modelquery" result="modelresult" datasource="#dsn#">
        SELECT MODELJSON FROM WRK_MODEL WHERE MODEL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.fuseact#">
    </cfquery>
    <cfif modelresult.recordcount>
        <cfreturn modelquery.MODELJSON>
    </cfif>
</cffunction>
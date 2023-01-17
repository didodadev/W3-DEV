<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3="#dsn#_#session.ep.company_id#">
    <cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn1="#dsn#_product">

    <cffunction name="get_cutstretch" access="public">
        <cfargument name="cutactual_id">
        <cfargument name="marker_name">
        <cfquery name="query_get_cutstretch" datasource="#dsn3#">
            SELECT *, PRO_PROJECTS.PROJECT_HEAD FROM TEXTILE_CUTSTRETCH_HEAD
            LEFT JOIN #dsn#.PRO_PROJECTS ON TEXTILE_CUTSTRETCH_HEAD.PROJECT_ID = PRO_PROJECTS.PROJECT_ID
            WHERE MARKER_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.marker_name#'>
            AND CUTACTUAL_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.cutactual_id#'>
        </cfquery>
        <cfreturn query_get_cutstretch>
    </cffunction>

    <cffunction name="add_cutstretch" access="public">
        <cfargument name="cutactual_id">
        <cfargument name="project_id">
        <cfargument name="marker_name">
        <cfargument name="marker_height">
        <cfargument name="stretching_test_id">
        <cfquery name="query_add_cutstretch" datasource="#dsn3#" result="result_add_cutstretch">
            INSERT INTO TEXTILE_CUTSTRETCH_HEAD (
                CUTACTUAL_ID, PROJECT_ID, MARKER_NAME, MARKER_HEIGHT, STRETCHING_TEST_ID, RECORD_DATE, RECORD_EMP, RECORD_IP
            ) VALUES (
                <cfif isdefined("arguments.cutactual_id") and len(arguments.cutactual_id)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.cutactual_id#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
                </cfif>
                ,<cfif isdefined("arguments.project_id") and len(arguments.project_id)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.project_id#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
                </cfif>
                ,<cfif isdefined("arguments.marker_name") and len(arguments.marker_name)>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.marker_name#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null="true">
                </cfif>
                ,<cfif isdefined("arguments.marker_height") and len(arguments.marker_height)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.marker_height#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
                </cfif>
                ,<cfif isdefined("arguments.stretching_test_id") and len(arguments.stretching_test_id)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stretching_test_id#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
                </cfif>
                ,#now()#
                ,#session.ep.userid#
                ,'#cgi.REMOTE_ADDR#'
            )
        </cfquery>
        <cfreturn result_add_cutstretch>
    </cffunction>

    <cffunction name="get_cutstretch_row">
        <cfargument name="cutstretch_id">
        <cfquery name="query_get_cutstretch_row" datasource="#dsn3#">
            SELECT * FROM TEXTILE_CUTSTRETCH_ROW WHERE CUTSTRETCH_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.cutstretch_id#'>
        </cfquery>
        <cfreturn query_get_cutstretch_row>
    </cffunction>

    <cffunction name="add_cutstretch_row">
        <cfargument name="cutstretch_id">
        <cfargument name="roll_no">
        <cfargument name="color">
        <cfargument name="marker">
        <cfargument name="stretch_amount1">
        <cfargument name="stretch_amount2">
        <cfargument name="undemand_spill_meter">
        <cfargument name="flaw_meter">
        <cfargument name="additional_meter">
        <cfargument name="classification_meter">
        <cfargument name="missing_roll">
        <cfargument name="waybill_meter">
        <cfargument name="stretch_meter">
        <cfquery name="query_add_cutstretch_row" datasource="#dsn3#">
            INSERT INTO TEXTILE_CUTSTRETCH_ROW (
                CUTSTRETCH_ID, ROLL_NO, COLOR, MARKER, STRETCH_AMOUNT1, STRETCH_AMOUNT2, UNDEMAND_SPILL_METER, FLAW_METER, ADDITIONAL_METER, CLASSIFICATION_METER, MISSING_ROLL, WAYBILL_METER, STRETCH_METER, RECORD_DATE, RECORD_EMP, RECORD_IP
            ) VALUES (
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.cutstretch_id#'>
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.roll_no#'>
                ,<cfif isdefined("arguments.color") and len(arguments.color)>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.color#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null="true">
                </cfif>
                ,<cfif isdefined("arguments.marker") and len(arguments.marker)>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.marker#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null="true">
                </cfif>
                ,<cfif isDefined('arguments.stretch_amount1') and len(arguments.stretch_amount1)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stretch_amount1#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null='true'>
                </cfif>
                ,<cfif isDefined('arguments.stretch_amount2') and len(arguments.stretch_amount2)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stretch_amount2#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null='true'>
                </cfif>
                ,<cfif isDefined('arguments.undemand_spill_meter') and len(arguments.undemand_spill_meter)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.undemand_spill_meter#' scale="2">
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null='true'>
                </cfif>
                ,<cfif isDefined('arguments.flaw_meter') and len(arguments.flaw_meter)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.flaw_meter#' scale="2">
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null='true'>
                </cfif>
                ,<cfif isDefined('arguments.additional_meter') and len(arguments.additional_meter)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.additional_meter#' scale="2">
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null='true'>
                </cfif>
                ,<cfif isDefined('arguments.classification_meter') and len(arguments.classification_meter)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.classification_meter#' scale="2">
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null='true'>
                </cfif>
                ,<cfif isDefined('arguments.missing_roll') and len(arguments.missing_roll)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.missing_roll#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null='true'>
                </cfif>
                ,<cfif isDefined('arguments.waybill_meter') and len(arguments.waybill_meter)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.waybill_meter#' scale="2">
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null='true'>
                </cfif>
                ,<cfif isDefined('arguments.stretch_meter') and len(arguments.stretch_meter)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.stretch_meter#' scale="2">
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null='true'>
                </cfif>
                ,#now()#
                ,#session.ep.userid#
                ,'#cgi.REMOTE_ADDR#'
            )
        </cfquery>
    </cffunction>

    <cffunction name="delete_cutstretch_row" access="public">
        <cfargument name="cutstretch_id">
        <cfquery name="query_delete_cutstretch_row" datasource="#dsn3#">
            DELETE FROM TEXTILE_CUTSTRETCH_ROW WHERE CUTSTRETCH_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.cutstretch_id#'>
        </cfquery>
    </cffunction>

</cfcomponent>
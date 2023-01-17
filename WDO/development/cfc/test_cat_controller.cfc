<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
        <cffunction  name="getCategoryList">
             <cfquery name="categoryListQuery" datasource="#dsn#">
                SELECT
                ID,
                #dsn#.Get_Dynamic_Language(ID,'#session.ep.language#','TEST_CAT','CATEGORY_NAME',NULL,NULL,CATEGORY_NAME) AS CATEGORY_NAME,
                CATEGORY_DETAIL
                FROM TEST_CAT 
             </cfquery>
         <cfreturn categoryListQuery >
        </cffunction>

        <cffunction name="getSubjectForCategory" returnType="any" >
            <cfargument name="categoryID">
            <cfquery name="subjectForCategory" datasource="#dsn#">
                SELECT   
                SUBJECT.SUBJECT
                ,CATEGORY.CATEGORY_NAME
                ,CATEGORY.ID AS CAT_ID
                ,SUBJECT.CATEGORY_ID AS SUBCATID
                ,SUBJECT.SUBJECT_ID AS SUBJECT_ID
                FROM TEST_SUBJECT AS SUBJECT
            
                INNER JOIN TEST_CAT AS CATEGORY  ON SUBJECT.CATEGORY_ID = CATEGORY.ID
                WHERE  SUBJECT.CATEGORY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.categoryID#">
            </cfquery>
             <cfreturn subjectForCategory >
        </cffunction>

        <cffunction name="getCheckMain" returntype="query">
            <cfargument name="module">
            <cfargument name="family">
            <cfargument name="solution">
            <cfargument name="fuseaction">
            <cfargument name="tester">
            <cfquery name="query_checkmain" datasource="#dsn#">
                SELECT * FROM TEST_CHECK_MAIN
                LEFT OUTER JOIN WRK_OBJECTS ON TEST_CHECK_MAIN.FUSEACTION = WRK_OBJECTS.FULL_FUSEACTION
                LEFT OUTER JOIN WRK_MODULE ON WRK_MODULE.MODULE_NO = WRK_OBJECTS.MODULE_NO
                LEFT OUTER JOIN WRK_FAMILY ON WRK_FAMILY.WRK_FAMILY_ID = WRK_MODULE.FAMILY_ID
                WHERE 1=1
                <cfif isDefined("arguments.module")>
                AND WRK_OBJECTS.MODULE_NO = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.module#'>
                </cfif>
                <cfif isDefined("arguments.family")>
                AND WRK_MODULE.FAMILY_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.family#'>
                </cfif>
                <cfif isDefined("arguments.solution")>
                AND WRK_FAMILY.WRK_SOLUTION_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.solution#'>
                </cfif>
                <cfif isDefined("arguments.fuseaction")>
                AND TEST_CHECK_MAIN.FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'>
                </cfif>
                <cfif isDefined("arguments.tester") and len(arguments.tester)>
                AND TEST_CHECK_MAIN.TEST_USERID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.tester#'>
                </cfif>
                ORDER BY CHECH_ID DESC
            </cfquery>
            <cfreturn query_checkmain>
        </cffunction>

        <cffunction name="saveCheckMain" returntype="numeric">
            <cfargument name="fuseaction" type="string">
            <cfargument name="domain" type="string">
            <cfargument name="version" type="string">
            <cfargument name="event" type="string">
            <cfargument name="test_user" type="string">
            <cfargument name="test_userid" type="string">
            <cfargument name="test_date" type="date">
            <cfargument name="general_point" type="numeric">
            <cfquery name="query_checkmain" result="result_checkmain" datasource="#dsn#">
                INSERT INTO TEST_CHECK_MAIN(
                    MODUL_SHORT_NAME, FUSEACTION, DOMAIN, VERSION, EVENT, TEST_USER, TEST_USERID, TEST_DATE, GENERAL_POINT,
                    RECORD_DATE, RECORD_EMP, RECORD_ID
                )
                SELECT MODUL_SHORT_NAME, 
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'>,
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.domain#'>,
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.version#'>,
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.event#'>,
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.test_user#'>,
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.test_userid#'>,
                <cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.test_date#'>,
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.general_point#'>,
                #now()#,
                #session.ep.userid#,
                '#cgi.REMOTE_ADDR#'
                FROM WRK_OBJECTS WHERE FULL_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'>
            </cfquery>
            <cfreturn result_checkmain.IDENTITYCOL>
        </cffunction>

        <cffunction name="saveCheckRow">
            <cfargument name="checkid" type="numeric">
            <cfargument name="subjectid" type="numeric">
            <cfargument name="detail" type="string">
            <cfargument name="status" type="numeric" default="0">
            <cfargument name="success" type="numeric">
            <cfquery name="query_checkrow" datasource="#dsn#">
                INSERT INTO TEST_CHECK_ROW(CHECK_ID, SUBJECT_ID, STATUS, DETAIL, SUCCESS)
                VALUES (
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.checkid#'>,
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.subjectid#'>,
                    <cfqueryparam cfsqltype='CF_SQL_BIT' value='#arguments.status#'>,
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.detail#' null="#iif(isDefined('arguments.detail') and len(arguments.detail), de('no'), de('yes'))#">,
                    <cfqueryparam cfsqltype='CF_SQL_BIT' value='#arguments.success#'>
                )
            </cfquery>
        </cffunction>

        <cffunction name="getTestHead">
            <cfargument name="testid">
            <cfquery name="query_testhead" datasource="#dsn#">
                SELECT TEST_CHECK_MAIN.*, TEST_CAT.CATEGORY_NAME FROM TEST_CHECK_MAIN, TEST_CAT WHERE CHECH_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.testid#'>
            </cfquery>
            <cfreturn query_testhead>
        </cffunction>

        <cffunction name="getTestRows">
            <cfargument name="testid">
            <cfquery name="query_testrows" datasource="#dsn#">
                SELECT TEST_CHECK_ROW.*, TEST_SUBJECT.SUBJECT FROM TEST_CHECK_ROW INNER JOIN TEST_SUBJECT ON TEST_CHECK_ROW.SUBJECT_ID = TEST_SUBJECT.SUBJECT_ID AND TEST_CHECK_ROW.CHECK_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.testid#'>
            </cfquery>
            <cfreturn query_testrows>
        </cffunction>
</cfcomponent>

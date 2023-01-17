<cfcomponent extends="WDO.catalogs.dataComponent">

<cfset dsn = application.systemParam.systemParam().dsn>

<cffunction name="mandate_add" access="public" returntype="any">
    <cfargument name="process_stage" type="numeric" required="yes">
    <cfargument name="employee_id" type="numeric" required="yes">
    <cfargument name="mandate_id" type="numeric" required="yes">
    <cfargument name="detail" type="any" required="no">
    <cfargument name="startdate" type="date" required="no">
    <cfargument name="finishdate" type="date" required="no">

    <cfquery name="EMPLOYEE_MANDATE_query" datasource="#DSN#" result="EMPLOYEE_MANDATE_query_result">
    INSERT INTO #dsn#.EMPLOYEE_MANDATE(WRK_PROCESS_ID, MASTER_EMPLOYEE_ID, MANDATE_EMPLOYEE_ID,MANDATE_DETAIL, MANDATE_STARTDATE, MANDATE_FINISHDATE, IS_ACTIVE, RECORD_DATE<cfif isDefined("this.EMP")>, RECORD_EMP</cfif>, RECORD_IP) VALUES(<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#replace(arguments.process_stage, ",", ".")#" null="no" >, <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#replace(arguments.employee_id, ",", ".")#" null="no" >, <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#replace(arguments.mandate_id, ",", ".")#" null="no" >, <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.detail#" null="#iif( len( arguments.detail ), de( 'no' ), de( 'yes' ) )#" >, <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.startdate#" null="#iif( len( arguments.startdate ), de( 'no' ), de( 'yes' ) )#" >, <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.finishdate#" null="#iif( len( arguments.finishdate ), de( 'no' ), de( 'yes' ) )#" >, 1 ,<cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#this.DATE#>"><cfif isDefined("this.EMP")>, <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#this.EMP#"></cfif>, <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#cgi.REMOTE_ADDR#">)
    </cfquery>
    <cfset result = EMPLOYEE_MANDATE_query_result.generatedkey>

<cfreturn result>
</cffunction>

<cffunction name="mandate_list" access="public" returntype="any">
    <cfargument name="employee_id" type="any">
    <cfargument name="employee_name" type="any">
    <cfargument name="mandate_id" type="any">
    <cfargument name="mandate_name" type="any">
    <cfargument name="startdate" type="any">
    <cfargument name="finishdate" type="any">
    <cfargument name="keywordids">
    <cfquery name="commonquery" datasource="#DSN#">
        SELECT dt1.WRK_PROCESS_ID AS process_stage, dt1.MANDATE_MASTER_ID AS id, dt1.MASTER_EMPLOYEE_ID AS employee_id, dt2.EMPLOYEE_SURNAME AS employee_surname, CONCAT(dt2.EMPLOYEE_NAME, ' ', dt2.EMPLOYEE_SURNAME) AS employee_name, dt1.MANDATE_EMPLOYEE_ID AS mandate_id, dt3.EMPLOYEE_SURNAME AS mandate_surname, CONCAT(dt3.EMPLOYEE_NAME, ' ', dt3.EMPLOYEE_SURNAME) AS mandate_name, dt1.MANDATE_STARTDATE AS startdate, dt1.MANDATE_FINISHDATE AS finishdate, dt4.STAGE AS process_stage_title FROM #dsn#.PROCESS_TYPE_ROWS dt4, #dsn#.EMPLOYEES dt3, #dsn#.EMPLOYEES dt2, #dsn#.EMPLOYEE_MANDATE dt1  WHERE (
        <cfif isDefined("arguments.employee_name") and len(arguments.employee_name) and isDefined("arguments.employee_id") and len(arguments.employee_id)>
            dt1.MASTER_EMPLOYEE_ID  = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.employee_id#">
        <cfelse> 1=1 </cfif> AND 
        <cfif isDefined("arguments.mandate_name") and len(arguments.mandate_name) and isDefined("arguments.mandate_id") and len(arguments.mandate_id)>
            dt1.MANDATE_EMPLOYEE_ID  = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.mandate_id#">
        <cfelse> 1=1 </cfif> AND
        <cfif isDefined("arguments.STARTDATE") and len(arguments.STARTDATE) or isDefined("arguments.FINISHDATE") and len(arguments.FINISHDATE)>
            <cfif len(arguments.STARTDATE) AND len(arguments.FINISHDATE)>
                <!--- IKI TARIH DE VAR --->
                
                (
                    (
                    dt1.MANDATE_STARTDATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.STARTDATE#"> AND
                    dt1.MANDATE_STARTDATE < <cfqueryparam cfsqltype="cf_sql_date" value="#DATEADD("d",1,arguments.FINISHDATE)#">
                    )
                OR
                    (
                    dt1.MANDATE_STARTDATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.STARTDATE#"> AND
                    dt1.MANDATE_FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.STARTDATE#">
                    )
                )
            <cfelseif len(arguments.STARTDATE)>
                <!--- SADECE BAŞLANGIÇ --->               
                (
                dt1.MANDATE_STARTDATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.STARTDATE#">
                OR
                    (
                    dt1.MANDATE_STARTDATE > <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.STARTDATE#"> AND
                    dt1.MANDATE_FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.STARTDATE#">
                    )
                )
            <cfelseif len(arguments.FINISHDATE)>
                <!--- SADECE BITIŞ --->                
                (
                dt1.MANDATE_FINISHDATE < <cfqueryparam cfsqltype="cf_sql_date" value="#DATEADD("d",1,arguments.FINISHDATE)#">
                OR
                    (
                    dt1.MANDATE_STARTDATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#DATEADD("d",1,arguments.FINISHDATE)#"> AND
                    dt1.MANDATE_FINISHDATE > <cfqueryparam cfsqltype="cf_sql_date" value="#DATEADD("d",1,arguments.FINISHDATE)#">
                    )
                )
            </cfif>
        <cfelse>
            1=1
	    </cfif> AND 
        <cfif isDefined("arguments.keywordids")>
            dt1.MANDATE_MASTER_ID IN (#arguments.keywordids#)
        <cfelse> 1=1 </cfif>
        )   AND  ( dt1.MASTER_EMPLOYEE_ID =  dt2.EMPLOYEE_ID AND dt1.MANDATE_EMPLOYEE_ID =  dt3.EMPLOYEE_ID AND dt1.WRK_PROCESS_ID =  dt4.PROCESS_ROW_ID)
        GROUP BY dt1.WRK_PROCESS_ID,dt1.MANDATE_MASTER_ID,dt1.MASTER_EMPLOYEE_ID,dt2.EMPLOYEE_SURNAME,dt2.EMPLOYEE_NAME,dt1.MANDATE_EMPLOYEE_ID,dt3.EMPLOYEE_SURNAME,dt3.EMPLOYEE_NAME,dt1.MANDATE_STARTDATE,dt1.MANDATE_FINISHDATE,dt4.STAGE
        
    </cfquery>
    <cfreturn commonquery>
    </cffunction>

<cffunction name="mandate_get" access="public" returntype="any">
    <cfargument name="id" type="numeric" required="yes">



    <cfquery name="commonquery" datasource="#DSN#">
    SELECT dt1.WRK_PROCESS_ID AS process_stage, dt1.MANDATE_MASTER_ID AS id, dt1.MASTER_EMPLOYEE_ID AS employee_id, dt2.EMPLOYEE_SURNAME AS employee_surname, CONCAT(dt2.EMPLOYEE_NAME, ' ', dt2.EMPLOYEE_SURNAME) AS employee_name, dt1.MANDATE_EMPLOYEE_ID AS mandate_id, dt3.EMPLOYEE_SURNAME AS mandate_surname, CONCAT(dt3.EMPLOYEE_NAME, ' ', dt3.EMPLOYEE_SURNAME) AS mandate_name, dt1.MANDATE_DETAIL AS detail, dt1.MANDATE_STARTDATE AS startdate, dt1.MANDATE_FINISHDATE AS finishdate,dt1.RECORD_EMP,dt1.RECORD_DATE,dt1.RECORD_IP, dt1.UPDATE_EMP, dt1.UPDATE_DATE,dt1.UPDATE_IP FROM #dsn#.EMPLOYEES dt3, #dsn#.EMPLOYEES dt2, #dsn#.EMPLOYEE_MANDATE dt1  WHERE (dt1.MANDATE_MASTER_ID  = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.id#" null="no">)   AND  ( dt1.MASTER_EMPLOYEE_ID =  dt2.EMPLOYEE_ID AND dt1.MANDATE_EMPLOYEE_ID =  dt3.EMPLOYEE_ID)
    </cfquery>
    <cfreturn commonquery>
</cffunction>

<cffunction name="mandate_update" access="public" returntype="any">
    <cfargument name="process_stage" type="numeric" required="yes">
    <cfargument name="id" type="any" required="yes">
    <cfargument name="employee_id" type="numeric" required="yes">
    <cfargument name="mandate_id" type="numeric" required="yes">
    <cfargument name="detail" type="any" required="no">
    <cfargument name="startdate" type="date" required="no">
    <cfargument name="finishdate" type="date" required="no">



    <cfquery name="EMPLOYEE_MANDATE_query" datasource="#DSN#">
    UPDATE #dsn#.EMPLOYEE_MANDATE SET <cfif len( arguments.process_stage )>#dsn#.EMPLOYEE_MANDATE.WRK_PROCESS_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#replace(arguments.process_stage, ",", ".")#" ><cfelse>#dsn#.EMPLOYEE_MANDATE.WRK_PROCESS_ID = #dsn#.EMPLOYEE_MANDATE.WRK_PROCESS_ID</cfif>
, <cfif len( arguments.employee_id )>#dsn#.EMPLOYEE_MANDATE.MASTER_EMPLOYEE_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#replace(arguments.employee_id, ",", ".")#" ><cfelse>#dsn#.EMPLOYEE_MANDATE.MASTER_EMPLOYEE_ID = #dsn#.EMPLOYEE_MANDATE.MASTER_EMPLOYEE_ID</cfif>
, <cfif len( arguments.mandate_id )>#dsn#.EMPLOYEE_MANDATE.MANDATE_EMPLOYEE_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#replace(arguments.mandate_id, ",", ".")#" ><cfelse>#dsn#.EMPLOYEE_MANDATE.MANDATE_EMPLOYEE_ID = #dsn#.EMPLOYEE_MANDATE.MANDATE_EMPLOYEE_ID</cfif>
, <cfif len( arguments.detail )>#dsn#.EMPLOYEE_MANDATE.MANDATE_DETAIL = <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.detail#" ><cfelse>#dsn#.EMPLOYEE_MANDATE.MANDATE_DETAIL = #dsn#.EMPLOYEE_MANDATE.MANDATE_DETAIL</cfif>
, <cfif len( arguments.startdate )>#dsn#.EMPLOYEE_MANDATE.MANDATE_STARTDATE = <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.startdate#" ><cfelse>#dsn#.EMPLOYEE_MANDATE.MANDATE_STARTDATE = #dsn#.EMPLOYEE_MANDATE.MANDATE_STARTDATE</cfif>
, <cfif len( arguments.finishdate )>#dsn#.EMPLOYEE_MANDATE.MANDATE_FINISHDATE = <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.finishdate#" ><cfelse>#dsn#.EMPLOYEE_MANDATE.MANDATE_FINISHDATE = #dsn#.EMPLOYEE_MANDATE.MANDATE_FINISHDATE</cfif>
,#dsn#.EMPLOYEE_MANDATE.UPDATE_DATE=<cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#this.DATE#">
,#dsn#.EMPLOYEE_MANDATE.UPDATE_EMP= <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.ep.userid#">
,#dsn#.EMPLOYEE_MANDATE.UPDATE_IP=<cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#cgi.REMOTE_ADDR#">
  WHERE (#dsn#.EMPLOYEE_MANDATE.MANDATE_MASTER_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.id#">) 
    </cfquery>

<cfreturn arguments.id>
</cffunction>

<cffunction name="mandate_delete" access="public" returntype="any">
    <cfargument name="id" type="numeric" required="yes">

    <cfquery name="commonquery" datasource="#DSN#">
    DELETE FROM #dsn#.EMPLOYEE_MANDATE  WHERE (workcube_devcatalyst.EMPLOYEE_MANDATE.MANDATE_MASTER_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.id#">) 
    </cfquery>
</cffunction>
</cfcomponent>
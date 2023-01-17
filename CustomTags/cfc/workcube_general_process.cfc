<!--- 
    aut : Uğur Hamurpet
    name : workcube_general_process
    desc : general Papers dababase actions
    date : 28/01/2020
    component : workcube_general_paper.cfc
    methods : {
        insert : insert general paper
    }
--->

<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset fusebox.use_period = application.systemParam.systemParam().fusebox.use_period>
    <cfif fusebox.use_period eq true>
        <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cfelse>
        <cfset dsn3 = dsn>
    </cfif>
    
    <cffunction name="select" returntype="query" access="public">
        <cfargument name="gp_id" required="no" default="0" type="numeric">
        <cfargument name="gp_paper_no" required="no" default="" type="string">

        <cfquery name="GET_GENERAL_PAPER" datasource="#dsn#">
            SELECT 
                GP.*,
                CONCAT( EMP.EMPLOYEE_NAME , ' ', EMP.EMPLOYEE_SURNAME ) AS RESPONSIBLE_EMP_NAME,
                PTR.STAGE
            FROM 
                GENERAL_PAPER AS GP
            JOIN PROCESS_TYPE_ROWS AS PTR ON GP.STAGE_ID = PTR.PROCESS_ROW_ID
            LEFT JOIN EMPLOYEES AS EMP ON GP.RESPONSIBLE_EMP = EMP.EMPLOYEE_ID
            WHERE 1 = 1
            <cfif arguments.gp_id neq 0>
                AND GP.GENERAL_PAPER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gp_id#">
            </cfif>
            <cfif len(arguments.gp_paper_no)>
                AND GP.GENERAL_PAPER_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.gp_paper_no#">
            </cfif>
        </cfquery>
        
        <cfreturn GET_GENERAL_PAPER>

    </cffunction>

    <cffunction name="insert" returntype="struct" access="public">
        <cfargument name="generalPaperParentId" required="no" type="numeric">
        <cfargument name="generalPaperNo" required="yes" type="string">
        <cfargument name="generalPaperDate" required="yes" type="string">
        <cfargument name="fuseaction" required="yes" type="string">
        <cfargument name="actionListId" required="yes" type="string">
        <cfargument name="process_stage" required="yes" type="numeric">
        <cfargument name="generalPaperNotice" required="yes" type="string">
        <cfargument name="totalValues" required="yes" type="struct">
        <cfargument name="responsibleEmp" required="no" default="0" type="numeric">
        <cfargument name="responsibleEmpPos" required="no" default="0" type="numeric">
        <cfargument name="termindate" required="no" type="string">

        <cftry>

            <cfset response = structNew()>

            <cftransaction>

                <cfif arguments.generalPaperParentId eq 0><cfset controlGeneralPaper = this.select( gp_paper_no : arguments.generalPaperNo ) />
                <cfelse><cfset controlGeneralPaper.recordcount = 0></cfif>

                <cfif controlGeneralPaper.recordcount eq 0>
                    <cfquery name="ADD_GENERAL_PAPER" datasource="#dsn#" result="generalPaperResult">
                        INSERT INTO 
                        GENERAL_PAPER(
                            GENERAL_PAPER_PARENT_ID,
                            GENERAL_PAPER_NO,
                            GENERAL_PAPER_DATE,
                            FUSEACTION,
                            ACTION_LIST_ID,
                            STAGE_ID,
                            GENERAL_PAPER_NOTICE,
                            TOTAL_VALUES,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP,
                            TERMINATE_DATE,
                            RESPONSIBLE_EMP,
                            RESPONSIBLE_EMP_POS                            
                        ) VALUES(
                            <cfif arguments.generalPaperParentId neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.generalPaperParentId#"><cfelse>NULL</cfif>,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.generalPaperNo#">,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.generalPaperDate#">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.fuseaction#">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.actionListId#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.generalPaperNotice#">,
                            <cfif structCount( arguments.totalValues )><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Replace(serializeJSON(arguments.totalValues),"//","")#">,</cfif>
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                            <cfif isdefined("arguments.termindate") and len(arguments.termindate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.termindate#"><cfelse>NULL</cfif>,
                            <cfif arguments.responsibleEmp neq 0 and arguments.responsibleEmpPos neq 0>
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.responsibleEmp#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.responsibleEmpPos#">
                            <cfelse>
                                NULL,
                                NULL
                            </cfif>
                        )
                    </cfquery>
                    <cfif arguments.generalPaperParentId eq 0>
                        <cfquery name="UPDATE_GENERAL_PAPERS" datasource="#dsn#">
                            UPDATE #dsn3#.GENERAL_PAPERS 
                            SET SYSTEM_PAPER_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#listLast(arguments.generalPaperNo,"-")#">
                            WHERE PAPER_TYPE IS NULL
                        </cfquery>
                    </cfif>
                    <cfset response.status = true>
                    <cfset response.result = generalPaperResult>
                <cfelse>
                    <cfset response.status = false>
                </cfif>
                
            </cftransaction>

           

        <cfcatch>
            <cfset response.status = false>
        </cfcatch> 

        </cftry>

        <cfreturn response>

    </cffunction>

</cfcomponent>
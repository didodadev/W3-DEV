<!--- 
    Author: Uğur Hamurpet
    Date: 04/03/2021
--->

<cfcomponent extends = "cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    
    <cffunction name = "getMessageGroup" returnType = "any" access="public">
        <cfargument name="wr_id" type="numeric" required="false" default="0">
        <cfargument name="wr_name" type="string" required="false" default="">
        <cfargument name="wr_action_wo" type="string" required="false" default="">
        <cfargument name="wr_action_wo_event" type="string" required="false" default="">
        <cfargument name="wr_action_parameter" type="string" required="false" default="">
        <cfargument name="wr_action_id" type="any" required="false" default="">
        <cfargument name="wg_new" type="boolean" required="false" default="false">
        
        <cfquery name = "getMessageGroup" datasource = "#dsn#">
            SELECT 
                WMG.*,
                (SELECT TOP 1 WMS.SEND_DATE FROM WRK_MESSAGE AS WMS WHERE WG_ID = WMG.WG_ID ORDER BY WRK_MESSAGE_ID DESC) AS SENDDATE,
                (SELECT TOP 1 WMS.MESSAGE FROM WRK_MESSAGE AS WMS WHERE WG_ID = WMG.WG_ID ORDER BY WRK_MESSAGE_ID DESC) AS LASTMESSAGE
            FROM WRK_MESSAGE_GROUP AS WMG
            <cfif not IsDefined("arguments.wg_new") or (IsDefined("arguments.wg_new") and not arguments.wg_new)>
            JOIN WRK_MESSAGE_GROUP_EMP AS WMGE ON WMG.WG_ID = WMGE.WG_ID AND WMGE.EMPLOYEE_ID = #session.ep.userid#
            </cfif>
            WHERE 1 = 1
            <cfif IsDefined("arguments.wr_id") and arguments.wr_id neq 0>
                AND WMG.WG_ID = <cfqueryparam value = "#arguments.wr_id#" CFSQLType = "cf_sql_integer">
            </cfif>
            <cfif IsDefined("arguments.wr_name") and len(arguments.wr_name)>
                AND WMG.WG_NAME LIKE <cfqueryparam value = "#arguments.wr_name#%" CFSQLType = "cf_sql_nvarchar">
            </cfif>
            <cfif IsDefined("arguments.wr_action_wo") and len(arguments.wr_action_wo)>
                AND WMG.WG_ACTION_WO = <cfqueryparam value = "#arguments.wr_action_wo#" CFSQLType = "cf_sql_nvarchar">
            </cfif>
            <cfif IsDefined("arguments.wr_action_wo_event") and len(arguments.wr_action_wo_event)>
                AND WMG.WG_ACTION_WO_EVENT = <cfqueryparam value = "#arguments.wr_action_wo_event#" CFSQLType = "cf_sql_nvarchar">
            </cfif>
            <cfif IsDefined("arguments.wr_action_parameter") and len(arguments.wr_action_parameter)>
                AND WMG.WG_ACTION_PARAMETER = <cfqueryparam value = "#arguments.wr_action_parameter#" CFSQLType = "cf_sql_nvarchar">
            </cfif>
            <cfif IsDefined("arguments.wr_action_id") and len(arguments.wr_action_id)>
                AND WMG.WG_ACTION_ID = <cfqueryparam value = "#arguments.wr_action_id#" CFSQLType = "cf_sql_integer">
            </cfif>
            ORDER BY SENDDATE DESC
        </cfquery>
        <cfreturn getMessageGroup>
    </cffunction>

    <cffunction name = "getMessageGroupFilter" returnType = "any" access = "remote" returnFormat="JSON">
        <cfargument  name="wg_name" type="string" required="false">

        <cfset getMessageGroup = this.getMessageGroup( wr_name: arguments.wg_name )>
        <cfset result = getMessageGroup.recordcount ? { status: true, data: returnData(replace(serializeJSON(getMessageGroup),"//","")) } : { status: false } />
        
        <cfreturn replace(serializeJSON(result),"//","")>
    </cffunction>

    <cffunction name = "getMessageGroupEmp" returnType = "any" access = "remote" returnFormat="JSON">
        <cfargument name="wg_id" type="numeric" required="true">

        <cfquery name = "getMessageGroupEmp" datasource = "#dsn#">
            SELECT 
                WMGE.*,
                EMP.EMPLOYEE_NAME,
                EMP.EMPLOYEE_SURNAME
            FROM WRK_MESSAGE_GROUP_EMP AS WMGE
            JOIN EMPLOYEES AS EMP ON WMGE.EMPLOYEE_ID = EMP.EMPLOYEE_ID
            WHERE
                WMGE.WG_ID = <cfqueryparam value = "#arguments.wg_id#" CFSQLType = "cf_sql_integer">
                AND WMGE.EMPLOYEE_ID <> #session.ep.userid#
        </cfquery>

        <cfreturn Replace(serializeJSON( this.returnData( Replace(serializeJSON( getMessageGroupEmp ), "//", "") ) ), "//", "") />

    </cffunction>

    <cffunction name = "addMessageGroup" returnType = "any" access="remote" returnFormat="JSON">
        <cfargument name="wg_name" type="string" required="true">
        <cfargument name="wg_action_wo" type="string" required="true">
        <cfargument name="wg_action_wo_event" type="string" required="true">
        <cfargument name="wg_action_parameter" type="string" required="true">
        <cfargument name="wg_action_id" type="string" required="true">
        <cfargument name="group_user" type="string" required="true">

        <cfset response = {} />

        <cftry>

            <cftransaction>
            
                <cfquery name = "addMessageGroup" datasource = "#dsn#" result="result">
                    INSERT INTO WRK_MESSAGE_GROUP(
                        WG_NAME,
                        WG_ACTION_WO,
                        WG_ACTION_WO_EVENT,
                        WG_ACTION_PARAMETER,
                        WG_ACTION_ID,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP
                    )VALUES(
                        <cfqueryparam value="#arguments.wg_name#" cfsqltype="cf_sql_nvarchar">,
                        <cfqueryparam value="#arguments.wg_action_wo#" cfsqltype="cf_sql_nvarchar">,
                        <cfqueryparam value="#arguments.wg_action_wo_event#" cfsqltype="cf_sql_nvarchar">,
                        <cfqueryparam value="#arguments.wg_action_parameter#" cfsqltype="cf_sql_nvarchar">,
                        <cfqueryparam value="#arguments.wg_action_id#" cfsqltype="cf_sql_integer">,
                        #session.ep.userid#,
                        #now()#,
                        <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_nvarchar">
                    )
                </cfquery>
        
                <cfloop list="#arguments.group_user#" item="item">
                    <cfquery name = "addMessageGroupEmp" datasource = "#dsn#">
                        INSERT INTO WRK_MESSAGE_GROUP_EMP(
                            WG_ID,
                            EMPLOYEE_ID
                        )VALUES(
                            <cfqueryparam value="#result.identitycol#" cfsqltype="cf_sql_integer">,
                            <cfqueryparam value="#item#" cfsqltype="cf_sql_integer">
                        )
                    </cfquery>
                </cfloop>
    
            </cftransaction>

            <cfset response = { status: true, wg_id: result.identitycol }>

        <cfcatch type="any">
            <cfset response = { status: false }>
        </cfcatch>
        </cftry>

        <cfreturn LCase(Replace(serializeJSON(response), "//", "")) />

    </cffunction>

    <cffunction name = "getUserGroup" returnType = "any" access = "public">
        <cfargument name="wr_action_wo" type="string" required="true">
        <cfargument name="wr_action_id" type="numeric" required="true">

        <cfquery name="getUserGroup" datasource="#dsn#">
            <cfif arguments.wr_action_wo eq 'project.projects'><!--- Proje Ekibini getirir --->
                SELECT
                    EMP.EMPLOYEE_ID,
                    EMP.EMPLOYEE_NAME,
                    EMP.EMPLOYEE_SURNAME,
                    EMP.PHOTO
                FROM WORKGROUP_EMP_PAR AS WEP
                JOIN EMPLOYEES AS EMP ON WEP.EMPLOYEE_ID = EMP.EMPLOYEE_ID
                WHERE WEP.PROJECT_ID = <cfqueryparam value = "#arguments.wr_action_id#" CFSQLType = "cf_sql_integer">
                ORDER BY EMP.EMPLOYEE_NAME, EMP.EMPLOYEE_SURNAME
            </cfif>
        </cfquery>

        <cfreturn getUserGroup />
    </cffunction>

</cfcomponent>
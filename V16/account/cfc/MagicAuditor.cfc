<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>


    <cffunction name="add_wizard" returntype="any">
        <cfquery name="add_wizard" datasource="#dsn#">
            INSERT INTO 
                ACCOUNT_AUDITOR_WIZARD
                (
                    WIZARD_NAME,
                    WIZARD_DESIGNER,
                    WIZARD_STAGE,
                    WIZARD_DATE,
                    PERIOD_MONTH,
                    PERIOD_DAY,
                    TARGET_TYPE,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.wizard_name#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_designer#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_stage#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.wizard_date#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_month#">,
                    <cfif len(arguments.period_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_day#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.target_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.target_type#"><cfelse>NULL</cfif>,
                    #now()#,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
                )
                SELECT SCOPE_IDENTITY() AS MAX_ID
        </cfquery>
        <cfreturn add_wizard.max_id>
    </cffunction>

    <cffunction name="add_wizard_block" returntype="any">
        <cfquery name="add_wizard_block" datasource="#dsn#">
            INSERT INTO
                ACCOUNT_AUDITOR_WIZARD_BLOCK
                (
                    WIZARD_ID,
                    BLOCK_NAME_LEFT,
                    BLOCK_NAME_RIGHT,
                    BLOCK_OPERATION,
                    BLOCK_RATE
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_id#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.block_name_left#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.block_name_right#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.block_operation#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.block_rate#">
                )
                SELECT SCOPE_IDENTITY() AS MAX_BLOCK_ID
        </cfquery>
        <cfreturn add_wizard_block.MAX_BLOCK_ID>
    </cffunction>

    <cffunction name="add_wizard_block_row" returntype="any">
        <cfquery name="add_wizard_block_row" datasource="#dsn#">
            INSERT INTO
                ACCOUNT_AUDITOR_WIZARD_BLOCK_ROW
                (
                    WIZARD_BLOCK_ID,
                    BLOCK_COLUMN,
                    ACCOUNT_CODE,
                    RATE,
                    DESCRIPTION,
                    BA,
                    ACTION_TYPE
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_block_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.block_column#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.account_code#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.rate#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.description#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ba#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.action_type_hidden#">
                )
        </cfquery>
    </cffunction>

    <cffunction name="get_wizard" returntype="any">
        <cfquery name="get_wizard" datasource="#dsn#">
            SELECT 
                AW.*,
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS DESIGNER_EMPLOYEE_FULLNAME,
                PTR.STAGE
            FROM
                ACCOUNT_AUDITOR_WIZARD AW
                LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = AW.WIZARD_DESIGNER
                LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = AW.WIZARD_STAGE
            WHERE
                1 = 1
                <cfif len(arguments.keyword)>
                    AND AW.WIZARD_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                </cfif>
        </cfquery>
        <cfreturn get_wizard>
    </cffunction>

    <cffunction name="det_wizard" returntype="string">
        <cfquery name="det_wizard" datasource = "#dsn#">
            SELECT
                AW.WIZARD_ID,
                AW.WIZARD_NAME,
                AW.WIZARD_DESIGNER,
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMPLOYEE_FULLNAME,
                AW.WIZARD_STAGE,
                CONVERT(nvarchar(10),AW.WIZARD_DATE,103) AS WIZARD_DATE,
                AW.PERIOD_MONTH,
                AW.PERIOD_DAY,
                AW.PROCESS_CAT,
                AW.TARGET_TYPE,
                AWB.WIZARD_BLOCK_ID,
                AWB.BLOCK_NAME_LEFT,
                AWB.BLOCK_NAME_RIGHT,
                AWB.BLOCK_OPERATION,
                AWB.BLOCK_RATE,
                AWBR.WIZARD_BLOCK_ROW_ID,
                AWBR.BLOCK_COLUMN,
                AWBR.ACCOUNT_CODE,
                AWBR.RATE,
                AWBR.DESCRIPTION,
                AWBR.BA,
                AWBR.ACTION_TYPE,
                AW.RECORD_EMP,
                AW.RECORD_DATE,
                AW.RECORD_IP,
                AW.UPDATE_EMP,
                AW.UPDATE_DATE,
                AW.UPDATE_IP
            FROM
                ACCOUNT_AUDITOR_WIZARD AW
                    LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = AW.WIZARD_DESIGNER
                    LEFT JOIN ACCOUNT_AUDITOR_WIZARD_BLOCK AWB ON AWB.WIZARD_ID = AW.WIZARD_ID
                    LEFT JOIN ACCOUNT_AUDITOR_WIZARD_BLOCK_ROW AWBR ON AWBR.WIZARD_BLOCK_ID = AWB.WIZARD_BLOCK_ID
            WHERE
                AW.WIZARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_id#">
            ORDER BY
                AW.WIZARD_ID,
                AWB.WIZARD_BLOCK_ID,
                AWBR.WIZARD_BLOCK_ROW_ID
        </cfquery>
        	<cfset getJSON = serializeJSON(det_wizard,'struct')>
            <cfif left(getJSON,2) eq '//'><cfset getJSON = replace(getJSON, '//', '')></cfif>
        <cfreturn getJSON/>
    </cffunction>

    <cffunction name="det_wizard2" returntype="any">
        <cfquery name="det_wizard2" datasource = "#dsn#">
            SELECT
                AW.WIZARD_ID,
                AW.WIZARD_NAME,
                AW.WIZARD_DESIGNER,
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMPLOYEE_FULLNAME,
                AW.WIZARD_STAGE,
                CONVERT(nvarchar(10),AW.WIZARD_DATE,103) AS WIZARD_DATE,
                AW.PERIOD_MONTH,
                AW.PERIOD_DAY,
                AW.PROCESS_CAT,
                AW.TARGET_TYPE,
                AWB.WIZARD_BLOCK_ID,
                AWB.BLOCK_NAME_LEFT,
                AWB.BLOCK_NAME_RIGHT,
                AWB.BLOCK_OPERATION,
                AWB.BLOCK_RATE,
                AWBR.WIZARD_BLOCK_ROW_ID,
                AWBR.BLOCK_COLUMN,
                AWBR.ACCOUNT_CODE,
                AWBR.RATE,
                AWBR.DESCRIPTION,
                AWBR.BA,
                AWBR.ACTION_TYPE,
                AW.RECORD_EMP,
                AW.RECORD_DATE,
                AW.RECORD_IP,
                AW.UPDATE_EMP,
                AW.UPDATE_DATE,
                AW.UPDATE_IP
            FROM
                ACCOUNT_AUDITOR_WIZARD AW
                    LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = AW.WIZARD_DESIGNER
                    LEFT JOIN ACCOUNT_AUDITOR_WIZARD_BLOCK AWB ON AWB.WIZARD_ID = AW.WIZARD_ID
                    LEFT JOIN ACCOUNT_AUDITOR_WIZARD_BLOCK_ROW AWBR ON AWBR.WIZARD_BLOCK_ID = AWB.WIZARD_BLOCK_ID
            WHERE
                AW.WIZARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_id#">
            ORDER BY
                AW.WIZARD_ID,
                AWB.WIZARD_BLOCK_ID,
                AWBR.WIZARD_BLOCK_ROW_ID
        </cfquery>
        <cfreturn det_wizard2 >
    </cffunction>

    <cffunction name="upd_wizard" returntype="any">
        <cfquery name="upd_wizard" datasource="#dsn#">
            UPDATE
                ACCOUNT_AUDITOR_WIZARD
            SET
                WIZARD_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.wizard_name#">,
                WIZARD_DESIGNER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_designer#">,
                WIZARD_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_stage#">,
                WIZARD_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.wizard_date#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                UPDATE_DATE = #now()#,
                PERIOD_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_month#">,
                PERIOD_DAY =  <cfif len(arguments.period_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_day#"><cfelse>NULL</cfif>,
                TARGET_TYPE = <cfif len(arguments.target_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.target_type#"><cfelse>NULL</cfif>
            WHERE
                WIZARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_id#">
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="get_wizard_block" returntype="any">
        <cfquery name = "get_wizard_block" datasource = "#dsn#">
            SELECT WIZARD_BLOCK_ID FROM ACCOUNT_AUDITOR_WIZARD_BLOCK WHERE WIZARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_id#">
        </cfquery>
        <cfreturn get_wizard_block>
    </cffunction>

    <cffunction name="del_wizard" returntype="any">
        <cfquery name = "del_wizard" datasource = "#dsn#">
            DELETE FROM ACCOUNT_AUDITOR_WIZARD WHERE WIZARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_id#">
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="del_wizard_block" returntype="any">
        <cfquery name = "del_wizard_block" datasource = "#dsn#">
            DELETE FROM ACCOUNT_AUDITOR_WIZARD_BLOCK WHERE WIZARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_id#">
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="del_wizard_block_row" returntype="any">
        <cfquery name = "del_wizard_block_row" datasource = "#dsn#">
            DELETE FROM ACCOUNT_AUDITOR_WIZARD_BLOCK_ROW WHERE WIZARD_BLOCK_ID IN (#arguments.block_id#)
        </cfquery>
        <cfreturn 1>
    </cffunction>
</cfcomponent>